#!/usr/bin/env bash
# The README Quick start, run exactly as written on a fresh computer (empty home folder), in zsh and bash.
# The clone line is swapped for a copy of this checkout, so the test works offline and tests these files.
HERE="$(cd "$(dirname "$0")" && pwd)"; R="$HERE/.."; README="${README:-$R/README.md}"; pass=0; fail=0
t() { if eval "$2"; then pass=$((pass+1)); echo "✓ $1"; else fail=$((fail+1)); echo "✗ $1"; fi; }
# The bash blocks between "## Quick start" and "**Other agents**": block 1 = clone, 2 = Claude Code, 3 = Codex.
blocks=$(awk '/^## Quick start/{q=1} /^\*\*Other agents/{q=0} q&&/^```bash/{b++; inb=1; next} inb&&/^```/{inb=0; next} q&&inb{print b"\t"$0}' "$README")
step() { echo "$blocks" | awk -F'\t' -v n="$1" '$1==n{sub(/^[^\t]*\t/,""); print}'; }
t "README has the clone, Claude Code and Codex steps" '[ -n "$(step 1)" ] && [ -n "$(step 2)" ] && [ -n "$(step 3)" ]'
t "a fresh clone carries no log files (emulator logs are git-ignored)" '[ -z "$(git -C "$R" ls-files | grep -E "\.log$")" ] && git -C "$R" check-ignore -q tests/firestore-debug.log'
t "the clone step clones github.com/AlonAI4/code-armour" 'step 1 | grep -q "git clone https://github.com/AlonAI4/code-armour.git ~/code-armour"'
t "README's risk count (~N risks) is within 10 of security.md's numbered risks" 'n=$(grep -cE "^[0-9]+\.[0-9]+ " "$R/references/security.md"); r=$(grep -oE "~[0-9]+ risks" "$R/README.md" | head -1 | tr -dc 0-9); [ $(( n>r ? n-r : r-n )) -le 10 ]'
t "README's country-file count matches the files in countries-extra" 'n=$(ls "$R"/references/countries-extra/*.md | grep -vc "/README\.md$"); grep -q "each of the $n country files" "$R/README.md"'
for sh in zsh bash; do
  command -v $sh >/dev/null || { echo "  ($sh not installed: skipped)"; continue; }
  H=$(mktemp -d); mkdir -p "$H/code-armour"
  (cd "$R" && tar --exclude=./tests/node_modules --exclude=./.git -cf - .) | (cd "$H/code-armour" && tar -xf -)
  run() { env -i HOME="$H" PATH=/usr/bin:/bin TERM=dumb $sh -ec "$1" >"$H/out.txt" 2>&1; }
  run "$(step 2)"; c1=$?; run "$(step 2)"; c2=$?
  t "$sh: the Claude Code steps work in an empty home folder" '[ $c1 = 0 ]'
  t "$sh: …and running them twice is fine" '[ $c2 = 0 ]'
  t "$sh: the skill is found at ~/.claude/skills/code-armour/SKILL.md" '[ -f "$H/.claude/skills/code-armour/SKILL.md" ] && head -3 "$H/.claude/skills/code-armour/SKILL.md" | grep -q "^name: code-armour"'
  t "$sh: all 4 commands are installed" '(for c in armour armourcheck armourtest armourcost; do [ -f "$H/.claude/commands/$c.md" ] || exit 1; done)'
  run "$(step 3)"; c3=$?
  t "$sh: the Codex steps work too" '[ $c3 = 0 ] && [ -f "$H/.codex/skills/code-armour/SKILL.md" ] && [ -f "$H/.codex/prompts/armour.md" ]'
  out=$(env -i HOME="$H" PATH=/usr/bin:/bin:/opt/homebrew/bin:/usr/local/bin $sh -c 'mkdir -p ~/p && bash ~/.claude/skills/code-armour/scripts/scan.sh ~/p' 2>&1 | tail -1)
  t "$sh: the installed scanner runs and ends with the disclaimer" 'echo "$out" | grep -q "does not provide legal advice"'
  rm -rf "$H"
done
echo; echo "$pass passed, $fail failed"; [ $fail = 0 ]
