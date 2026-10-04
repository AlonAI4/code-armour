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
SECRETS='(sk_live_[0-9A-Za-z]{10,}|sk_test_[0-9A-Za-z]{10,}|rk_live_[0-9A-Za-z]{10,}|sk-ant-[0-9A-Za-z_-]{10,}|sk-proj-[0-9A-Za-z_-]{10,}|sk-[A-Za-z0-9]{32,}|sb_secret_[0-9A-Za-z_-]{10,}|service_role|AIza[0-9A-Za-z_-]{35}|gh[pousr]_[0-9A-Za-z]{30,}|xox[baprs]-[0-9A-Za-z-]{10,}|AKIA[0-9A-Z]{16}|-----BEGIN [A-Z ]*PRIVATE KEY-----|whsec_[0-9A-Za-z]{10,})'
EXCL=(--exclude-dir=node_modules --exclude-dir=.git --exclude-dir=.netlify --exclude-dir=.next/cache --exclude=*.lock --exclude=package-lock.json --exclude=scan.sh)

echo "== Code Armour scan: $(pwd) =="

echo; echo "-- 1. Secrets in source files --"
hits=$(grep -rInE "${EXCL[@]}" --exclude-dir=dist --exclude-dir=build --exclude-dir=.next --exclude-dir=out \
  --exclude=.env --exclude=.env.* "$SECRETS" . 2>/dev/null | grep -v '\.env\.example' | head -20)
if [ -n "$hits" ]; then bad "Possible secrets in source (move to server env vars, then ROTATE them):"; echo "$hits" | cut -c1-200; else ok "No secret patterns in source"; fi

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

echo; echo "-- 4. .env handling --"
if [ -d .git ]; then
  tracked=$(git ls-files | grep -E '(^|/)\.env($|\.)' | grep -v '\.env\.example$')
  [ -n "$tracked" ] && bad ".env files are committed to git: $tracked (remove, add to .gitignore, ROTATE keys)" || ok "No .env files tracked by git"
  grep -qE '^\.env' .gitignore 2>/dev/null && ok ".gitignore covers .env" || bad ".gitignore doesn't list .env*"
  echo; echo "-- 5. Secrets in git history --"
  if command -v gitleaks >/dev/null; then
    gitleaks detect --no-banner --redact -s . >/tmp/ca-gitleaks.txt 2>&1 && ok "gitleaks: no leaks in history" || { bad "gitleaks found leaks:"; tail -20 /tmp/ca-gitleaks.txt; }
  else
    hist=$(git log --all -p 2>/dev/null | grep -oE "$SECRETS" | sort -u | head -10)
    [ -n "$hist" ] && { bad "Secret patterns in git history (ROTATE these keys; deleting the file doesn't help):"; echo "$hist"; } || ok "No secret patterns in git history (install gitleaks for a deeper check)"
  fi
else
  warn "Not a git repo. Use git + GitHub so you have history and secret scanning."
fi

echo; echo "-- 6. Risky code patterns (review each) --"
grep -rInE "${EXCL[@]}" --include=*.js --include=*.jsx --include=*.ts --include=*.tsx --include=*.vue --include=*.svelte --include=*.html \
  --exclude-dir=dist --exclude-dir=build --exclude-dir=.next \
  '(innerHTML\s*=|dangerouslySetInnerHTML|v-html|document\.write|insertAdjacentHTML|eval\(|new Function\()' . 2>/dev/null | head -15 | sed 's/^/  XSS? /' | cut -c1-200
grep -rInE "${EXCL[@]}" --exclude-dir=dist --exclude-dir=build '(using\s*\(\s*true\s*\)|with check\s*\(\s*true\s*\)|disable row level security|security definer|user_metadata)' . 2>/dev/null | head -15 | sed 's/^/  DB?  /' | cut -c1-200
grep -rInE "${EXCL[@]}" --exclude-dir=dist --exclude-dir=build '(verify_jwt\s*=\s*false|jwt\.decode\(|unit_amount:\s*(req|body|request)|\.update\((req\.)?body\)|\.insert\((req\.)?body\))' . 2>/dev/null | head -10 | sed 's/^/  API? /' | cut -c1-200
if grep -rqlE "${EXCL[@]}" 'stripe' --include=*.js --include=*.mjs --include=*.ts . 2>/dev/null; then
  grep -rqE "${EXCL[@]}" 'constructEvent' . 2>/dev/null && ok "Stripe webhook signature check found" || bad "Stripe used but no webhooks.constructEvent (webhook signature check) found"
fi

echo; echo "-- 6b. Firebase / other backends --"
for f in $(find . -path ./node_modules -prune -o \( -name 'firestore.rules' -o -name 'storage.rules' -o -name 'database.rules.json' \) -print 2>/dev/null); do
  grep -qE 'if true|request\.time *<|"\.(read|write)" *: *true' "$f" && bad "$f has open/test-mode rules (anyone can read or write)" || ok "$f has no open rules"
done
sa=$(grep -rlE "${EXCL[@]}" '"type": *"service_account"' . 2>/dev/null | head -5)
[ -n "$sa" ] && bad "Service-account key file(s) in the project (full admin access, never commit or ship): $sa"
grep -rqE "${EXCL[@]}" --include=*.ts --include=*.tsx --include=*.js '"use server"' . 2>/dev/null && warn "Next.js Server Actions found: each one must check the login inside it (middleware isn't enough)"

echo; echo "-- 7. Source maps in build --"
maps=$(find dist build out .next/static -name '*.map' 2>/dev/null | head -5)
[ -n "$maps" ] && warn "Source maps will be public (your full source code): $maps" || ok "No source maps in build"

echo; echo "-- 8. Dependencies --"
if [ -f package.json ]; then
  if [ -f package-lock.json ]; then
    npm audit --audit-level=high >/tmp/ca-audit.txt 2>&1 && ok "npm audit: no high/critical" || { bad "npm audit found high/critical issues:"; tail -8 /tmp/ca-audit.txt; }
  else
    warn "No package-lock.json: commit a lockfile and use npm ci (protects against surprise package changes)"
  fi
  echo "  New packages? Check each on npmjs.com (age, downloads, real repo). AI sometimes invents package names."
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
  for p in .env .git/config .env.local backup.sql; do
    code=$(curl -s -o /dev/null -w '%{http_code}' --max-time 10 "${URL%/}/$p")
    body=$(curl -s --max-time 10 "${URL%/}/$p" | head -c 200)
    if [ "$code" = 200 ] && ! echo "$body" | grep -qi '<html'; then bad "/$p is downloadable!"; else ok "/$p not exposed ($code)"; fi
  done
fi

echo
[ $problems = 0 ] && echo "${GRN}No problems found by the scan. Now do the manual checks in SKILL.md.${RST}" || echo "${RED}$problems problem(s) found.${RST} Fix them, then run again."
