#!/usr/bin/env bash
# Scanner tests: a planted-problems app must be caught; a clean app must pass with no false alarms.
HERE="$(cd "$(dirname "$0")" && pwd)"
SCAN="$HERE/../scripts/scan.sh"
T=$(mktemp -d); pass=0; fail=0
expect() { if echo "$OUT" | grep -qF -- "$2"; then pass=$((pass+1)); echo "✓ $1"; else fail=$((fail+1)); echo "✗ $1 (missing: $2)"; fi; }
refuse() { if echo "$OUT" | grep -qF -- "$2"; then fail=$((fail+1)); echo "✗ $1 (unexpected: $2)"; else pass=$((pass+1)); echo "✓ $1"; fi; }

echo "# broken app"
B=$T/bad; mkdir -p $B/src $B/dist; cd $B; git init -q
echo 'STRIPE=sk_live_abcdefghijklmnop1234' > .env
echo 'const k = import.meta.env.VITE_SUPABASE_SERVICE_ROLE_KEY; el.innerHTML = msg; import Stripe from "stripe";' > src/app.js
echo 'var a="sk_live_abcdefghijklmnop1234";' > dist/app.js
echo 'x' > dist/app.js.map
printf 'service cloud.firestore { match /{d=**} { allow read, write: if request.time < timestamp.date(2026,12,1); } }\n' > firestore.rules
echo '{"type": "service_account", "private_key": "x"}' > admin-key.json
echo 'create policy p on t for select using (true);' > src/m.sql
git add -A && git -c user.email=t@t -c user.name=t commit -qm init
OUT=$(bash "$SCAN" . 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
expect "key in the build" "Secrets inside dist/"
expect "secret with a public prefix" "PUBLIC prefix"
expect ".env committed" ".env files are committed"
expect ".gitignore missing .env" ".gitignore doesn't list .env"
expect "key in git history" "git history"
refuse "history output is masked" "abcdefghijklmnop1234"
expect "innerHTML flagged" "XSS?"
expect "using (true) flagged" "DB?"
expect "Stripe without signature check" "no webhooks.constructEvent"
expect "Firebase test-mode rules" "open/test-mode rules"
expect "service-account key file" "Service-account key"
expect "source map" "Source maps will be public"
echo 'const admin = createClient(url, "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFiY2QiLCJyb2xlIjoic2VydmljZV9yb2xlIiwiaWF0IjoxNzAwMDAwMDAwfQ.c2lnbmF0dXJlc2lnbmF0dXJlc2lnbmF0dXJl"); const db = "postgresql://postgres:Hunter2pass@db.abcd.supabase.co:5432/postgres";' > src/admin.js
OUT=$(bash "$SCAN" . 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
expect "real service_role JWT in source (red-team find)" "src/admin.js"
expect "database URL with password (red-team find)" "postgresql://p…"
refuse "scan output never shows a whole secret" "Hunter2pass"

echo "# clean app"
C=$T/clean; mkdir -p $C/src $C/dist; cd $C; git init -q
printf '.env*\n!.env.example\nnode_modules/\n' > .gitignore
echo 'VITE_SUPABASE_URL=https://x.supabase.co' > .env.example
echo 'el.textContent = msg; const ok = 1;' > src/app.js
echo 'console.log(1)' > dist/app.js
echo '{"name":"clean","private":true}' > package.json
echo '{"name":"clean","lockfileVersion":3,"requires":true,"packages":{"":{"name":"clean"}}}' > package-lock.json
git add -A && git -c user.email=t@t -c user.name=t commit -qm init
OUT=$(bash "$SCAN" . 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
expect "clean app passes" "No problems found by the scan"
refuse "no false secret alarm" "✗"
mkdir -p supabase && cp "$HERE"/../recipes/supabase/*.sql supabase/
OUT=$(bash "$SCAN" . 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
refuse "using our own recipes doesn't trigger a secret alarm (red-team find)" "Possible secrets"

refuse "no explanation lines without findings" "(XSS? ="

echo "# vulnerable test game (tests/fixtures/vuln-game)"
OUT=$(bash "$SCAN" "$HERE/fixtures/vuln-game" 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
expect "admin key in front-end code" "Secret key names used in front-end folders"
expect "secrets sitting in .env" ".env holds secret keys"
expect "RLS turned off" "RLS turned off"
expect "user_metadata trusted" "user_metadata"
expect "password in AI prompt" "PROMPT?"
expect "price from the browser" "PRICE?"
expect "Google Fonts" "Google Fonts loaded from Google"
expect "tracker script" "Tracker or analytics script"
expect "webhook without signature" "no webhooks.constructEvent"

echo "# static site (no build folder)"
S=$T/static; mkdir -p $S; cd $S; echo '<h1>hi</h1>' > index.html
OUT=$(bash "$SCAN" . 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
expect "static site recognised" "Static site"

rm -rf "$T"
echo; echo "$pass passed, $fail failed"; [ $fail = 0 ]
