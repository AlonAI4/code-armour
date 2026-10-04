# Code Armour

A pre-launch "don't get hacked, don't get sued" skill for vibe coders. Your AI coding agent:
1. asks where you are and what you're building,
2. keeps only the rules that apply,
3. scans your real code,
4. fixes problems with tested recipes,
5. proves each fix by trying the attack, and
6. writes a `COMPLIANCE.md` checklist.

**It's a checklist, not legal advice.**

It covers security, privacy, kids, selling, tax, IP, user content and AI rules for the UK, EU and US, plus 24 more countries. It works with Supabase, Firebase, Postgres/Prisma, Convex, PocketBase, Appwrite, MongoDB, Netlify, Vercel, Cloudflare, Next.js, Express, Stripe, Lemon Squeezy and Paddle.

## Install

It uses the open Agent Skills format (a folder with a `SKILL.md`), so one copy works in several tools.

**Claude Code**
```bash
ln -s ~/code-armour ~/.claude/skills/code-armour
```
Then say "run code armour" or "is my project safe to launch?".

**Codex**
```bash
ln -s ~/code-armour ~/.codex/skills/code-armour
```
Then say the same thing, or `$code-armour`.

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
| `templates/` | `COMPLIANCE.md` checklist and a plain-words privacy policy |

## Limits

These are honest limits, not modesty:
- Laws change, and some country details are marked "unverified" in the files.
- The scanner only finds known patterns.
- Recipes need adapting to your tables and routes.
- Research date: October 2026. Re-check anything important.
