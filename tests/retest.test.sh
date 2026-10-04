#!/usr/bin/env bash
# Re-tests the re-test kit: installs it into tests/fixtures/fixed-game (a game whose security was fixed
# by a Code Armour run), checks it passes, then makes 3 typical AI "quick fixes" that undo security and
# checks the re-test catches every one.
HERE="$(cd "$(dirname "$0")" && pwd)"; ROOT="$HERE/.."
T=$(mktemp -d); cp -R "$HERE/fixtures/fixed-game/." "$T/"; cd "$T"
cp "$ROOT"/templates/security-tests/{harness.mjs,run.sh} "$ROOT/scripts/scan.sh" "$ROOT/recipes/supabase/audit.sql" security-tests/
ln -s "$HERE/node_modules" node_modules
pass=0; fail=0
expect_run() {  # name, expected exit (0 = passes, 1 = must fail)
  bash security-tests/run.sh >/tmp/ca-retest.txt 2>&1; got=$?
  [ "$got" = "$2" ] && { pass=$((pass+1)); echo "✓ $1"; } || { fail=$((fail+1)); echo "✗ $1 (exit $got)"; tail -15 /tmp/ca-retest.txt; }
}
expect_run "fixed game passes its saved re-test" 0
grep -q "13 attack checks saved\|attack checks saved" /tmp/ca-retest.txt && { pass=$((pass+1)); echo "✓ scanner sees the saved attack checks"; } || { fail=$((fail+1)); echo "✗ scanner didn't count saved checks"; }
grep -q "GitHub doesn't re-test on push" /tmp/ca-retest.txt && { pass=$((pass+1)); echo "✓ scanner notices there's no GitHub re-test yet"; } || { fail=$((fail+1)); echo "✗ missing-workflow warning"; }
mkdir -p .github/workflows && cp "$ROOT/templates/security-tests/github-workflow.yml" .github/workflows/security-tests.yml
bash security-tests/scan.sh . 2>&1 | grep -q "GitHub re-tests every push" && { pass=$((pass+1)); echo "✓ scanner sees the GitHub re-test once added"; } || { fail=$((fail+1)); echo "✗ workflow not detected"; }
echo 'grant update on public.profiles to authenticated;' > supabase/migrations/003_break.sql
expect_run "caught: players given full update rights (a backup layer still blocked it)" 1
echo 'alter table public.profiles disable row level security;' > supabase/migrations/003_break.sql
expect_run "caught: RLS turned off" 1
echo 'grant execute on function public.add_coins(uuid, int) to anon, authenticated;' > supabase/migrations/003_break.sql
expect_run "caught: free-coins function callable again" 1
echo 'create policy "debug" on public.profiles for select using (true);' > supabase/migrations/003_break.sql
expect_run "caught: a 'temporary' open policy" 1
rm supabase/migrations/003_break.sql
expect_run "passes again once the break is removed" 0
cd /; rm -rf "$T"
echo; echo "$pass passed, $fail failed"; [ $fail = 0 ]
