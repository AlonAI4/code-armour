---
description: Add Code Armour to this project. Checks for common security, privacy and legal mistakes, fixes what you approve, re-tests each fix.
argument-hint: "[live-url] [anything to focus on]"
---
Run the **code-armour** skill on this project from start to finish. Its SKILL.md is in the skill folder (usually `~/code-armour/` or the skills folder of this tool).

1. Follow every step:
   - ask what you need;
   - choose the rules that apply;
   - scan (for a cloned or forked project, in clone mode: `CA_BASE=<the original's branch> bash scripts/scan.sh`, so each finding says whether it's in the user's changes or the original's code);
   - **show the plan and ask "Should I apply these fixes?"** (Step 3b), then fix only what was approved;
   - test each fix for real;
   - save the tests in `security-tests/` (Step 5b), and prove they can fail;
   - write `COMPLIANCE.md`;
   - report in the skill's Step 7 order: 🔧 Confirmed technical issues · 🔍 Potential issues requiring verification · 📋 General compliance considerations · ⚖️ Professional advice recommended (with who to ask) · what was checked and not checked.
   - if the project will be shared as a zip or folder, warn that a plain zip carries the hidden `.env`, and offer `recipes/sharing/share-zip.sh`, which builds the zip from the code saved in git.
2. If the project already has `COMPLIANCE.md` or `security-tests/`, start with the skill's **Re-testing** section instead of starting over.
3. Ask before anything risky: live database, deleting data, rotating keys, account settings.
4. Offer to add the GitHub re-test workflow.

Extra details from the user (may be empty): $ARGUMENTS

**End every report with this disclaimer, word for word:** *Code Armour provides automated technical checks and general compliance information. It does not provide legal advice, certify compliance, guarantee security or identify every possible risk. Results may be incomplete or incorrect. Users remain responsible for testing their websites, reviewing applicable requirements and obtaining professional advice where appropriate.*
