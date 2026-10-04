# Code Armour

A pre-launch skill that lowers your risk of getting hacked or sued, for vibe coders. Your AI coding agent:
1. asks where you are and what you're building,
2. keeps only the rules that apply,
3. scans your real code,
4. fixes problems with tested recipes,
5. proves each fix by trying the attack, and
6. writes a `COMPLIANCE.md` checklist.

**It's a checklist, not legal advice.**

It covers security, privacy, kids, selling, tax, IP, user content and AI rules for the UK, EU and US, plus 24 more countries. It works with Supabase, Firebase, Postgres/Prisma, Convex, PocketBase, Appwrite, MongoDB, Netlify, Vercel, Cloudflare, Next.js, Express, Stripe, Lemon Squeezy and Paddle.

## Commands

| Command | What it does |
|---|---|
| `/armour` | **Adds the armour.** Asks about the project, finds and fixes security and legal risks, proves each fix by attacking it, saves the attacks as re-tests in `security-tests/`, and writes `COMPLIANCE.md`. |
| `/armourcheck` | **Checks the armour.** Is it there, do the saved re-tests still pass, and is anything new or out of date? Read-only unless you ask for fixes. |
| `/armourtest` | **Tests the armour.** A lawyer agent reviews it and a hacker agent attacks local copies (never live systems). Then their findings are verified, and every fix gets a new re-test. |

In Codex, custom prompts are called with `/prompts:armour`, `/prompts:armourcheck` and `/prompts:armourtest`. Or just ask: "run code armour".

## Install

It uses the open Agent Skills format (a folder with a `SKILL.md`), so one copy works in several tools.

**Claude Code**
```bash
ln -s ~/code-armour ~/.claude/skills/code-armour
```
Commands:
```bash
mkdir -p ~/.claude/commands && for c in armour armourcheck armourtest; do ln -sfn ~/code-armour/commands/$c.md ~/.claude/commands/$c.md; done
```
Then type `/armour`, or say "is my project safe to launch?".

**Codex**
```bash
ln -s ~/code-armour ~/.codex/skills/code-armour
```
Commands:
```bash
mkdir -p ~/.codex/prompts && for c in armour armourcheck armourtest; do ln -sfn ~/code-armour/commands/$c.md ~/.codex/prompts/$c.md; done
```
Then type `/prompts:armour`, or `$code-armour`.

**Other agents** (Cursor, Gemini CLI, Copilot, Windsurf…)
- If your tool supports Agent Skills, put the folder in its skills directory.
- Otherwise, add this to the project's `AGENTS.md` (or `.cursorrules` / `GEMINI.md`):
  ```
  Before launch, or when asked about security, privacy or legal readiness, follow ~/code-armour/SKILL.md step by step.
  ```

## What's inside
| Path | What |
|---|---|
| `SKILL.md` | The step-by-step instructions the agent follows |
| `references/security.md` | ~70 ways apps get hacked or run up bills, each with a CHECK |
| `references/legal.md` | UK, EU and US legal risks |
| `references/countries-*.md` | 24 more countries |
| `references/stacks.md` | How each protection works on each platform |
| `recipes/` | Ready-to-adapt code: Supabase SQL and Edge Functions, Firebase rules, Netlify/Vercel/Cloudflare headers, Stripe/Lemon Squeezy/Paddle webhooks, Express, Next.js |
| `scripts/scan.sh` | Quick scanner: secrets, git history, risky code, npm audit, live headers |
| `commands/` | `/armour`, `/armourcheck`, `/armourtest` |
| `templates/` | `COMPLIANCE.md` checklist, a plain-words privacy policy, the re-test kit (`security-tests/`), the lawyer and hacker reviewer briefs, and the new-country research template |
| `references/upcoming.md` | Watchlist of laws with future dates, checked against today on every run |
| `references/countries-extra/` | Countries researched on demand (Thailand so far). Pull requests welcome |

## Tested, not just written

Run the tests with `cd tests && npm install && npm test`. GitHub Actions also runs them on every push. They do three things:

1. **Database recipes vs. real Postgres** (`sql.test.mjs`, 75 checks). Each recipe runs on real Postgres (PGlite, running inside Node) with Supabase-style roles, and then gets attacked. The attacks: reading or editing other users' rows, making yourself admin, creating a profile with free coins, look-alike-letter swear words, fake or farmed scores, double payouts.
2. **Webhooks and server functions** (`webhooks.test.mjs`, 23 checks). These use real Stripe signatures and real Lemon Squeezy/Paddle HMACs. They check that fake, tampered, replayed and duplicate events are rejected, that endpoints refuse anyone not logged in, and that daily AI limits hold.
3. **The scanner** (`scan.test.sh`, 29 checks), run against planted leaks, a clean app (no false alarms) and `tests/fixtures/vuln-game`, a deliberately broken game.
4. **The re-test kit** (`retest.test.sh`, 9 checks). A game fixed by Code Armour passes its saved re-test. Then four typical AI "quick fixes" that undo security each turn it red, and removing them turns it green again.

The skill was also reviewed by three AI agents (4 Oct 2026):
- **A skill test.** A fresh agent followed `SKILL.md` on the broken game. It found almost all of the 30 planted problems and fixed them, with tests.
- **A lawyer review.** It corrected cookie, AI Act, accessibility and consumer-law details, and rewrote the privacy template to cover GDPR Art. 13.
- **A red team.** It found the bypasses in the name filter, the profile insert, score farming, webhook replay and the scanner. Each is now fixed and has a test.

These are AI reviews. They are **not** a human lawyer or a professional penetration test.

## Limits

These are honest limits, not modesty:
- Laws change, and some country details are marked "unverified" in the files.
- The scanner only finds known patterns.
- Recipes need adapting to your tables and routes.
- The Firebase rules and the two Supabase Edge Functions are type-checked and reviewed, but not run in this test suite (they need the Firebase emulator or a Supabase project).
- The name filter can't catch everything. One example is random characters used in place of letters. Keep a report button.
- Research date: October 2026. Re-check anything important.
