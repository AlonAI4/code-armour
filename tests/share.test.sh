#!/usr/bin/env bash
# recipes/sharing/share-zip.sh: the zip is built from git, so the ignored .env can't be in it; a committed key stops it.
HERE="$(cd "$(dirname "$0")" && pwd)"; SHARE="$HERE/../recipes/sharing/share-zip.sh"
T=$(mktemp -d); pass=0; fail=0
t() { if eval "$2"; then pass=$((pass+1)); echo "✓ $1"; else fail=$((fail+1)); echo "✗ $1"; fi; }
FAKE="FAKEmapkey_0123456789abcdef"     # made-up value, 16+ characters
P=$T/proj; mkdir -p $P/src $P/docs/media; cd $P; git init -q
printf '.env*\n!.env.example\n' > .gitignore
echo "MAP_KEY=$FAKE" > .env; echo 'MAP_KEY=' > .env.example
echo 'console.log(1)' > src/app.js; echo 'big' > docs/media/demo.mp4
git add -A && git -c user.email=t@t -c user.name=t commit -qm init
OUT=$(bash "$SHARE" . HEAD "$T/out.zip" 2>&1); code=$?
t "clean project: zip is made" '[ $code = 0 ] && [ -f "$T/out.zip" ]'
t "the zip has the code and .env.example" 'unzip -Z1 "$T/out.zip" | grep -qx "src/app.js" && unzip -Z1 "$T/out.zip" | grep -qx ".env.example"'
t "the zip has no .env" '! unzip -Z1 "$T/out.zip" | grep -qx ".env"'
t "the fake key value is nowhere in the zip" '! unzip -p "$T/out.zip" | grep -qF "$FAKE"'
t "it prints the size and the files per folder" 'echo "$OUT" | grep -q "no .env file and no real .env value inside" && echo "$OUT" | grep -q "src/"'
OUT=$(SHARE_SKIP="docs/media" bash "$SHARE" . HEAD "$T/small.zip" 2>&1)
t "SHARE_SKIP leaves a folder out" '! unzip -Z1 "$T/small.zip" | grep -q "docs/media"'
OUT=$(bash "$SHARE" . 2>&1)
t "by default the zip is written outside the project" '[ -f "$T/proj-share.zip" ] && [ ! -f "$P/proj-share.zip" ]'
echo "const k = \"$FAKE\"" > src/leak.js; git add -A && git -c user.email=t@t -c user.name=t commit -qm leak
OUT=$(bash "$SHARE" . HEAD "$T/leak.zip" 2>&1); code=$?
t "a real .env value saved in the code stops it, and no zip is left" '[ $code = 1 ] && [ ! -f "$T/leak.zip" ] && echo "$OUT" | grep -q "MAP_KEY"'
t "the value itself is never printed" '! echo "$OUT" | grep -qF "$FAKE"'
git rm -q --cached src/leak.js && rm src/leak.js; git add -f .env; git -c user.email=t@t -c user.name=t commit -qm envin
OUT=$(bash "$SHARE" . HEAD "$T/env.zip" 2>&1); code=$?
t "a committed .env stops it" '[ $code = 1 ] && [ ! -f "$T/env.zip" ] && echo "$OUT" | grep -q "contains .env"'
N=$T/nogit; mkdir -p $N; OUT=$(bash "$SHARE" "$N" 2>&1); code=$?
t "not a git repo: explains instead of zipping" '[ $code = 1 ] && echo "$OUT" | grep -q "Not a git repo"'
rm -rf "$T"
echo; echo "$pass passed, $fail failed"; [ $fail = 0 ]
