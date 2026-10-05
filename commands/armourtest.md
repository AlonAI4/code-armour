---
description: Stress-test this project's Code Armour checks with an AI legal reviewer and an AI attacker (not a lawyer or a professional pen test).
argument-hint: "[live-url or focus]"
---
Stress-test this project's **Code Armour** with two independent reviewers, using the code-armour skill (SKILL.md in the skill folder, usually `~/code-armour/`). If the project has no armour yet, say so and suggest `/armour` first.

0. **Before anything:** run `git status` and report any changes you didn't expect. Save full command output to files (don't cut it with `tail`), so nothing gets lost.
1. **Start two reviewers with fresh context, in parallel if your tool can start sub-agents.** Claude Code: two Agent calls in one message. In tools without sub-agents, do them yourself one after the other, and start each one fresh: don't reuse your earlier conclusions.
   - **Lawyer:** give it `templates/reviewers/lawyer.md` from the skill folder, plus this project's path.
   - **Hacker:** give it `templates/reviewers/hacker.md` from the skill folder, plus this project's path and the live URL if given: $ARGUMENTS
   - **Rules for both:**
     - They may only work on throwaway copies or local test databases (PGlite).
     - They must **never attack a live site, database or account**, except read-only checks of the URL the user gave.
     - Reviewers report. They don't edit the project.
2. **When both are done, verify their findings yourself.**
   - Re-run each proof that was "proved by running".
   - Read the code for each "theoretical" finding.
   - Drop anything you can't confirm, and say you dropped it.
   - Check COMPLIANCE.md against the skill's own rules (legal rows never ✅; every ✅ has proof that still holds).
3. **Report** under these headings, in this order, worst first inside each:
   - 🔧 Confirmed technical issues;
   - 🔍 Potential issues requiring verification (including "theoretical" ones);
   - 📋 General compliance considerations;
   - ⚖️ Professional advice recommended (with who to ask);
   - what was checked and not checked, and what the armour already handles well.

   Then offer to fix the confirmed issues. Every fix must come with a new check in `security-tests/` so it stays fixed, then re-run `bash security-tests/run.sh`.
4. **Record** every finding in `.code-armour/findings.json` with its verdict (`confirmed` / `needs_validation` / `rejected`) and its category (SKILL.md Step 3a), add this run to `.code-armour/coverage.json`, and run `scripts/validate-findings.mjs`.
5. **Be clear:** these are AI reviewers, not a human lawyer or a professional penetration test. One run finds only part of what repeated runs find, so run `/armourtest` again after big changes, and aim each new run at the gaps in the coverage ledger.

**End every report with this disclaimer, word for word:** *Code Armour provides automated technical checks and general compliance information. It does not provide legal advice, certify compliance, guarantee security or identify every possible risk. Results may be incomplete or incorrect. Users remain responsible for testing their websites, reviewing applicable requirements and obtaining professional advice where appropriate.*
