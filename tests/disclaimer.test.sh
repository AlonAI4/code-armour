#!/usr/bin/env bash
# The disclaimer must be in every place users see it, and the MIT warranty wording must stay.
HERE="$(cd "$(dirname "$0")" && pwd)"; R="$HERE/.."; pass=0; fail=0
LINE="Code Armour is an AI-run checklist that lowers risk. It isn't legal advice or a professional security audit, guarantees nothing, and its authors aren't responsible if you get hacked, sued or fined."
t() { if eval "$2"; then pass=$((pass+1)); echo "✓ $1"; else fail=$((fail+1)); echo "✗ $1"; fi; }
t "README: disclaimer near the top (first 12 lines)" 'head -12 "$R/README.md" | grep -qF "$LINE"'
t "README: full disclaimer and limitation of liability section" 'grep -q "^## Disclaimer and limitation of liability" "$R/README.md" && grep -q "fullest extent permitted by applicable law" "$R/README.md" && grep -q "can.t legally be excluded" "$R/README.md"'
t "COMPLIANCE.md template: disclaimer in the first 4 lines" 'head -4 "$R/templates/COMPLIANCE.md" | grep -qF "$LINE"'
for c in armour armourcheck armourtest armourcost; do
  t "/$c ends its report with the disclaimer line" 'grep -qF "$LINE" "$R/commands/$c.md" && tail -3 "$R/commands/$c.md" | grep -qF "$LINE"'
done
t "SKILL.md: report ends with it, COMPLIANCE keeps it" 'grep -qF "$LINE" "$R/SKILL.md" && grep -q "Keep the disclaimer line at the top" "$R/SKILL.md"'
t "/armourcost script prints it last" 'node "$R/scripts/armour-cost.mjs" --home "$(mktemp -d)" --project "$(mktemp -d)" | tail -1 | grep -qF "$LINE"'
t "LICENSE keeps MIT's 'AS IS, WITHOUT WARRANTY' wording" 'grep -q "PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND" "$R/LICENSE" && grep -q "IN NO EVENT SHALL THE" "$R/LICENSE"'
echo; echo "$pass passed, $fail failed"; [ $fail = 0 ]
