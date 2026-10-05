---
description: Check this project's Code Armour. Is it there, still working, and up to date? Read-only unless you ask for fixes.
argument-hint: "[live-url]"
---
Check this project's **Code Armour** using the code-armour skill (SKILL.md in the skill folder, usually `~/code-armour/`). **Don't change any files** unless the user asks after seeing the report.

1. **Is the armour there?** Look for:
   - `COMPLIANCE.md`
   - `security-tests/run.sh`
   - `security-tests/*.test.mjs`, with real attacks, not just the template examples
   - `.github/workflows/` with a re-test

   If there's no armour at all, say so and suggest `/armour`. A missing GitHub workflow is a **gap**, not "no armour".
   - **Refresh the tool files first.** The project's `security-tests/scan.sh`, `harness.mjs` and `audit.sql` are copies and may be out of date. Copy the latest ones over them from the skill folder: `scripts/scan.sh` always; `templates/security-tests/harness.mjs` and `recipes/supabase/audit.sql` **only if the project uses a database and still has the template harness** (a project with its own or a plain-Node harness keeps it). If the project's `scan.sh` has local edits (`diff` it first), tell the user what they were before replacing it. This is the one change allowed without asking: they're tools, not project code. Never touch `attacks.test.mjs`.
2. **Does it still work?**
   - Run `bash security-tests/run.sh $ARGUMENTS`. If it's missing, run the skill's `scripts/scan.sh . $ARGUMENTS` instead.
   - Every ✗ means a protection broke since the last check. Find the change that caused it with `git log -p`. Not a git repo? Compare file dates with the date in COMPLIANCE.md, and suggest `git init`.
3. **Coverage gaps:** read `.code-armour/coverage.json` and list the areas that are `not_checked`, `partial`, or that changed since they were checked. Run `node <skill>/scripts/validate-findings.mjs .` and report what it says.
4. **Is it up to date?** Follow the skill's "Re-testing" and "Staying up to date" sections:
   - the date of the last re-test;
   - open items: rows whose status is ❌ or ❓ (list the worst; owner-only tasks separately);
   - **proof that wasn't saved:** tests or evidence cited in COMPLIANCE.md that aren't in `security-tests/`, and features (functions, webhooks, AI endpoints, uploads, name filter) with no check in `security-tests/`;
   - new tables, routes, payments, chat, AI or kids features added since then without attack tests;
   - stale ✅ items (older than 3 months);
   - dates in `references/upcoming.md` that have passed and affect this project.
5. **Report** as a short table: Armour present · Re-test result · Coverage gaps · Out of date · Next steps. Worst problems first. End with which fixes to make, and offer to make them.
