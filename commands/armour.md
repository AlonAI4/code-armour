---
description: Add Code Armour to this project. Finds and fixes security and legal risks, proves each fix, saves re-tests.
argument-hint: "[live-url] [anything to focus on]"
---
Run the **code-armour** skill on this project from start to finish. Its SKILL.md is in the skill folder (usually `~/code-armour/` or the skills folder of this tool).

1. Follow every step:
   - ask what you need;
   - choose the rules that apply;
   - scan;
   - fix with the recipes;
   - test each fix for real;
   - save the tests in `security-tests/` (Step 5b), and prove they can fail;
   - write `COMPLIANCE.md`;
   - report.
2. If the project already has `COMPLIANCE.md` or `security-tests/`, start with the skill's **Re-testing** section instead of starting over.
3. Ask before anything risky: live database, deleting data, rotating keys, account settings.
4. Offer to add the GitHub re-test workflow.

Extra details from the user (may be empty): $ARGUMENTS
