#!/usr/bin/env bash
# Code Armour re-test: runs every saved security check for this project. Exit code 1 = something failed.
# Usage: bash security-tests/run.sh [live-url]
# Runs: the scanner, the database attack tests, and (with a URL) live-site header checks.
cd "$(dirname "$0")/.." || exit 1
status=0
echo "== 1. Scanner =="
bash security-tests/scan.sh . "${1:-}" || status=1
echo; echo "== 2. Attack tests =="
if [ -d supabase/migrations ] || ls security-tests/*.test.mjs >/dev/null 2>&1; then
  if [ ! -d node_modules/@electric-sql/pglite ]; then echo "Run once: npm i -D @electric-sql/pglite"; status=1; else
    for t in security-tests/*.test.mjs; do echo "-- $t"; node "$t" || status=1; done
  fi
fi
echo; [ $status = 0 ] && echo "RE-TEST PASSED: every saved check still holds." || echo "RE-TEST FAILED: read the ✗ lines above. A fix may have been undone."
exit $status
