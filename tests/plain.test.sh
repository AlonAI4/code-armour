#!/usr/bin/env bash
# Checks added after the first real run (Forge): git worktrees, projects without a database, slow-regex detection.
HERE="$(cd "$(dirname "$0")" && pwd)"; ROOT="$HERE/.."; T=$(mktemp -d); pass=0; fail=0
ok() { pass=$((pass+1)); echo "✓ $1"; }; no() { fail=$((fail+1)); echo "✗ $1"; }

# 1. A leaked key in history is still found when scanning from a git WORKTREE (where .git is a file).
cd $T && git init -q main && cd main && echo 'k="sk_live_abcdefghijklmnop1234"' > a.js && git add -A && git -c user.email=t@t -c user.name=t commit -qm leak \
  && git rm -q a.js && git -c user.email=t@t -c user.name=t commit -qm clean && git worktree add -q ../wt HEAD 2>/dev/null
cd $T/wt && out=$(bash "$ROOT/scripts/scan.sh" . 2>&1)
echo "$out" | grep -q "git history" && ok "leaked key in history found from a git worktree" || no "worktree history scan (got: $(echo "$out" | grep -i 'git' | head -2))"

# 1b. A copy of scan.sh in the history must NOT flag itself (it contains the key patterns).
mkdir -p $T/selfscan/security-tests && cd $T/selfscan && git init -q && cp "$ROOT/scripts/scan.sh" security-tests/ \
  && git add -A && git -c user.email=t@t -c user.name=t commit -qm "add armour"
out=$(bash security-tests/scan.sh . 2>&1); echo "$out" | grep -q "Secret patterns in git history" && no "scanner flagged its own copy in history" || ok "scanner ignores its own copy in history"

# 2. A project with no database runs its plain tests without PGlite installed.
mkdir -p $T/static/security-tests && cd $T/static && echo '<h1>hi</h1>' > index.html
cp "$ROOT/templates/security-tests/run.sh" "$ROOT/scripts/scan.sh" security-tests/
cat > security-tests/plain.test.mjs <<'X'
const ok = !"<h1>hi</h1>".includes("<script"); console.log(ok ? "✓ no inline script" : "✗ inline script"); process.exit(ok ? 0 : 1);
X
bash security-tests/run.sh >/tmp/ca-plain.txt 2>&1 && ok "no-database project re-tests without PGlite" || { no "no-database run"; grep -E "✗|needs" /tmp/ca-plain.txt; }

# 3. finishesWithin() turns a slow regex (ReDoS) into a failed check instead of a frozen run.
cd "$ROOT/templates/security-tests" && res=$(node --input-type=module -e '
const src = (await import("node:fs")).readFileSync("plain.test.mjs","utf8").split("// Example 1")[0].replace(/^import .*$/mg,"").replace("export function","function").replace(/^let passed[\s\S]*?\n/m,"").replace(/^const check[\s\S]*?\n/m,"");
const { Worker } = await import("node:worker_threads");
const finishesWithin = eval("(" + src.match(/function finishesWithin[\s\S]*?\n}\n/)[0].replace(/^function finishesWithin/,"function") + ")");
const slow = await finishesWithin(1500, `/^(a+)+$/.test("a".repeat(40) + "b")`);
const fast = await finishesWithin(1500, `/^a+$/.test("a".repeat(40) + "b")`);
console.log(slow, fast);')
[ "$res" = "false true" ] && ok "finishesWithin catches a ReDoS and passes fast code" || no "finishesWithin (got: $res)"

cd /; rm -rf "$T"; echo; echo "$pass passed, $fail failed"; [ $fail = 0 ]
