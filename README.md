# 🛡️ Code Armour

[![tests](https://github.com/AlonAI4/code-armour/actions/workflows/test.yml/badge.svg)](https://github.com/AlonAI4/code-armour/actions/workflows/test.yml)
![license](https://img.shields.io/badge/license-MIT-blue)
![works with](https://img.shields.io/badge/works%20with-Claude%20Code%20%7C%20Codex%20%7C%20Agent%20Skills-black)

**A skill for AI coding agents that checks your app before launch, so you're less likely to get hacked, get a surprise bill, or break a law you didn't know about. Then it proves every fix works.**

Made for vibe coders: solo builders, beginners and teenagers who build with AI and ship fast.

> ⚠️ Code Armour is a checklist run by an AI. It is **not legal advice** and not a professional security audit. It lowers risk; it can't promise you're safe.

---

## Why this exists

AI writes code that works, but it often isn't safe:

- **When the database blocks a request, AI "fixes" it by switching the protection off.** In 2025, 170+ apps built with one AI tool leaked their whole database this way ([CVE-2025-48757](https://www.sentinelone.com/vulnerability-database/cve-2025-48757/)).
- **AI puts secret keys where anyone can see them.** One stolen AI key ran up an **$82,000 bill in 24 hours**.
- **Payments get faked.** If nobody checks Stripe's signature, anyone can send a fake "paid" message and get things for free.
- **Laws apply even to tiny apps:** privacy rules, kids' rules (under 13s), tax on digital sales, loot-box bans, AI labels. They differ in every country.

Most checklists only *list* these things. Code Armour **finds them in your real code, fixes them, attacks its own fixes to prove they work, and keeps re-testing** so a later "quick fix" can't quietly undo them.

## What a run looks like

You type `/armour` in your project. The agent:

1. **Asks** what it can't work out from your code: your country, where your users are, whether you take payments, and whether kids might use it.
2. **Picks only the rules that apply.** No payments means no tax section. Kids possible means the kids' rules switch on. When countries disagree, the strictest rule wins.
3. **Scans** the code, the git history, the build and the live site.
4. **Fixes** problems using tested recipes, adapted to your tables and routes.
5. **Attacks every fix to prove it.** It signs in as a second user and tries to read your data, sends a fake payment, and tries to make itself admin. Each attack must fail.
6. **Saves those attacks as tests** in `security-tests/`, so `bash security-tests/run.sh` (or GitHub, on every push) re-checks them forever.
7. **Writes `COMPLIANCE.md`**, a dated checklist:
   - ✅ done, with proof
   - ❌ not done
   - ➖ doesn't apply, and why
   - ❓ needs checking

   Legal items never get an automatic ✅, because code can't prove a law is followed: a person has to review them.

## Commands

| Command | What it does |
|---|---|
| `/armour` | **Add the armour.** The full run above. |
| `/armourcheck` | **Check the armour.** Is it there, do the saved tests still pass, and has anything new been added or gone out of date? Changes nothing unless you ask. |
| `/armourtest` | **Test the armour.** A *lawyer* agent reviews your legal pages and a *hacker* agent attacks local copies of your app (never live systems). Their findings are double-checked, and every real one becomes a new saved test. |

You can also just ask: *"is my project safe to launch?"*

## Quick start

```bash
git clone https://github.com/AlonAI4/code-armour.git ~/code-armour
```

**Claude Code**
```bash
ln -s ~/code-armour ~/.claude/skills/code-armour
mkdir -p ~/.claude/commands && for c in armour armourcheck armourtest; do ln -sfn ~/code-armour/commands/$c.md ~/.claude/commands/$c.md; done
```
Then open your project and type `/armour`.

**Codex**
```bash
ln -s ~/code-armour ~/.codex/skills/code-armour
mkdir -p ~/.codex/prompts && for c in armour armourcheck armourtest; do ln -sfn ~/code-armour/commands/$c.md ~/.codex/prompts/$c.md; done
```
Then type `/prompts:armour` or `$code-armour`.

**Other agents** (Cursor, Gemini CLI, Copilot, Windsurf…): if they support Agent Skills, put the folder in their skills directory. If not, add this line to your project's `AGENTS.md`:
```
Before launch, or when asked about security, privacy or legal readiness, follow ~/code-armour/SKILL.md step by step.
```

## What it checks

| Area | Examples |
|---|---|
| 🔑 **Leaked secrets** | Keys in the browser bundle or git history, `VITE_`/`NEXT_PUBLIC_` mistakes, database passwords, admin keys |
| 🗄️ **Data access** | Supabase RLS off or fake (`using (true)`), Firebase "test mode" rules, users editing other users' data, making themselves admin, public storage buckets |
| 💳 **Payments** | Unverified webhooks, prices set by the browser, double payouts, replayed events |
| 💸 **Surprise bills** | AI endpoints anyone can spam, no spend caps, bot signups |
| 🎮 **Games** | Fake scores, coin cheating, unsafe usernames (look-alike letters, emails, links), loot boxes |
| 🌐 **Website** | Security headers, XSS, exposed `/.env`, outdated or invented packages |
| 🧒 **Kids** | COPPA, UK Children's Code, Brazil, India, Indonesia and more: age gates, guest mode, no chat with strangers |
| 🔒 **Privacy** | Privacy policy that matches the code, a working "delete my account", cookies, trackers |
| 🧾 **Selling and tax** | Refund rights, subscriptions, VAT/GST for foreign sellers (the skill usually suggests a Merchant of Record) |
| 🤖 **AI apps** | AI labels, prompt injection, secrets in system prompts, AI with too much power, AI companions, CSAM/deepfake duties, image-generation moderation |
| 🛠️ **Your tools** | GitHub Actions hacks, dev servers left open, malicious extensions/MCP servers/skills, Docker secrets |
| 📱 **Stores** | App Store, Google Play, Chrome Web Store, Steam, Discord rules that get apps removed |
| ⚖️ **Content and IP** | Asset licences, UK Online Safety Act, EU DSA, takedowns |

**Countries:**
- In depth: UK, EU, US.
- Summarised: 24 more (India, China, Brazil, Japan, Korea, Indonesia, Nigeria, Canada, Australia and others).
- Researched with the skill's own template: Thailand, Switzerland, Norway, Ukraine, Malaysia, Taiwan, Hong Kong, New Zealand, Colombia, Chile, Morocco, Ghana, plus what Germany, France, Italy, Spain, the Netherlands and Poland add on top of EU law.
- Any other country: the skill researches it with a fixed template and saves it for next time.
- **Upcoming laws:** a watchlist of laws with future dates, compared with today on every run.

**Stacks:** Supabase, Firebase, Postgres/Prisma, Convex, PocketBase, Appwrite, MongoDB · Netlify, Vercel, Cloudflare, Firebase Hosting · Next.js, Express · Stripe, Lemon Squeezy, Paddle.

## Tested, not just written

Every recipe is attacked by an automated test suite. [GitHub Actions](https://github.com/AlonAI4/code-armour/actions) runs it on every push. Run it yourself with `cd tests && npm install && npm test`.

| Suite | Checks | What it proves |
|---|---|---|
| `sql.test.mjs` | 75 | Database recipes on **real Postgres** (PGlite) with Supabase-style roles. Attacks include: reading other users' rows, self-admin, free coins at signup, look-alike swear words, farmed scores, double payouts. |
| `webhooks.test.mjs` | 23 | Payment and AI endpoints with **real Stripe signatures** and Lemon Squeezy/Paddle HMACs: fake, tampered, replayed and duplicate events rejected; logged-out users refused; daily AI limits hold. |
| `scan.test.sh` | 62 | The scanner catches planted leaks, risky GitHub workflows, legal red flags in code (SMS, face AI, crypto, extension manifests…) and the deliberately broken test game, and gives **no false alarms** on a clean app or on real patterns that caused false alarms before. |
| `retest.test.sh` | 9 | A fixed game passes its saved re-test. Four typical AI "quick fixes" that undo security each turn it **red**. |
| `firestore.test.mjs` | 12 | Firestore rules in the **real Firebase emulator**. |
| `plain.test.sh` | 5 | Projects with no database: git worktrees, monorepo `npm audit`, the slow-regex detector, the scanner ignoring its own copy. |

### Reviewed and attacked

On 4 Oct 2026, every part was reviewed or attacked by independent checks:

- **A skill test:** a fresh AI agent followed the skill on a game with 30 planted problems. It found almost all of them and fixed them, with tests.
- **A lawyer agent:** corrected cookie, AI Act, accessibility and consumer-law details, and rewrote the privacy template to cover GDPR Art. 13.
- **A hacker agent:** found bypasses in the name filter, profile creation, the scoring and webhook replay. All fixed, all now tested.
- **NVIDIA [SkillSpector](https://github.com/NVIDIA/SkillSpector):** its AI reviewer confirmed one real bug the hacker agent had missed. In Firestore rules v2, `{sub=**}` also matches the profile document itself, so players could make themselves admin. It was reproduced in the emulator, fixed, and is now tested. SkillSpector's AI disagreed with every other high finding.

These are AI and automated reviews, **not** a human lawyer or a professional penetration test.

## What's inside

| Path | What |
|---|---|
| `SKILL.md` | The step-by-step instructions the agent follows |
| `commands/` | `/armour`, `/armourcheck`, `/armourtest` |
| `references/` | Security (~120 risks incl. GitHub Actions, AI agents, extensions, MCP), legal (UK/EU/US incl. lawsuit-heavy US laws, app-store rules, EU 2026 product laws), 37 countries + EU national rules, stacks, upcoming-laws watchlist (~60 dated items) |
| `recipes/` | Ready-to-adapt fixes: Supabase SQL and Edge Functions, Firebase rules, headers for Netlify, Vercel and Cloudflare, Stripe/Lemon Squeezy/Paddle webhooks, Express, Next.js |
| `scripts/scan.sh` | Quick scanner: secrets, git history, risky code, packages, live headers, and whether the project's own armour is set up |
| `templates/` | `COMPLIANCE.md`, a plain-words privacy policy, the re-test kit, lawyer and hacker briefs, the country research template |
| `tests/` | The suites above, plus the broken and fixed test games |

## Honest limits

- Laws change. Some country details are marked "unverified", and every reference file shows its research date (October 2026).
- The scanner finds known patterns. A clean scan isn't proof of safety, which is why the attack tests exist.
- Recipes need adapting to your app. The two Supabase Edge Functions are type-checked but not run in the suite, because they need a live Supabase project.
- The name filter can't catch everything (for example, random characters standing in for letters). Keep a report button.
- Most enforcement risk depends on scale. Severity labels mean "how likely is trouble for a small app", **not** "does the law apply".

## Contributing

Pull requests are welcome, especially:
- new countries in `references/countries-extra/` (use `templates/country-research.md`);
- new recipes, **with a test that attacks them**;
- corrections with a source link.

## About

Built by Alon with Claude Code, October 2026. MIT licensed.
