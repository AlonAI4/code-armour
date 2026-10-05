#!/usr/bin/env bash
# The standard disclaimer must be in every place users see it (and wherever legal guidance is given), and the MIT warranty wording must stay.
HERE="$(cd "$(dirname "$0")" && pwd)"; R="$HERE/.."; pass=0; fail=0
LINE="Code Armour provides automated technical checks and general compliance information. It does not provide legal advice, certify compliance, guarantee security or identify every possible risk. Results may be incomplete or incorrect. Users remain responsible for testing their websites, reviewing applicable requirements and obtaining professional advice where appropriate."
t() { if eval "$2"; then pass=$((pass+1)); echo "✓ $1"; else fail=$((fail+1)); echo "✗ $1"; fi; }
t "README: disclaimer near the top (first 15 lines)" 'head -15 "$R/README.md" | grep -qF "$LINE"'
t "README: full disclaimer and limitation of liability section" 'grep -q "^## Disclaimer and limitation of liability" "$R/README.md" && grep -q "fullest extent permitted by applicable law" "$R/README.md" && grep -q "can.t legally be excluded" "$R/README.md"'
t "COMPLIANCE.md template: disclaimer in the first 4 lines" 'head -4 "$R/templates/COMPLIANCE.md" | grep -qF "$LINE"'
for c in armour armourcheck armourtest armourcost; do
  t "/$c ends its report with the disclaimer line" 'grep -qF "$LINE" "$R/commands/$c.md" && tail -3 "$R/commands/$c.md" | grep -qF "$LINE"'
done
t "SKILL.md: report ends with it, COMPLIANCE keeps it" 'grep -qF "$LINE" "$R/SKILL.md" && grep -q "Keep the disclaimer block at the top" "$R/SKILL.md"'
t "/armourcost script prints it last" 'node "$R/scripts/armour-cost.mjs" --home "$(mktemp -d)" --project "$(mktemp -d)" | tail -1 | grep -qF "$LINE"'
t "SKILL.md: Ground rule 9 (legal guidance always comes with the disclaimer)" 'grep -q "Legal guidance always comes with the disclaimer" "$R/SKILL.md"'
t "scan.sh output ends with the disclaimer" 'E=$(mktemp -d); bash "$R/scripts/scan.sh" "$E" 2>/dev/null | tail -1 | grep -qF "$LINE"'
t "privacy-policy template carries the disclaimer (in its comment)" 'grep -qF "$LINE" "$R/templates/privacy-policy.md"'
for f in references/legal.md references/countries-apac.md references/countries-americas-africa-mideast.md references/upcoming.md references/countries-extra/README.md; do
  t "$f carries the disclaimer" 'grep -qF "$LINE" "$R/$f"'
done
t "the old 'aren't responsible if you get hacked' line is gone everywhere outside tests/" '! grep -rlF "aren'"'"'t responsible if you get hacked" --exclude-dir=tests --exclude-dir=.git --exclude-dir=node_modules "$R"'
t "LICENSE keeps MIT's 'AS IS, WITHOUT WARRANTY' wording" 'grep -q "PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND" "$R/LICENSE" && grep -q "IN NO EVENT SHALL THE" "$R/LICENSE"'
echo; echo "$pass passed, $fail failed"; [ $fail = 0 ]
