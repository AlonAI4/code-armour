# Security

## Reporting a problem
Found a way around one of Code Armour's recipes, or a rule that's wrong? Open a GitHub issue, or use **Security → Report a vulnerability** on this repo for anything sensitive. Please include the recipe, the attack, and what happened.

## Dependencies
The skill itself has **no dependencies**: `SKILL.md`, the recipes and `scan.sh` run with what your project already has.

The `tests/` folder uses development tools (PGlite, Stripe, Firebase emulator tools) that run only on a developer's machine or in GitHub Actions, never in your app.
- Vulnerable inner packages are forced to patched versions with npm `overrides` (`tests/package.json`).
- **Known and accepted (Oct 2026):** `braces` ≤ 3.0.3 ([GHSA-vfj7-8cjw-p6xm](https://github.com/advisories/GHSA-vfj7-8cjw-p6xm)), a stack-exhaustion denial of service, comes in through `firebase-tools` → `chokidar`. No patched version exists yet. It only affects file-watching while tests run locally, so it's accepted until a fix ships. Dependabot will flag it until then.
