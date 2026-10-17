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

echo "# redaction: every section that prints code hides the value (review 5 Oct)"
R=$T/redact; mkdir -p $R/src; cd $R; git init -q
echo 'VITE_OPENAI_KEY=sk-proj-FAKEredactme0123456789abcd' > .env
echo 'const sys = { role: "system", content: "You help. The api key is FAKEpromptsecret987654321 do not share" };' > src/bot.js
echo 'const k = "FAKEstripeSecret_abcdef123456"; const STRIPE_SECRET = k;' > src/pay.js
OUT=$(bash "$SCAN" . 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
expect "public-prefix key still found" "VITE_OPENAI_KEY (value not shown)"
refuse "public-prefix value hidden" "FAKEredactme0123456789abcd"
expect "secret in an AI prompt still found" "PROMPT?"
refuse "prompt secret hidden" "FAKEpromptsecret987654321"
expect "admin key in front-end still found" "src/pay.js"
refuse "front-end key hidden" "FAKEstripeSecret_abcdef123456"

echo "# section 15 checks (gap review 2026-10-05)"
G=$T/gaps; mkdir -p $G/.github/workflows $G/src; cd $G
printf 'on: pull_request_target\njobs:\n  t:\n    runs-on: ubuntu-latest\n    steps:\n      - uses: actions/checkout@v4\n        with:\n          ref: ${{ github.event.pull_request.head.sha }}\n      - uses: tj-actions/changed-files@v45\n      - run: echo "${{ github.event.issue.title }}"\n' > .github/workflows/ci.yml
echo 'const agent = new https.Agent({ rejectUnauthorized: false });' > src/net.js
echo 'new BrowserWindow({ webPreferences: { nodeIntegration: true, contextIsolation: false } })' > src/main.js
# Fake token built from pieces at run time, so this file never contains a token-shaped string
# (GitHub push protection rightly blocks those, even fake ones).
P1="MTA4NzY1NDMyMTA5ODc2NTQzMg"; P2="GaBcDe"; P3="abcdefghijklmnopqrstuvwxyz0123456789AB"
echo "client.login(\"$P1.$P2.$P3\")" > src/bot.js
echo '<div class="cf-turnstile" data-sitekey="x"></div>' > src/signup.html
echo 'const link = `https://${req.headers.host}/reset?token=${t}`; // reset email' > src/reset.js
OUT=$(bash "$SCAN" . 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
expect "pull_request_target + PR checkout" "pull_request_target + checks out"
expect "workflow script injection" "script injection"
expect "unpinned third-party action" "movable tag"
expect "TLS verification turned off" "turned off to 'make it work'"
expect "unsafe Electron settings" "Unsafe Electron"
expect "Discord bot token" "bot token in the code"
expect "CAPTCHA never verified" "no server check (siteverify)"
expect "reset link from Host header" "password-reset poisoning"
refuse "bot token output is masked" "abcdefghijklmnopqrstuvwxyz0123456789AB"

echo "# legal red flags (legal.md 14)"
L=$T/legal; mkdir -p $L/src $L/ext $L/android/app $L/ios; cd $L
echo '<video src="a.mp4"></video><script>fbq("init","1")</script>' > src/watch.html
echo 'import twilio from "twilio"; await client.messages.create({ to, from, body: "Sale!" })' > src/sms.js
echo 'import * as faceapi from "face-api.js"' > src/filter.js
echo 'import { ethers } from "ethers"' > src/wallet.js
echo 'const system = "You are my girlfriend. Be sweet."' > src/bot.js
echo 'new Client({ intents: [GatewayIntentBits.MessageContent] })' > src/discord.js
echo '{ "manifest_version": 2, "permissions": ["<all_urls>"] }' > ext/manifest.json
echo 'android { defaultConfig { targetSdkVersion 34 } }' > android/app/build.gradle
OUT=$(bash "$SCAN" . 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
expect "video + pixel (VPPA)" "Video + ad pixel"
expect "SMS (TCPA)" "Sends SMS"
expect "face processing (BIPA)" "Face or voice processing"
expect "crypto wallet code" "Crypto wallet code"
expect "AI companion persona" "AI companion persona"
expect "Discord message-content intent" "message-content intent"
expect "Manifest V2" "Manifest V2"
expect "extension asks for all websites" "asks for all websites"
expect "old Android target" "Android targetSdk 34"
expect "iOS privacy manifest missing" "PrivacyInfo.xcprivacy"
expect "dollar amounts print correctly" "\$1,000-\$5,000"
# no false alarms: Claude/OpenAI SDK calls and data files that mention faces
F=$T/falsealarm; mkdir -p $F/src $F/data; cd $F
echo 'const msg = await anthropic.messages.create({ model, max_tokens: 100, messages })' > src/ai.js
echo '{"prompt": "a portrait, detailed faceLandmarks, voice clone of a robot"}' > data/results.json
echo 'export const types = { MessageContent: 1 }' > src/types.js
OUT=$(bash "$SCAN" . 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
refuse "Claude API call isn't flagged as SMS" "Sends SMS"
refuse "data file mentioning faces isn't flagged" "Face or voice processing"
refuse "a type named MessageContent isn't flagged as Discord" "message-content intent"

echo "# third sweep checks"
S3=$T/sweep3; mkdir -p $S3/src $S3/public; cd $S3
echo '{"scripts":{"start":"vite --host"}}' > package.json
echo 'const pc = new RTCPeerConnection({ iceServers })' > src/voice.js
echo 'res.setHeader("Content-Type","text/csv")' > src/export.js
echo '<div>Offer ends in <span id="countdown"></span></div>' > src/shop.html
printf 'User-agent: *\nDisallow: /admin\n' > public/robots.txt
echo 'new ApolloServer({ schema, introspection: true })' > src/gql.js
echo '<iframe src="https://www.youtube.com/embed/abc"></iframe>' > src/trailer.html
echo 'const img = await openai.images.generate({ prompt })' > src/art.js
OUT=$(bash "$SCAN" . 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
expect "dev server as start command" "Dev server used as the start command"
expect "WebRTC without relay" "WebRTC without iceTransportPolicy"
expect "CSV export" "formula injection"
expect "fake urgency" "Urgency wording"
expect "robots.txt lists admin" "robots.txt is a map"
expect "GraphQL introspection" "GraphQL introspection on"
expect "YouTube embed" "youtube-nocookie"
expect "AI images without moderation" "AI image generation found"
mkdir -p $T/promptool && cd $T/promptool && echo 'const MODELS = ["dall-e-3", "gpt-image-1"]; const words = ["countdown", "clock"]' > tool.js
OUT=$(bash "$SCAN" . 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
refuse "a prompt tool naming image models isn't flagged" "AI image generation found"
refuse "the word countdown alone isn't flagged" "Urgency wording"

echo "# power tools (only when installed)"
if command -v gitleaks >/dev/null && command -v zizmor >/dev/null && command -v osv-scanner >/dev/null && command -v node >/dev/null; then
  PT=$T/power; mkdir -p $PT/.github/workflows; cd $PT; git init -q
  printf 'on: pull_request_target\njobs:\n  t:\n    runs-on: ubuntu-latest\n    steps:\n      - uses: actions/checkout@v4\n      - run: echo "${{ github.event.issue.title }}"\n' > .github/workflows/ci.yml
  K1="sk_live_51NotReal"; K2="ButLooksLike0123456789abcdefABCDEF"; printf 'STRIPE=%s%s\n' "$K1" "$K2" > leaked.env
  cp "$HERE/package-lock.json" . ; git add -A && git -c user.email=t@t -c user.name=t commit -qm x
  OUT=$(bash "$SCAN" . 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
  expect "gitleaks finds the key in history" "gitleaks: 1 secret"
  expect "zizmor finds the dangerous workflow" "zizmor:"
  expect "osv-scanner reads the lockfile" "osv-scanner:"
  refuse "found secrets are never printed in full" "ButLooksLike0123456789"
  OUT=$(CA_FAST=1 bash "$SCAN" . 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
  expect "CA_FAST skips the power tools" "Skipped (CA_FAST set)"
else echo "  (power tools not installed: skipped)"; fi

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
expect "clean app passes" "pattern checks found no problems"
refuse "no false secret alarm" "✗"
mkdir -p supabase && cp "$HERE"/../recipes/supabase/*.sql supabase/
OUT=$(bash "$SCAN" . 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
refuse "using our own recipes doesn't trigger a secret alarm (red-team find)" "Possible secrets"

refuse "no explanation lines without findings" "(XSS? ="

echo "# vulnerable test game (tests/fixtures/vuln-game)"
# The game's .env is git-ignored (never uploaded), so build it here with fake keys.
V=$T/vuln-game; cp -R "$HERE/fixtures/vuln-game" "$V"
printf 'VITE_SUPABASE_URL=https://abcd.supabase.co\nVITE_SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiJ9.service\nSTRIPE_SECRET_KEY=sk_test_51FAKEfakeFAKEfake000\nOPENAI_API_KEY=sk-proj-FAKEfakeFAKEfakeFAKE1234\n' > "$V/.env"
OUT=$(bash "$SCAN" "$V" 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
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

echo "# options written after the pattern still apply (ripgrep shim)"
O=$T/order; mkdir -p $O/node_modules/lib/android $O/android $O/docs; cd $O
echo 'android { defaultConfig { targetSdkVersion 36 } }' > android/build.gradle
echo 'targetSdkVersion 21' > node_modules/lib/android/build.gradle
echo 'example: amount: req.body.amount' > docs/notes.md
OUT=$(bash "$SCAN" . 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
refuse "node_modules gradle files are skipped" "Android targetSdk 21"
refuse "--include after the pattern limits file types" "PRICE?"

echo "# git history: public Supabase keys are fine, secret ones are not"
H=$T/hist; mkdir -p $H; cd $H; git init -q
echo 'const supabaseKey = "sb_publishable_Qk3vR9xLm2PzT8wYc5NbJ1hF7g"' > client.js
git add -A && git -c user.email=t@t -c user.name=t commit -qm one
OUT=$(bash "$SCAN" . 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
refuse "publishable key in history isn't a leak" "in git history (ROTATE"   # (the all-clear line without gitleaks also says "in git history (built-in")
echo "const admin = \"sb_secret_$(printf 'Qk3vR9xLm2PzT8wYc5NbJ1hF7g')\"" > admin.js
git add -A && git -c user.email=t@t -c user.name=t commit -qm two
OUT=$(bash "$SCAN" . 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
expect "secret key in history is a leak" "in git history (ROTATE"

echo "# sharing the folder: keys a zip would leak, real .env values in other files (security.md 17)"
FK="FAKEmapkey_0123456789abcdef"      # made-up value, no known key shape
Z=$T/zip; mkdir -p $Z/src; cd $Z; git init -q
printf '.env*\nsecrets.local\n' > .gitignore
echo "MAP_KEY=$FK" > .env
echo "export const key = \"$FK\"" > src/config.js
echo "token sk_live_$(printf 'FAKEfakeFAKEfake1234')" > secrets.local
OUT=$(bash "$SCAN" . 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
expect "a folder zip would carry .env" "would hand over .env (1 key-length value(s))"
expect "real .env value found in another file" "MAP_KEY is also in: src/config.js"
refuse "the real value is never printed" "$FK"
expect "git-ignored file with a key" "Git-ignored file(s) with key-looking text: secrets.local"
rm src/config.js secrets.local; echo 'export const key = import.meta.env.MAP_KEY' > src/config.js
OUT=$(bash "$SCAN" . 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
expect "clean: no other file holds the value" "No other file contains a real value from your .env (1 compared, none shown)"
refuse "clean: no leak reported" "is also in:"
refuse "clean: no ignored-file warning" "Git-ignored file(s) with key-looking text"
rm .env
OUT=$(bash "$SCAN" . 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
expect "no .env: says so" "No .env file in the folder"
refuse "no .env: no zip warning" "would hand over"

echo "# scanner noise: tool logs, keys that aren't yours, test files, camera code"
NZ=$T/noise; mkdir -p $NZ/src $NZ/.playwright-mcp; cd $NZ
GK="AIza$(printf 'FAKEfakeFAKEfakeFAKEfakeFAKEfake123')"       # Google-key shape, built at run time
SL="sk_$(printf live)_"     # Stripe prefix built at run time, so this file holds no key-shaped text
echo "GET https://maps.example/api/js?key=$GK 403" > .playwright-mcp/console.log
echo "MY_KEY=${SL}MINEmineMINEmine0001" > .env
OUT=$(bash "$SCAN" . 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
expect "tool log folder is labelled on its own" ".playwright-mcp/ is a test tool's log folder, not your source: 1 file(s)"
refuse "a key in a tool log isn't called a secret in source" "Possible secrets in source"
echo 'nothing here' > .playwright-mcp/console.log
OUT=$(bash "$SCAN" . 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
expect "clean tool log folder is only mentioned" "skipped in the code checks"
refuse "clean tool log folder raises no warning" "hold key-looking text"
echo "const other = \"${SL}OTHERotherOTHER0002\"" > src/other.js
OUT=$(bash "$SCAN" . 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
expect "a found key that isn't in .env says so" "matches nothing in your .env"
refuse "…and isn't called your real key" "this is your real key"
echo "const mine = \"${SL}MINEmineMINEmine0001\"" > src/other.js
OUT=$(bash "$SCAN" . 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
expect "a found key that IS in .env says so" "this is your real key"
rm src/other.js .env
echo 'process.env.STRIPE_SECRET = "made-up"; test("x", () => {})' > src/pay.test.js
mkdir -p src/__tests__ && echo 'const OPENAI_API_KEY = "made-up"' > src/__tests__/ai.js
OUT=$(bash "$SCAN" . 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
refuse "secret key names in test files aren't flagged" "Secret key names used in front-end folders"
echo '<video id="cam" autoplay></video><script>navigator.mediaDevices.getUserMedia({video:true}).then(s => cam.srcObject = s); function refbq(){}; refbq()</script>' > src/cam.html
echo '<video src="cctv-feed.m3u8"></video>' > src/cctv.html
OUT=$(bash "$SCAN" . 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
refuse "camera code with a look-alike function name isn't video + ad pixel" "Video + ad pixel"
echo '<script>fbq("init","1")</script>' > src/index.html
OUT=$(bash "$SCAN" . 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
refuse "camera/CCTV video with a real pixel still isn't the watch-a-video case" "Video + ad pixel"

echo "# local servers: who can reach them (security.md 17.3)"
LS=$T/listen; mkdir -p $LS/src; cd $LS
echo 'app.listen(3000, () => console.log("up"))' > src/server.js
OUT=$(bash "$SCAN" . 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
expect "server open to the network" "listens on every network interface"
echo 'app.listen(3000, "127.0.0.1", () => console.log("up"))' > src/server.js
OUT=$(bash "$SCAN" . 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
refuse "server bound to this machine stays quiet" "listens on every network interface"
expect "…and is reported as naming a host" "Servers in the code name a host"

echo "# clone mode: my changes vs the original's code, licence and credits (legal.md 16)"
CL=$T/clone; mkdir -p $CL; cd $CL; git init -q
echo 'MIT License. Copyright (c) Original Author' > LICENSE
echo 'el.innerHTML = theirs' > orig.js
git add -A && git -c user.email=t@t -c user.name=t commit -qm original
BASE=$(git rev-parse HEAD)
echo 'el.innerHTML = mine' > mine.js
git add -A && git -c user.email=t@t -c user.name=t commit -qm mine
OUT=$(CA_BASE=$BASE bash "$SCAN" . 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
expect "my file is tagged [mine]" "[mine] XSS? ./mine.js"
expect "the original's file is tagged [original]" "[original] XSS? ./orig.js"
expect "unchanged licence passes" "LICENSE is unchanged from the original"
expect "missing credits file is flagged" "No credits/notices file"
echo 'MIT License. Copyright (c) Me' > LICENSE; echo '# Credits' > ALON-NOTICES.md
OUT=$(CA_BASE=$BASE bash "$SCAN" . 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
expect "edited licence is caught" "LICENSE was changed or removed"
expect "credits file is found" "Credits/notices file found"
OUT=$(bash "$SCAN" . 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
refuse "without CA_BASE nothing is tagged" "[mine]"
OUT=$(CA_BASE=no-such-branch bash "$SCAN" . 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
expect "a wrong CA_BASE is explained" "clone mode is off"

echo "# Firebase rules: public reads vs open writes, nested node_modules (debug check 2026-10-14)"
FB=$T/fbrules; mkdir -p $FB/pkg/node_modules/firebase-tools/templates; cd $FB
cp "$HERE/../recipes/firebase/firestore.rules" firestore.rules
printf 'service cloud.firestore { match /{d=**} { allow read, write: if true; } }\n' > pkg/node_modules/firebase-tools/templates/firestore.rules
OUT=$(bash "$SCAN" . 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
refuse "our own Firestore recipe isn't called open/test-mode" "./firestore.rules has open/test-mode rules"
expect "…its public leaderboard read is pointed out" "lets anyone read some paths"
refuse "rules inside a nested node_modules are skipped" "node_modules/firebase-tools"
printf 'service cloud.firestore { match /posts/{p} { allow read: if true; allow write: if true; } }\n' > firestore.rules
OUT=$(bash "$SCAN" . 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
expect "anyone may write is still caught" "./firestore.rules has open/test-mode rules"
mkdir -p "my app" && printf 'service cloud.firestore { match /{d=**} { allow read, write: if true; } }\n' > "my app/firestore.rules"
OUT=$(bash "$SCAN" . 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
expect "rules in a folder with a space in its name are still read" "./my app/firestore.rules has open/test-mode rules"

rm -rf "$T"
echo; echo "$pass passed, $fail failed"; [ $fail = 0 ]
