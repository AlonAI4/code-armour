---
description: Add Code Armour to this project. Finds and fixes security and legal risks, proves each fix, saves re-tests.
argument-hint: "[live-url] [anything to focus on]"
---
Run the **code-armour** skill on this project from start to finish. Its SKILL.md is in the skill folder (usually `~/code-armour/` or the skills folder of this tool).

1. Follow every step:
   - ask what you need;
   - choose the rules that apply;
   - scan;
   - **show the plan and ask "Should I put the armour on?"** (Step 3b), then fix only what was approved;
   - test each fix for real;
   - save the tests in `security-tests/` (Step 5b), and prove they can fail;
   - write `COMPLIANCE.md`;
   - report.
2. If the project already has `COMPLIANCE.md` or `security-tests/`, start with the skill's **Re-testing** section instead of starting over.
3. Ask before anything risky: live database, deleting data, rotating keys, account settings.
4. Offer to add the GitHub re-test workflow.

Extra details from the user (may be empty): $ARGUMENTS

**End every report with this one line:** *Code Armour is an AI-run checklist that lowers risk. It isn't legal advice or a professional security audit, guarantees nothing, and its authors aren't responsible if you get hacked, sued or fined.*
