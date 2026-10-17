---
description: Check this project's Code Armour. Is it there, still working, and up to date? Changes nothing without asking.
argument-hint: "[live-url]"
---
Check this project's **Code Armour** using the code-armour skill (SKILL.md in the skill folder, usually `~/code-armour/`). **Don't change any files** unless the user asks after seeing the report.

1. **Is the armour there?** Look for:
   - `COMPLIANCE.md`
   - `security-tests/run.sh`
   - `security-tests/*.test.mjs`, with real attacks, not just the template examples
   - `.github/workflows/` with a re-test

   If there's no armour at all, say so and suggest `/armour`. A missing GitHub workflow is a **gap**, not "no armour".
   - **Refresh the tool files first.** The project's `security-tests/scan.sh`, `harness.mjs` and `audit.sql` are copies and may be out of date. Copy the latest ones over them from the skill folder: `scripts/scan.sh` always; `templates/security-tests/harness.mjs` and `recipes/supabase/audit.sql` **only if the project uses a database and still has the template harness** (a project with its own or a plain-Node harness keeps it). If the project's `scan.sh` has local edits (`diff` it first), tell the user what they were before replacing it. Show what would change and **ask before copying**: they're tools, not project code, but they're still the user's files. Never touch `attacks.test.mjs`.
2. **Does it still work?**
   - Run `bash security-tests/run.sh $ARGUMENTS`. If it's missing, run the skill's `scripts/scan.sh . $ARGUMENTS` instead.
   - Every ✗ means a protection broke since the last check. Find the change that caused it with `git log -p`. Not a git repo? Compare file dates with the date in COMPLIANCE.md, and suggest `git init`.
   - Cloned or forked project? Run the scan in clone mode too (`CA_BASE=<the original's branch>`) and check `LICENSE` is unchanged and the credits file still lists what was added.
   - Shared as a zip? Check the last zip was made with `recipes/sharing/share-zip.sh` (built from git), not by zipping the folder, which carries the hidden `.env`.
3. **Coverage gaps:** read `.code-armour/coverage.json` and list the areas that are `not_checked`, `partial`, or that changed since they were checked. Run `node <skill>/scripts/validate-findings.mjs .` and report what it says.
4. **Is it up to date?** Follow the skill's "Re-testing" and "Staying up to date" sections:
   - the date of the last re-test;
   - open items: rows whose status is ❌ or ❓ (list the worst; owner-only tasks separately);
   - **proof that wasn't saved:** tests or evidence cited in COMPLIANCE.md that aren't in `security-tests/`, and features (functions, webhooks, AI endpoints, uploads, name filter) with no check in `security-tests/`;
   - new tables, routes, payments, chat, AI or kids features added since then without attack tests;
   - stale ✅ items (older than 3 months);
   - dates in `references/upcoming.md` that have passed and affect this project.
5. **Report** as a short table: Armour present · Re-test result · Coverage gaps · Out of date · Next steps. Worst problems first. List open findings under the 4 category headings, in this order: 🔧 Confirmed technical issues · 🔍 Potential issues requiring verification · 📋 General compliance considerations · ⚖️ Professional advice recommended (with who to ask). End with which fixes to make, and offer to make them.

**End every report with this disclaimer, word for word:** *Code Armour provides automated technical checks and general compliance information. It does not provide legal advice, certify compliance, guarantee security or identify every possible risk. Results may be incomplete or incorrect. Users remain responsible for testing their websites, reviewing applicable requirements and obtaining professional advice where appropriate.*
