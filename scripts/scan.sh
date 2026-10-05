#!/usr/bin/env bash
# Code Armour quick scan. Finds common leaks and missing protections.
# Usage: bash scan.sh [project-dir] [live-url]
# A clean result is NOT proof of safety: it only catches known patterns.

# Speed: macOS's built-in grep is very slow on big repos (72 s vs 1 s on a 22,000-file project). If ripgrep
# (rg) is installed, recursive searches use it, with grep's options translated; everything else uses grep.
# Set CA_NO_RG=1 to force plain grep.
if command -v rg >/dev/null 2>&1 && [ -z "${CA_NO_RG:-}" ]; then
grep() {
  local a rec=0 havepat=0 pat="" i
  local out=() rest=()
  for a in "$@"; do
    if [ $havepat = 0 ] && [ "${a#-}" != "$a" ]; then
      case "$a" in
        --exclude-dir=*) out+=(-g "!${a#--exclude-dir=}");;
        --exclude=*) out+=(-g "!${a#--exclude=}");;
        --include=*) out+=(-g "${a#--include=}");;
        --*) command grep "$@"; return;;
        -*) for ((i=1; i<${#a}; i++)); do
              case "${a:i:1}" in
                r|R) rec=1;; I|E) ;; n) out+=(-n);; o) out+=(-o);; l) out+=(-l);; i) out+=(-i);;
                q) out+=(-q);; h) out+=(--no-filename);; H) out+=(--with-filename);; s) out+=(--no-messages);;
                *) command grep "$@"; return;;
              esac
            done;;
      esac
    elif [ $havepat = 0 ]; then pat="$a"; havepat=1
    else rest+=("$a"); fi
  done
  if [ $rec = 0 ]; then command grep "$@"; return; fi
  [ ${#rest[@]} = 0 ] && rest=(.)
  rg --hidden --no-ignore --no-config --no-messages "${out[@]}" -e "$pat" -- "${rest[@]}"
}
fi

DIR="${1:-.}"
URL="${2:-}"
cd "$DIR" || { echo "Can't open $DIR"; exit 1; }

RED=$'\e[31m'; YEL=$'\e[33m'; GRN=$'\e[32m'; RST=$'\e[0m'
problems=0
bad()  { echo "${RED}✗ $*${RST}"; problems=$((problems+1)); }
warn() { echo "${YEL}? $*${RST}"; }
ok()   { echo "${GRN}✓ $*${RST}"; }

# Secret patterns: Stripe secret/restricted, OpenAI/Anthropic, Supabase secret/service_role,
# Google API keys, GitHub tokens, Slack tokens, AWS keys, private keys.
SECRETS='(sk_live_[0-9A-Za-z]{10,}|sk_test_[0-9A-Za-z]{10,}|rk_live_[0-9A-Za-z]{10,}|sk-ant-[0-9A-Za-z_-]{10,}|sk-proj-[0-9A-Za-z_-]{10,}|sk-[A-Za-z0-9]{32,}|sb_secret_[0-9A-Za-z_-]{10,}|InJvbGUiOiJzZXJ2aWNlX3Jv|b2xlIjoic2VydmljZV9yb2xl|cm9sZSI6InNlcnZpY2Vfcm9s|AIza[0-9A-Za-z_-]{35}|gh[pousr]_[0-9A-Za-z]{30,}|xox[baprs]-[0-9A-Za-z-]{10,}|AKIA[0-9A-Z]{16}|-----BEGIN [A-Z ]*PRIVATE KEY-----|whsec_[0-9A-Za-z]{10,}|postgres(ql)?://[^:@/[:space:]]+:[^@/[:space:]]+@|mongodb(\+srv)?://[^:@/[:space:]]+:[^@/[:space:]]+@|GOCSPX-[0-9A-Za-z_-]{10,})'
EXCL=(--exclude-dir=node_modules --exclude-dir=.git --exclude-dir=.netlify --exclude-dir=.next/cache --exclude=*.lock --exclude=package-lock.json --exclude=scan.sh --exclude=audit.sql)

echo "== Code Armour scan: $(pwd) =="
# Huge files (generated bundles, word lists, data) make every text search crawl. Skip files over 1 MB in the
# pattern searches and SAY which ones, so nothing is silently ignored.
BIGF=$(find . -type f -size +1000k -not -path '*/node_modules/*' -not -path '*/.git/*' 2>/dev/null | head -50)
for b in $BIGF; do EXCL+=(--exclude="$(basename "$b")"); done

echo; echo "-- 1. Secrets in source files --"
[ -n "$BIGF" ] && warn "Skipped $(echo "$BIGF" | wc -l | tr -d ' ') file(s) over 1 MB in text searches (bundles/data; secrets in them are still caught by gitleaks/semgrep if installed): $(echo $BIGF | cut -c1-160)"
# -o prints only the matched secret; we then mask it so the scan output never shows a whole key.
mask() { sed -E 's/^([^:]+:[0-9]+:)(.{0,14}).*/  \1 \2…/'; }
hits=$(grep -rInoE "${EXCL[@]}" --exclude-dir=dist --exclude-dir=build --exclude-dir=.next --exclude-dir=out \
  --exclude=.env --exclude=.env.* "$SECRETS" . 2>/dev/null | grep -v '\.env\.example' | head -20)
if [ -n "$hits" ]; then bad "Possible secrets in source (move to server env vars, then ROTATE them):"; echo "$hits" | mask; else ok "No secret patterns in source"; fi

echo; echo "-- 2. Secrets in built files (what visitors download) --"
found_build=0; build_bad=0
for b in dist build out .next/static public; do
  [ -d "$b" ] || continue; found_build=1
  hits=$(grep -rIlE "$SECRETS" "$b" 2>/dev/null | head -10)
  if [ -n "$hits" ]; then bad "Secrets inside $b/ (anyone can read these):"; echo "$hits"; build_bad=1; fi
done
if [ $found_build = 0 ]; then
  if [ -f index.html ]; then ok "Static site: these files ARE what visitors download (already checked in step 1)"
  else warn "No build folder found. Run your build, then scan again to check the real output."; fi
fi
[ $found_build = 1 ] && [ $build_bad = 0 ] && ok "No secret patterns in build output"

echo; echo "-- 3. Public env var prefixes holding secrets --"
hits=$(grep -rInE "${EXCL[@]}" '(VITE_|NEXT_PUBLIC_|REACT_APP_|PUBLIC_|EXPO_PUBLIC_|NUXT_PUBLIC_)[A-Z_]*(SECRET|SERVICE_ROLE|PRIVATE|STRIPE_SK|OPENAI|ANTHROPIC|GEMINI|WEBHOOK|DATABASE_URL|CLERK_SECRET)' . 2>/dev/null | head -10)
[ -n "$hits" ] && { bad "Secret-looking names with a PUBLIC prefix (these get baked into the browser code):"; echo "$hits" | cut -c1-200; } || ok "No secret names with public prefixes"

echo; echo "-- 3b. Admin keys used in browser code --"
CLIENT_DIRS=$(for d in src app components pages public lib; do [ -d "$d" ] && echo "$d"; done)
if [ -n "$CLIENT_DIRS" ]; then
  hits=$(grep -rInE "${EXCL[@]}" --exclude-dir=api --exclude-dir=server --exclude-dir=functions \
    '(SERVICE_ROLE|service_role|sb_secret_|STRIPE_SECRET|stripe_secret|OPENAI_API_KEY|ANTHROPIC_API_KEY)' $CLIENT_DIRS 2>/dev/null \
    | grep -vE '^[^:]+\.(sql|md)(:|$)' | grep -vE "import ['\"]server-only['\"]" | head -10)
  if [ -n "$hits" ]; then
    bad "Secret key names used in front-end folders (if this code runs in the browser, the key leaks; Next.js server files: add import 'server-only'):"
    echo "$hits" | cut -c1-200
  else ok "No secret key names in front-end folders"; fi
fi
envs=$(ls -a 2>/dev/null | grep -E '^\.env' | grep -v '\.example$')
for e in $envs; do
  ks=$(grep -oE "$SECRETS" "$e" 2>/dev/null | cut -c1-12 | sort -u | tr '\n' ' ')
  [ -n "$ks" ] && warn "$e holds secret keys ($ks...): fine ONLY if it's git-ignored and those names have no public prefix"
done

echo; echo "-- 4. .env handling --"
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then   # works in worktrees and subfolders too
  tracked=$(git ls-files | grep -E '(^|/)\.env($|\.)' | grep -v '\.env\.example$')
  [ -n "$tracked" ] && bad ".env files are committed to git: $tracked (remove, add to .gitignore, ROTATE keys)" || ok "No .env files tracked by git"
  grep -qE '^\.env' .gitignore 2>/dev/null && ok ".gitignore covers .env" || bad ".gitignore doesn't list .env*"
  echo; echo "-- 5. Secrets in git history --"
  # gitleaks reads git's storage directly: fast even on big repos, ~200 key types. Exit 1 means leaks OR an
  # error, so only trust a written report. Without a working gitleaks, the built-in check runs instead.
  GLOK=""
  if command -v gitleaks >/dev/null; then
    GL=$(mktemp); rm -f "$GL"
    gitleaks git --no-banner --redact --report-format json --report-path "$GL" . >/dev/null 2>&1
    if [ ! -s "$GL" ]; then warn "gitleaks didn't produce a report (error?): relying on the built-in check"
    else
      n=$(grep -o '"RuleID"' "$GL" | wc -l | tr -d ' ')
      if [ "$n" -gt 0 ]; then bad "gitleaks: $n secret(s) in git history (ROTATE them):"
        grep -oE '"(RuleID|File|StartLine)": *("[^"]*"|[0-9]+)' "$GL" | paste - - - | head -8 | sed -E 's/"//g; s/^/   /' | cut -c1-140
      else ok "gitleaks: no secrets in git history"; fi
      GLOK=1
    fi
  fi
  if [ -z "$GLOK" ]; then
    # Built-in: -G lets git skip commits without a match. Skips Code Armour's own tool files (they contain the
    # detection patterns; a copy of this scanner in the history would otherwise flag itself forever).
    hist=$(git log --all -p --extended-regexp -G "$SECRETS" -- . ':(exclude,glob)**/scan.sh' ':(exclude,glob)**/audit.sql' ':(exclude,glob)**/harness.mjs' 2>/dev/null | grep -oE "$SECRETS" | sort -u | head -10 | cut -c1-14 | sed 's/$/…/')
    [ -n "$hist" ] && { bad "Secret patterns in git history (ROTATE these keys; deleting the file doesn't help):"; echo "$hist"; } || ok "No secret patterns in git history (built-in check; install gitleaks for a faster, deeper one)"
  fi
else
  warn "Not a git repo. Use git + GitHub so you have history and secret scanning."
fi

echo; echo "-- 6. Risky code patterns (review each) --"
grep -rInE "${EXCL[@]}" --include=*.js --include=*.jsx --include=*.ts --include=*.tsx --include=*.vue --include=*.svelte --include=*.html \
  --exclude-dir=dist --exclude-dir=build --exclude-dir=.next --exclude=*.min.js --exclude=*bundle*.js --exclude=*.bundle.* \
  '(innerHTML\s*=|dangerouslySetInnerHTML|v-html|document\.write|insertAdjacentHTML|eval\(|new Function\()' . 2>/dev/null | head -15 > /tmp/ca-xss.txt
[ -s /tmp/ca-xss.txt ] && { sed 's/^/  XSS? /' /tmp/ca-xss.txt | cut -c1-200; echo "  (XSS? = page content set as HTML: safe only if the text is escaped/sanitised; use textContent or DOMPurify)"; }
# Migrations are history: an old file may turn RLS off and a LATER one turn it back on. Only flag it
# if no later file in the same folder re-enables RLS on that table (audit.sql checks the real final state).
rlsoff=""
while IFS= read -r hit; do
  [ -z "$hit" ] && continue
  f=${hit%%:*}; tbl=$(echo "$hit" | grep -oiE 'alter table +(if exists +)?([a-z_]+\.)?"?[a-z0-9_]+' | awk '{print $NF}' | sed 's/.*\.//; s/"//g')
  later=$(ls "$(dirname "$f")" 2>/dev/null | sort | awk -v cur="$(basename "$f")" '$0 > cur' | while read -r g; do
    grep -qiE "alter table +(if exists +)?([a-z_]+\.)?\"?$tbl\"? +enable row level security" "$(dirname "$f")/$g" && echo yes; done | head -1)
  [ -n "$tbl" ] && [ -n "$later" ] && { ok "RLS off for $tbl in $(basename "$f") is undone by a later migration"; continue; }
  rlsoff="$rlsoff$hit"$'\n'
done < <(grep -rInEi "${EXCL[@]}" 'disable row level security' . 2>/dev/null | grep -vE ':[0-9]+:\s*--' | head -10)
[ -n "$rlsoff" ] && { bad "RLS turned off (anyone with the public key can read/write the table):"; printf '%s' "$rlsoff" | cut -c1-200; }
db_hits=$(grep -rInE "${EXCL[@]}" --exclude-dir=dist --exclude-dir=build '(using\s*\(\s*true\s*\)|with check\s*\(\s*true\s*\)|security definer|user_metadata)' . 2>/dev/null | grep -vE ':[0-9]+:\s*--' | head -15)
[ -n "$db_hits" ] && { echo "$db_hits" | sed 's/^/  DB? /' | cut -c1-200; echo "  (DB? = using(true) is only OK on truly public data; security definer skips RLS; user_metadata is editable by users)"; }
prompt_hits=$(grep -rInEi "${EXCL[@]}" --exclude-dir=dist --exclude-dir=build '(password|passwd|api[_ ]?key|secret)[^"\x27`]{0,20}(is|:|=)\s*["\x27`]?[A-Za-z0-9]' --include=*.js --include=*.mjs --include=*.ts --include=*.py . 2>/dev/null \
  | grep -iE '(system|prompt|content:)' | head -5)
[ -n "$prompt_hits" ] && { echo "$prompt_hits" | sed 's/^/  PROMPT? /' | cut -c1-200; echo "  (PROMPT? = a secret inside an AI prompt: assume users can make the AI reveal it)"; }
price_hits=$(grep -rInE "${EXCL[@]}" --exclude-dir=dist --exclude-dir=build '(unit_amount|amount)\s*:\s*[a-zA-Z_.]*(body|req|price|amount|params|query)' --include=*.js --include=*.mjs --include=*.ts . 2>/dev/null | head -5)
[ -n "$price_hits" ] && { echo "$price_hits" | sed 's/^/  PRICE? /' | cut -c1-200; echo "  (PRICE? = check the price comes from the server, not from what the browser sent)"; }
grep -rInE "${EXCL[@]}" --exclude-dir=dist --exclude-dir=build '(verify_jwt\s*=\s*false|jwt\.decode\(|unit_amount:\s*(req|body|request)|\.update\((req\.)?body\)|\.insert\((req\.)?body\))' . 2>/dev/null | head -10 | sed 's/^/  API? /' | cut -c1-200
stripe_files=$(grep -rlE "${EXCL[@]}" --include=*.js --include=*.mjs --include=*.ts "from ['\"]stripe['\"]|require\(['\"]stripe['\"]\)" . 2>/dev/null | head -5)
if [ -n "$stripe_files" ]; then
  grep -rqE "${EXCL[@]}" 'constructEvent' . 2>/dev/null && ok "Stripe webhook signature check found" \
    || bad "Stripe used ($(echo $stripe_files | tr '\n' ' ')) but no webhooks.constructEvent (webhook signature check) found"
fi

echo; echo "-- 6b. Firebase / other backends --"
for f in $(find . -path ./node_modules -prune -o \( -name 'firestore.rules' -o -name 'storage.rules' -o -name 'database.rules.json' \) -print 2>/dev/null); do
  grep -qE 'if true|request\.time *<|"\.(read|write)" *: *true' "$f" && bad "$f has open/test-mode rules (anyone can read or write)" || ok "$f has no open rules"
done
sa=$(grep -rlE "${EXCL[@]}" '"type": *"service_account"' . 2>/dev/null | head -5)
[ -n "$sa" ] && bad "Service-account key file(s) in the project (full admin access, never commit or ship): $sa"
grep -rqE "${EXCL[@]}" --include=*.ts --include=*.tsx --include=*.js '"use server"' . 2>/dev/null && warn "Next.js Server Actions found: each one must check the login inside it (middleware isn't enough)"

echo; echo "-- 6d. GitHub Actions, shortcuts, desktop, bots (security.md section 15) --"
if ls .github/workflows/*.y*ml >/dev/null 2>&1; then
  W=.github/workflows
  prt=$(grep -lE "pull_request_target" $W/*.y*ml 2>/dev/null)
  for f in $prt; do grep -qE "head\.(sha|ref)" "$f" && bad "$f: pull_request_target + checks out the PR's code = strangers' code runs with your secrets (15.1)" || warn "$f uses pull_request_target: only for labelling/commenting (15.1)"; done
  inj=$(grep -nE '\$\{\{ *github\.event\.(issue|pull_request|comment|review|head_commit)\.[a-z_.]*(title|body|message|name|label)' $W/*.y*ml 2>/dev/null | grep -E "run:|^\S+:[0-9]+:\s+[^ ]" | head -5)
  [ -n "$inj" ] && { bad "Workflow puts issue/PR text straight into a script (script injection, 15.2): pass it through env:"; echo "$inj" | cut -c1-160; }
  unp=$(grep -nE "uses: *[^@ ]+@(v?[0-9]+(\.[0-9]+)*|main|master)\s*$" $W/*.y*ml 2>/dev/null | grep -vE "uses: *(actions|github)/" | head -5)
  [ -n "$unp" ] && { warn "Third-party actions pinned to a movable tag, not a commit SHA (15.3):"; echo "$unp" | cut -c1-160; } || ok "Third-party actions pinned (or none)"
fi
short=$(grep -rnE "${EXCL[@]}" --exclude-dir=dist --exclude-dir=build 'rejectUnauthorized: *false|NODE_TLS_REJECT_UNAUTHORIZED *= *.?0|verify *= *False|InsecureSkipVerify: *true' . 2>/dev/null | grep -vE ':[0-9]+:\s*(//|#)' | head -5)
[ -n "$short" ] && { bad "Security check turned off to 'make it work' (15.33):"; echo "$short" | cut -c1-160; }
elec=$(grep -rnE "${EXCL[@]}" --exclude-dir=dist --exclude-dir=build 'nodeIntegration: *true|contextIsolation: *false|webSecurity: *false|exposeInMainWorld\(.*ipcRenderer' . 2>/dev/null | head -5)
[ -n "$elec" ] && { bad "Unsafe Electron setting: any XSS becomes control of the computer (15.27):"; echo "$elec" | cut -c1-160; }
bots=$(grep -rnoE "${EXCL[@]}" --exclude-dir=dist --exclude-dir=build '[MN][A-Za-z0-9_-]{23,25}\.[A-Za-z0-9_-]{6}\.[A-Za-z0-9_-]{27,}|[0-9]{8,10}:AA[A-Za-z0-9_-]{33}' . 2>/dev/null | head -3)
[ -n "$bots" ] && { bad "Discord/Telegram bot token in the code (15.26): move it to an env var and reset it:"; echo "$bots" | mask; }
if grep -rqlE "${EXCL[@]}" --exclude-dir=dist --exclude-dir=build 'cf-turnstile|h-captcha|hcaptcha\.com/1/api|turnstile\.render|grecaptcha' . 2>/dev/null; then
  grep -rqE "${EXCL[@]}" 'siteverify|recaptcha/api/siteverify|captchaToken' . 2>/dev/null && ok "CAPTCHA is verified on the server" || bad "CAPTCHA widget found but no server check (siteverify): bots just skip it (15.10)"
fi
hosth=$(grep -rnE "${EXCL[@]}" --exclude-dir=dist --exclude-dir=build "(headers\.host|headers\[.x-forwarded-host.\]|req\.get\(.host.\)).*(reset|verify|confirm|magic|link|url)|(reset|verify|confirm|magic).*(headers\.host|req\.get\(.host.\))" . 2>/dev/null | head -3)
[ -n "$hosth" ] && { bad "Email links built from the request's Host header (password-reset poisoning, 15.7): use a fixed SITE_URL:"; echo "$hosth" | cut -c1-160; }

echo; echo "-- 6e. Legal red flags in the code (legal.md section 14; warnings: check whether the rule applies) --"
SRC_INC=(--include=*.js --include=*.jsx --include=*.ts --include=*.tsx --include=*.mjs --include=*.vue --include=*.svelte --include=*.html --include=*.py --exclude=*.min.js --exclude=*bundle* --exclude=*-mcp.mjs)
lgi() { grep -rliE "${EXCL[@]}" --exclude-dir=dist --exclude-dir=build "${SRC_INC[@]}" "$1" . 2>/dev/null | head -3 | tr '\n' ' '; }
lg() { grep -rlE "${EXCL[@]}" --exclude-dir=dist --exclude-dir=build "${SRC_INC[@]}" "$1" . 2>/dev/null | head -3 | tr '\n' ' '; }
f=$(lg '<video|youtube\.com/embed|player\.vimeo|mux-player'); p=$(lg 'fbq\(|connect\.facebook\.net|analytics\.tiktok\.com|snaptr\(')
[ -n "$f" ] && [ -n "$p" ] && warn "Video + ad pixel ($f/ $p): US VPPA class actions. No pixels on video pages, or get opt-in (legal 14)"
f=$(lgi "from ['\"](twilio|@vonage/server-sdk|messagebird|plivo|telnyx)['\"]|require\(['\"](twilio|plivo|telnyx)['\"]\)|sendSms\(|PhoneNumber:"); [ -n "$f" ] && warn "Sends SMS ($f): US TCPA needs written consent, STOP handling, 8am-9pm only (legal 14)"
f=$(lg "(from|require\()\s*\(?['\"](face-api(\.js)?|@vladmandic/(human|face-api)|@tensorflow-models/face-(landmarks-detection|detection)|@mediapipe/(face_mesh|tasks-vision))['\"]"); [ -n "$f" ] && warn "Face or voice processing ($f): Illinois BIPA (\$1,000-\$5,000 per person). Keep it on-device, store nothing, or get written consent (legal 14)"
f=$(lg "from ['\"](ethers|web3|@solana/web3\.js|wagmi|viem)['\"]|require\(['\"](ethers|web3)['\"]\)"); [ -n "$f" ] && warn "Crypto wallet code ($f): MiCA (EU), securities law (US), app-store rules. Teen dev: no tokens, no holding user funds (legal 14)"
f=$(lgi '(you are|act as|be) (my |their |a |the user.s )?(girlfriend|boyfriend|companion|best friend|lover)'); [ -n "$f" ] && warn "AI companion persona ($f): California SB 243 and New York rules: 'not a human' notices, crisis protocol, minors (legal 9 and 14)"
f=$(lg 'GatewayIntentBits\.MessageContent|Intents\.FLAGS\.MESSAGE_CONTENT|IntentsBitField\.Flags\.MessageContent'); [ -n "$f" ] && warn "Discord bot uses the privileged message-content intent ($f): justify it or use slash commands (legal 14)"
for m in $(find . -name manifest.json -not -path '*/node_modules/*' 2>/dev/null | while read -r f; do grep -q '"manifest_version"' "$f" && echo "$f"; done | head -3); do
  grep -qE '"manifest_version" *: *2' "$m" && bad "$m is Manifest V2: Chrome removed MV2 extensions (legal 14)"
  grep -qE '<all_urls>|"\*://\*/\*"|"https?://\*/\*"' "$m" && warn "$m asks for all websites: Chrome Web Store wants the narrowest permissions (14.3, legal 14)"
  grep -qE '"externally_connectable"[^}]*"\*"' "$m" && warn "$m lets any site message the extension (15.29)"
done
gr=$(grep -rhoE "targetSdk(Version)? *[=:]? *[0-9]+" --include=*.gradle --include=*.kts --include=app.json . 2>/dev/null | grep -oE "[0-9]+$" | sort -n | head -1)
[ -n "$gr" ] && [ "$gr" -lt 36 ] && warn "Android targetSdk $gr: Google Play needs 36 for new apps and updates (from 31 Aug 2026)"
if [ -d ios ]; then
  find ios -name PrivacyInfo.xcprivacy 2>/dev/null | grep -q . || warn "iOS app without PrivacyInfo.xcprivacy: Apple requires privacy manifests (legal 14)"
  grep -rqs ITSAppUsesNonExemptEncryption ios/ app.json 2>/dev/null || warn "iOS: ITSAppUsesNonExemptEncryption not set (set false if you only use HTTPS/OS encryption)"
fi

echo; echo "-- 6f. Third-sweep checks (security.md 16, legal.md 15) --"
dev=$( { grep -nE '"(start|serve|prod)"\s*:\s*"[^"]*(vite( |$|")|next dev|react-scripts start|--host)' package.json 2>/dev/null; grep -nE "host:\s*(true|['\"]0\.0\.0\.0)" vite.config.* 2>/dev/null; } | head -3)
[ -n "$dev" ] && { bad "Dev server used as the start command or open to the network (16.1: Vite/Next dev servers leak files):"; echo "$dev" | cut -c1-140; }
# (loops, not xargs: GNU xargs runs grep on empty input and reports "(standard input)")
rtc=$(grep -rlE "${EXCL[@]}" --exclude-dir=dist --exclude-dir=build "${SRC_INC[@]}" "new RTCPeerConnection" . 2>/dev/null | while read -r f; do grep -q "iceTransportPolicy" "$f" || echo "$f"; done | head -3 | tr '\n' ' ')
[ -n "$rtc" ] && warn "WebRTC without iceTransportPolicy 'relay' ($rtc): peer-to-peer reveals players' home IPs (16.6)"
csvf=$(lg "text/csv|json2csv|csv-stringify|Papa\.unparse"); [ -n "$csvf" ] && warn "CSV export ($csvf): escape cells starting with = + - @ (formula injection, 16.3)"
urg=$(lgi "(offer|sale|deal|price) ends (in|at|soon)|only [0-9]+ left in stock|selling fast|limited[- ]time offer"); [ -n "$urg" ] && warn "Urgency wording/timers ($urg): only real deadlines and stock (UK CMA, EU; legal 15)"
for r in public/robots.txt static/robots.txt robots.txt; do [ -f "$r" ] && grep -qiE "disallow:.*(admin|dashboard|internal|private|backup|staging)" "$r" && warn "$r lists private paths: robots.txt is a map for attackers, not protection (16.2)"; done
gql=$(grep -rnE "${EXCL[@]}" --exclude-dir=dist --exclude-dir=build "introspection:\s*true" . 2>/dev/null | head -2); [ -n "$gql" ] && bad "GraphQL introspection on (16.4): turn it off in production"
yt=$(lg "youtube\.com/(embed|iframe_api)"); [ -n "$yt" ] && warn "YouTube embeds ($yt): on kids' pages use youtube-nocookie.com behind click-to-load (legal 15)"
img=$(grep -rlE "${EXCL[@]}" --exclude-dir=dist --exclude-dir=build "${SRC_INC[@]}" "images\.(generate|edit)\(|replicate\.run\(|fal\.(run|subscribe)\(|api\.stability\.ai|/v1/images/(generations|edits)" . 2>/dev/null | while read -r f; do grep -qiE "moderation|moderations\.create|safety_checker|nsfw" "$f" || echo "$f"; done | head -3 | tr '\n' ' ')
[ -n "$img" ] && bad "AI image generation with no moderation ($img): CSAM/deepfake law, API bans (16.5, legal 15)"

echo; echo "-- 6c. Trackers and third parties (privacy laws, kids) --"
grep -rlE "${EXCL[@]}" --exclude-dir=dist --exclude-dir=build 'fonts\.googleapis\.com|fonts\.gstatic\.com' . 2>/dev/null | head -3 | sed 's/^/  ? Google Fonts loaded from Google (self-host them; a German court fined this): /'
grep -rlE "${EXCL[@]}" --exclude-dir=dist --exclude-dir=build 'googletagmanager\.com|google-analytics\.com|gtag\(|connect\.facebook\.net|fbq\(|analytics\.tiktok\.com|hotjar|clarity\.ms|fullstory' . 2>/dev/null | head -5 | sed 's/^/  ? Tracker or analytics script (needs consent in EU\/UK; risky with kids; US pixel lawsuits): /'

echo; echo "-- 7. Source maps in build --"
maps=$(find dist build out .next/static -name '*.map' 2>/dev/null | head -5)
[ -n "$maps" ] && warn "Source maps will be public (your full source code): $maps" || ok "No source maps in build"

echo; echo "-- 8. Dependencies --"
pkgs=$(find . -name package.json -not -path "*/node_modules/*" 2>/dev/null | head -20)
if [ -n "$pkgs" ]; then   # root or any sub-package (monorepos)
  locks=$(find . -name package-lock.json -not -path '*/node_modules/*' 2>/dev/null | head -20)
  if [ -z "$locks" ]; then
    warn "No package-lock.json: commit a lockfile and use npm ci (protects against surprise package changes)"
  else
    for l in $locks; do d=$(dirname "$l")
      (cd "$d" && npm audit --audit-level=high >/tmp/ca-audit.txt 2>&1) && ok "npm audit ($d): no high/critical" || { bad "npm audit ($d) found high/critical issues:"; tail -6 /tmp/ca-audit.txt; }
    done
  fi
  echo "  New packages? Check each on npmjs.com (age, downloads, real repo). AI sometimes invents package names."
fi

echo; echo "-- 8b. Code Armour setup (can this project re-test itself?) --"
if [ -f COMPLIANCE.md ]; then
  ok "COMPLIANCE.md exists"
  last=$(grep -oE 'Last re-test: *[0-9]{4}-[0-9]{2}-[0-9]{2}' COMPLIANCE.md | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' | head -1)
  [ -z "$last" ] && last=$(grep -oE 'Checked: *[0-9]{4}-[0-9]{2}-[0-9]{2}' COMPLIANCE.md | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' | head -1)
  if [ -n "$last" ]; then
    age=$(( ( $(date +%s) - $(date -j -f %Y-%m-%d "$last" +%s 2>/dev/null || date -d "$last" +%s 2>/dev/null || date +%s) ) / 86400 ))
    [ "$age" -gt 90 ] && warn "Last re-test was $age days ago ($last): run bash security-tests/run.sh again" || ok "Last re-test $age days ago ($last)"
  else warn "COMPLIANCE.md has no date (use YYYY-MM-DD after 'Last re-test:')"; fi
  todo=$(grep -cE '\| *(❌|❓)' COMPLIANCE.md 2>/dev/null)
  [ "${todo:-0}" -gt 0 ] && warn "COMPLIANCE.md still has $todo ❌/❓ item(s) open"
else warn "No COMPLIANCE.md yet: run the Code Armour skill to make one"; fi
if [ -f security-tests/run.sh ]; then
  ok "Saved re-test found (security-tests/run.sh)"
  n=$(cat security-tests/*.test.mjs 2>/dev/null | grep -vE '^[[:space:]]*//' | grep -oE '(^|[^a-zA-Z_.])check\(' | wc -l | tr -d ' ')
  [ "$n" -le 1 ] && warn "security-tests has no real attack checks yet (only the template): add this project's attacks" || ok "$n attack checks saved (loops can run some more than once)"
  { [ -d supabase/migrations ] && [ ! -d node_modules/@electric-sql/pglite ]; } && warn "Database tests need: npm i -D @electric-sql/pglite"
else warn "No saved re-test (security-tests/run.sh): fixes can be undone without anyone noticing"; fi
ls .github/workflows/*.yml >/dev/null 2>&1 && grep -lq 'security-tests/run.sh' .github/workflows/*.yml 2>/dev/null \
  && ok "GitHub re-tests every push" || warn "GitHub doesn't re-test on push (add templates/security-tests/github-workflow.yml)"

# Reads a JSON file with node (or python3) and prints summary lines.
jsum() { if command -v node >/dev/null; then node -e "$1" "$2"; else echo "? ?"; fi; }

echo; echo "-- 10. Power tools (used automatically when installed; CA_FAST=1 skips them) --"
if [ -n "${CA_FAST:-}" ]; then warn "Skipped (CA_FAST set)"; else
  tips=""
  # Dependencies in every ecosystem (npm, pnpm, yarn, bun, pip, poetry, go, cargo...) + known malicious packages (MAL-)
  if command -v osv-scanner >/dev/null; then
    O=$(mktemp); osv-scanner scan source -r --format json . > "$O" 2>/dev/null; oc=$?
    if [ $oc = 128 ]; then ok "osv-scanner: no lockfiles to check"
    elif [ -s "$O" ]; then
      res=$(jsum 'const d=JSON.parse(require("fs").readFileSync(process.argv[1]));let mal=[],hi=[],lo=[];for(const r of d.results||[])for(const p of r.packages||[]){const ids=(p.vulnerabilities||[]).map(v=>v.id);const sev=Math.max(0,...(p.groups||[]).map(g=>parseFloat(g.max_severity)||0));const t=p.package.name+"@"+p.package.version+"("+ids.slice(0,2).join(",")+(sev?";"+sev:"")+")";if(ids.some(i=>i.startsWith("MAL-")))mal.push(t);else if(sev>=7)hi.push(t);else lo.push(t)}console.log("MAL "+mal.length+" "+mal.slice(0,5).join(" "));console.log("HIGH "+hi.length+" "+hi.slice(0,6).join(" "));console.log("LOW "+lo.length)' "$O")
      m=$(echo "$res" | awk '/^MAL/{print $2}'); h=$(echo "$res" | awk '/^HIGH/{print $2}'); l=$(echo "$res" | awk '/^LOW/{print $2}')
      [ "${m:-0}" != 0 ] && bad "osv-scanner: MALICIOUS package(s): $(echo "$res" | grep ^MAL | cut -d' ' -f3-) (remove now, rotate secrets on this machine)"
      [ "${h:-0}" != 0 ] && bad "osv-scanner: $h package(s) with high/critical vulnerabilities: $(echo "$res" | grep ^HIGH | cut -d' ' -f3- | cut -c1-220)"
      [ "${m:-0}" = 0 ] && [ "${h:-0}" = 0 ] && ok "osv-scanner: no malicious or high-severity packages (${l:-0} lower-severity)"
      [ "${l:-0}" != 0 ] && [ "${h:-0}" = 0 ] && warn "osv-scanner: $l lower-severity issue(s): update when you can (accepted ones go in osv-scanner.toml with a reason)"
    else warn "osv-scanner ran but wrote no report (error?)"; fi
  else tips="$tips osv-scanner"; fi
  # Code analysis: Semgrep CE with free registry rules, no account, metrics off
  if command -v semgrep >/dev/null; then
    S=$(mktemp); semgrep scan --metrics off --quiet --max-target-bytes 300000 --timeout 5 --exclude dist --exclude build --exclude .next --exclude "*.min.js" --config p/javascript --config p/typescript --config p/react --config p/nextjs --config p/secrets --json -o "$S" . >/dev/null 2>&1
    if [ -s "$S" ]; then
      res=$(jsum 'const d=JSON.parse(require("fs").readFileSync(process.argv[1]));const r=(d.results||[]).filter(x=>!/security-tests\/|scan\.sh/.test(x.path));const e=r.filter(x=>x.extra.severity==="ERROR"),w=r.filter(x=>x.extra.severity==="WARNING");console.log("E "+e.length);console.log("W "+w.length);for(const x of e.concat(w).slice(0,8))console.log("   "+x.extra.severity[0]+" "+x.check_id.split(".").pop()+" "+x.path+":"+x.start.line)' "$S")
      e=$(echo "$res" | awk '/^E /{print $2}'); w=$(echo "$res" | awk '/^W /{print $2}')
      if [ "${e:-0}" != 0 ]; then bad "semgrep: $e error-level finding(s), $w warning(s):"; echo "$res" | grep '^   ' | cut -c1-150
      elif [ "${w:-0}" != 0 ]; then warn "semgrep: $w warning(s) to review:"; echo "$res" | grep '^   ' | cut -c1-150
      else ok "semgrep: no findings (javascript, typescript, react, nextjs, secrets rules; files over 300 KB skipped)"; fi
    else warn "semgrep ran but wrote no report (offline? its rules download from semgrep.dev)"; fi
  else tips="$tips semgrep"; fi
  # GitHub Actions: zizmor, offline
  if ls .github/workflows/*.y*ml >/dev/null 2>&1; then
    if command -v zizmor >/dev/null; then
      Z=$(mktemp); zizmor --offline --format json-v1 --min-severity medium .github/workflows > "$Z" 2>/dev/null
      res=$(jsum 'const d=JSON.parse(require("fs").readFileSync(process.argv[1]));const sv=x=>String(x.determinations&&x.determinations.severity||"");const hi=d.filter(x=>/high/i.test(sv(x))),me=d.filter(x=>/medium/i.test(sv(x)));console.log("H "+hi.length);console.log("M "+me.length);for(const x of hi.concat(me).slice(0,6))console.log("   "+sv(x)+" "+x.ident+": "+x.desc)' "$Z")
      zh=$(echo "$res" | awk '/^H /{print $2}'); zm=$(echo "$res" | awk '/^M /{print $2}')
      if [ "${zh:-0}" != 0 ]; then bad "zizmor: $zh high-severity GitHub Actions issue(s):"; echo "$res" | grep '^   ' | cut -c1-150
      elif [ "${zm:-0}" != 0 ]; then warn "zizmor: $zm medium GitHub Actions issue(s):"; echo "$res" | grep '^   ' | cut -c1-150
      else ok "zizmor: GitHub Actions workflows look safe"; fi
    else tips="$tips zizmor"; fi
  fi
  command -v gitleaks >/dev/null || tips="$tips gitleaks"
  [ -n "$tips" ] && warn "For a much deeper scan install:$tips (Mac: brew install$tips). Code Armour uses them automatically."
  command -v sfw >/dev/null || echo "  Tip: Socket Firewall Free (npm i -g sfw, then: sfw npm install) blocks malicious packages before they install."
fi

if [ -n "$URL" ]; then
  echo; echo "-- 9. Live site: $URL --"
  H=$(curl -sIL --max-time 15 "$URL")
  if [ -z "$H" ]; then bad "Site didn't respond (paused, out of credits, or wrong URL?)"; else
    for h in strict-transport-security content-security-policy x-content-type-options referrer-policy permissions-policy; do
      echo "$H" | grep -qi "^$h:" && ok "$h" || bad "Missing header: $h"
    done
    echo "$H" | grep -qiE '^(x-frame-options:|content-security-policy:.*frame-ancestors)' && ok "framing blocked" || bad "Missing X-Frame-Options or CSP frame-ancestors (clickjacking)"
  fi
  # Commonly leaked files. Single-page apps answer 200 with their HTML page for everything, so only a
  # non-HTML 200 counts as a leak.
  for p in .env .env.local .env.production .git/config .git/HEAD .DS_Store .vscode/settings.json .npmrc \
           backup.sql dump.sql db.sqlite backup.zip site.zip config.json firebase-debug.log \
           server-status phpinfo.php wp-config.php.bak .well-known/../.env docker-compose.yml; do
    code=$(curl -s -o /tmp/ca-live-body --max-time 10 -w '%{http_code}' "${URL%/}/$p")
    if [ "$code" = 200 ] && ! head -c 400 /tmp/ca-live-body | grep -qiE '<(!doctype|html|head|body)'; then bad "/$p is downloadable!"; fi
  done
  ok "Checked 20 commonly leaked files"
  host=$(echo "$URL" | sed -E 's#^https?://##; s#/.*##; s#:.*##')
  # HTTP should redirect to HTTPS
  hcode=$(curl -s -o /dev/null -w '%{http_code} %{redirect_url}' --max-time 10 "http://$host/")
  echo "$hcode" | grep -qE '^30[1278] https://' && ok "http:// redirects to https://" || warn "http://$host doesn't redirect to https:// ($hcode)"
  # Certificate expiry
  if command -v openssl >/dev/null; then
    end=$(echo | openssl s_client -servername "$host" -connect "$host:443" 2>/dev/null | openssl x509 -noout -enddate 2>/dev/null | cut -d= -f2)
    if [ -n "$end" ]; then
      endts=$(date -j -f "%b %e %T %Y %Z" "$end" +%s 2>/dev/null || date -d "$end" +%s 2>/dev/null)
      [ -n "$endts" ] && { days=$(( (endts - $(date +%s)) / 86400 )); [ "$days" -lt 14 ] && bad "HTTPS certificate expires in $days days" || { [ "$days" -lt 30 ] && warn "HTTPS certificate expires in $days days" || ok "HTTPS certificate valid for $days more days"; }; }
    fi
  fi
  # Cookies set by the page must be Secure + HttpOnly (session cookies) + SameSite
  echo "$H" | grep -i '^set-cookie:' | while read -r c; do
    n=$(echo "$c" | sed -E 's/^set-cookie: *([^=]+)=.*/\1/I')
    echo "$c" | grep -qi 'secure' || echo "  ? cookie $n has no Secure flag"
    echo "$c" | grep -qi 'samesite' || echo "  ? cookie $n has no SameSite"
    echo "$n" | grep -qiE 'sess|auth|token|sid' && ! echo "$c" | grep -qi 'httponly' && echo "  ? cookie $n looks like a login cookie but isn't HttpOnly (scripts can steal it)"
  done
  # CORS: can a random website read your responses?
  ch=$(curl -sI --max-time 10 -H "Origin: https://evil.example" "$URL")
  if echo "$ch" | grep -qi '^access-control-allow-origin: *https://evil\.example'; then
    echo "$ch" | grep -qi '^access-control-allow-credentials: *true' && bad "CORS reflects any origin WITH credentials: any website can read logged-in users' data" || warn "CORS reflects any origin (any website can read these responses)"
  else ok "CORS doesn't trust a random website"; fi
  # Server/framework version leaks
  ver=$(echo "$H" | grep -iE '^(server|x-powered-by|x-aspnet-version): .*[0-9]+\.[0-9]+' | head -2 | tr -d '\r')
  [ -n "$ver" ] && warn "Server version shown in headers (helps attackers pick exploits): $ver"
  # security.txt (how researchers report bugs; expected under the EU Cyber Resilience Act)
  st=$(curl -s --max-time 10 "${URL%/}/.well-known/security.txt" | head -c 300)
  echo "$st" | grep -qi '^contact:' && ok "security.txt present" || warn "No /.well-known/security.txt (add Contact: and Expires:, see securitytxt.org)"
  # Page content: mixed content, public source maps, folder listings
  page=$(curl -sL --max-time 15 "$URL" | head -c 400000)
  echo "$page" | grep -qiE '<(script|iframe)[^>]+src=["'"'"']http://' && bad "Page loads scripts/frames over plain http:// (mixed content)"
  js=$(echo "$page" | grep -oiE '<script[^>]+src=["'"'"'][^"'"'"']+\.js' | head -1 | sed -E 's/.*src=["'"'"']//')
  if [ -n "$js" ]; then
    case "$js" in http*) jsurl="$js";; //*) jsurl="https:$js";; /*) jsurl="${URL%/}$js";; *) jsurl="${URL%/}/$js";; esac
    map=$(curl -s --max-time 10 "$jsurl" | tail -c 300 | grep -oE 'sourceMappingURL=[^ ]+' | cut -d= -f2)
    if [ -n "$map" ] && [ "${map#data:}" = "$map" ]; then
      mapurl="${jsurl%/*}/$map"; mc=$(curl -s -o /dev/null -w '%{http_code}' --max-time 10 "$mapurl")
      [ "$mc" = 200 ] && warn "Source map is public ($mapurl): anyone can read your original source code"
    fi
  fi
  for d in uploads images files static assets backup; do
    curl -s --max-time 8 "${URL%/}/$d/" | head -c 2000 | grep -qiE '<title>Index of /|Directory listing for' && bad "/$d/ shows a folder listing"
  done
  # Email spoofing protection on your own domain (skip shared hosting domains)
  case "$host" in *.netlify.app|*.pages.dev|*.vercel.app|*.github.io|*.web.app|*.firebaseapp.com|localhost|127.*) ;;
    *) if command -v dig >/dev/null; then
         dom=$(echo "$host" | sed -E 's/^www\.//')
         dig +short TXT "$dom" | grep -qi 'v=spf1' && ok "SPF record present" || warn "No SPF record on $dom: anyone can send email pretending to be you (15.15)"
         dig +short TXT "_dmarc.$dom" | grep -qi 'v=DMARC1' && ok "DMARC record present" || warn "No DMARC record on $dom (15.15)"
       fi;;
  esac
fi
echo
[ $problems = 0 ] && echo "${GRN}No problems found by the scan. Now do the manual checks in SKILL.md.${RST}" || echo "${RED}$problems problem(s) found.${RST} Fix them, then run again."
[ $problems = 0 ]   # exit code 1 when problems were found, so re-tests and GitHub checks fail
