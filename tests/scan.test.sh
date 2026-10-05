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
expect "AI images without moderation" "AI image generation with no moderation"
mkdir -p $T/promptool && cd $T/promptool && echo 'const MODELS = ["dall-e-3", "gpt-image-1"]; const words = ["countdown", "clock"]' > tool.js
OUT=$(bash "$SCAN" . 2>&1 | sed 's/\x1b\[[0-9;]*m//g')
refuse "a prompt tool naming image models isn't flagged" "AI image generation with no moderation"
refuse "the word countdown alone isn't flagged" "Urgency wording"

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

rm -rf "$T"
echo; echo "$pass passed, $fail failed"; [ $fail = 0 ]
