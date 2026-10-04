#!/usr/bin/env bash
# Code Armour quick scan. Finds common leaks and missing protections.
# Usage: bash scan.sh [project-dir] [live-url]
# A clean result is NOT proof of safety: it only catches known patterns.

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

echo; echo "-- 1. Secrets in source files --"
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
  if command -v gitleaks >/dev/null; then
    gitleaks detect --no-banner --redact -s . >/tmp/ca-gitleaks.txt 2>&1 && ok "gitleaks: no leaks in history" || { bad "gitleaks found leaks:"; tail -20 /tmp/ca-gitleaks.txt; }
  else
    # Skip Code Armour's own tool files: they contain the detection patterns themselves (a copy of this
# scanner in the history would otherwise flag itself forever).
    hist=$(git log --all -p -- . ':(exclude,glob)**/scan.sh' ':(exclude,glob)**/audit.sql' ':(exclude,glob)**/harness.mjs' 2>/dev/null | grep -oE "$SECRETS" | sort -u | head -10 | cut -c1-14 | sed 's/$/…/')
    [ -n "$hist" ] && { bad "Secret patterns in git history (ROTATE these keys; deleting the file doesn't help):"; echo "$hist"; } || ok "No secret patterns in git history (install gitleaks for a deeper check)"
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

echo; echo "-- 6c. Trackers and third parties (privacy laws, kids) --"
grep -rlE "${EXCL[@]}" --exclude-dir=dist --exclude-dir=build 'fonts\.googleapis\.com|fonts\.gstatic\.com' . 2>/dev/null | head -3 | sed 's/^/  ? Google Fonts loaded from Google (self-host them; a German court fined this): /'
grep -rlE "${EXCL[@]}" --exclude-dir=dist --exclude-dir=build 'googletagmanager\.com|google-analytics\.com|gtag\(|connect\.facebook\.net|fbq\(|analytics\.tiktok\.com|hotjar|clarity\.ms|fullstory' . 2>/dev/null | head -5 | sed 's/^/  ? Tracker or analytics script (needs consent in EU\/UK; risky with kids; US pixel lawsuits): /'

echo; echo "-- 7. Source maps in build --"
maps=$(find dist build out .next/static -name '*.map' 2>/dev/null | head -5)
[ -n "$maps" ] && warn "Source maps will be public (your full source code): $maps" || ok "No source maps in build"

echo; echo "-- 8. Dependencies --"
if [ -f package.json ] || ls */package.json packages/*/package.json >/dev/null 2>&1; then
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

if [ -n "$URL" ]; then
  echo; echo "-- 9. Live site: $URL --"
  H=$(curl -sIL --max-time 15 "$URL")
  if [ -z "$H" ]; then bad "Site didn't respond (paused, out of credits, or wrong URL?)"; else
    for h in strict-transport-security content-security-policy x-content-type-options referrer-policy permissions-policy; do
      echo "$H" | grep -qi "^$h:" && ok "$h" || bad "Missing header: $h"
    done
    echo "$H" | grep -qiE '^(x-frame-options:|content-security-policy:.*frame-ancestors)' && ok "framing blocked" || bad "Missing X-Frame-Options or CSP frame-ancestors (clickjacking)"
  fi
  for p in .env .git/config .env.local backup.sql; do
    code=$(curl -s -o /dev/null -w '%{http_code}' --max-time 10 "${URL%/}/$p")
    body=$(curl -s --max-time 10 "${URL%/}/$p" | head -c 200)
    if [ "$code" = 200 ] && ! echo "$body" | grep -qi '<html'; then bad "/$p is downloadable!"; else ok "/$p not exposed ($code)"; fi
  done
fi

echo
[ $problems = 0 ] && echo "${GRN}No problems found by the scan. Now do the manual checks in SKILL.md.${RST}" || echo "${RED}$problems problem(s) found.${RST} Fix them, then run again."
[ $problems = 0 ]   # exit code 1 when problems were found, so re-tests and GitHub checks fail
