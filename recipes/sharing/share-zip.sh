#!/usr/bin/env bash
# Code Armour recipe: share a project as a zip WITHOUT your keys.
# A Finder/Explorer zip of the folder carries everything in it, including the git-ignored .env, caches and logs.
# This builds the zip from the code SAVED IN GIT instead, so ignored files can't get in.
#   bash share-zip.sh [project-dir] [branch-or-commit] [output.zip]
#   SHARE_SKIP="docs/media big-folder" bash share-zip.sh     (leave large folders out)
# CHANGE: nothing is required. Defaults: this folder, the current commit, ../<folder>-share.zip (outside the project).
# It refuses to finish if the zip holds a .env file or any real value from your .env. Values are never printed.
set -u
cd "${1:-.}" || { echo "Can't open ${1:-.}"; exit 1; }
REF="${2:-HEAD}"
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "✗ Not a git repo: commit the project to git first (git init, add a .gitignore with .env*, git add, git commit)"; exit 1; }
git rev-parse --verify -q "$REF^{commit}" >/dev/null || { echo "✗ No such branch or commit: $REF"; exit 1; }
OUT="${3:-$(dirname "$PWD")/$(basename "$PWD")-share.zip}"
[ -n "$(git status --porcelain 2>/dev/null)" ] && echo "? Uncommitted changes are NOT in the zip: only what is saved in $REF goes in."

PATHS=(.); for s in ${SHARE_SKIP:-}; do PATHS+=(":(exclude)$s"); done
rm -f "$OUT"
git archive --format=zip -o "$OUT" "$REF" -- "${PATHS[@]}" || { echo "✗ git archive failed"; exit 1; }

# Check 1: no .env file inside (a .env that was committed by mistake would be).
names=$(unzip -Z1 "$OUT")
envin=$(echo "$names" | grep -E '(^|/)\.env[^/]*$' | grep -vE '\.(example|sample|template)$')
if [ -n "$envin" ]; then rm -f "$OUT"; echo "✗ Stopped: the saved code contains $envin. Remove it from git (git rm --cached), ROTATE its keys, then try again."; exit 1; fi

# Check 2: no real value from the local .env files anywhere in the saved code (compared, never printed).
bad=0; T=$(mktemp); TAB=$'\t'
for e in $(ls -a | grep -E '^\.env' | grep -vE '\.(example|sample|template)$'); do
  while IFS="$TAB" read -r name val; do
    printf '%s\n' "$val" > "$T"
    hit=$(git grep -lF -f "$T" "$REF" -- "${PATHS[@]}" 2>/dev/null | sed "s/^[^:]*://" | head -3 | tr '\n' ' ')
    [ -n "$hit" ] && { echo "✗ The real value of $name (from $e) is in the saved code: $hit"; bad=1; }
  done < <(sed -nE "s/^[[:space:]]*(export[[:space:]]+)?([A-Za-z_][A-Za-z0-9_]*)[[:space:]]*=[[:space:]]*[\"']?([^\"'#[:space:]]{16,})[\"']?.*/\2${TAB}\3/p" "$e")
done
rm -f "$T"
if [ $bad = 1 ]; then rm -f "$OUT"; echo "✗ Stopped, no zip made. Take the value out of those files, ROTATE the key (git history still has it), then try again."; exit 1; fi

echo "✓ $OUT ($(du -h "$OUT" | cut -f1 | tr -d ' '), $(echo "$names" | grep -vc '/$') files): no .env file and no real .env value inside"
echo "$names" | grep -v '/$' | awk -F/ '{k=(NF>1)?$1"/":"(top level)"; c[k]++} END{for(k in c) printf "  %5d  %s\n", c[k], k}' | sort -k2
echo "Each person you send it to needs their own keys: tell them where to put them (a .env.example file helps)."
