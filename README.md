# 🛡️ Code Armour

[![tests](https://github.com/AlonAI4/code-armour/actions/workflows/test.yml/badge.svg)](https://github.com/AlonAI4/code-armour/actions/workflows/test.yml)
![license](https://img.shields.io/badge/license-MIT-blue)
![works with](https://img.shields.io/badge/works%20with-Claude%20Code%20%7C%20Codex%20%7C%20Agent%20Skills-black)

**Before you ship your vibe-coded website, Code Armour checks for the mistakes that can lead to hacks, privacy complaints and legal problems.** It fixes what you approve and re-tests each fix against the attack it's meant to stop.

Made for vibe coders: solo builders, beginners and teenagers who build with AI and ship fast.

> ⚠️ **Code Armour provides automated technical checks and general compliance information. It does not provide legal advice, certify compliance, guarantee security or identify every possible risk. Results may be incomplete or incorrect. Users remain responsible for testing their websites, reviewing applicable requirements and obtaining professional advice where appropriate.** The full [disclaimer and limitation of liability](#disclaimer-and-limitation-of-liability) below applies, as far as the law allows.

---

## Why this exists

AI writes code that works, but it often isn't safe:

- **When the database blocks a request, AI "fixes" it by switching the protection off.** In 2025, 170+ apps built with one AI tool leaked their whole database this way ([CVE-2025-48757](https://www.sentinelone.com/vulnerability-database/cve-2025-48757/)).
- **AI puts secret keys where anyone can see them.** One stolen AI key ran up an **$82,000 bill in 24 hours**.
- **Payments get faked.** If nobody checks Stripe's signature, anyone can send a fake "paid" message and get things for free.
- **Laws apply even to tiny apps:** privacy rules, kids' rules (under 13s), tax on digital sales, loot-box bans, AI labels. They differ in every country.

Most checklists only *list* these things. Code Armour **finds them in your real code, fixes them, attacks its own fixes, and keeps re-testing**, so the saved checks flag it if a later "quick fix" undoes one.

## What a run looks like

You type `/armour` in your project. The agent:

1. **Asks** what it can't work out from your code: your country, where your users are, whether you take payments, and whether kids might use it.
2. **Picks the rules likely to apply, based on your answers.** No payments means no tax section. Kids possible means the kids' rules switch on. When countries disagree, it defaults to the strictest one.
3. **Scans** the code, the git history, the build and the live site.
4. **Fixes** problems using tested recipes, adapted to your tables and routes.
5. **Tests every fix by trying the attack it should stop.** It signs in as a second user and tries to read your data, sends a fake payment, and tries to make itself admin. Each attack must fail.
6. **Saves those attacks as tests** in `security-tests/`, so `bash security-tests/run.sh` re-runs them whenever you run it (or GitHub, on every push, once you add the workflow).
7. **Writes `COMPLIANCE.md`**, a dated checklist:
   - ✅ this check passed (with proof). It never means "compliant".
   - ❌ not done
   - ➖ likely doesn't apply, and why
   - ❓ needs checking

   Each finding is labelled with one of 4 categories: 🔧 Confirmed technical issue · 🔍 Potential issue requiring verification · 📋 General compliance consideration · ⚖️ Professional advice recommended.

   Legal items never get an automatic ✅, because code can't prove a law is followed: a person has to review them.

## Power tools mode

Code Armour doesn't try to replace the best free security tools. It **runs them for you** and explains the results in plain words:

| Tool | What it adds |
|---|---|
| [gitleaks](https://github.com/gitleaks/gitleaks) | ~200 kinds of secret keys, across all git history |
| [osv-scanner](https://github.com/google/osv-scanner) | Vulnerable **and malicious** packages in every ecosystem (npm, pnpm, yarn, bun, pip, Go, Rust…) |
| [Semgrep](https://semgrep.dev) CE | Real code analysis (JavaScript, TypeScript, React, Next.js, secrets), with telemetry off |
| [zizmor](https://docs.zizmor.sh) | GitHub Actions attacks (pwn requests, injection, unpinned actions) |

If a tool isn't installed, the scan says how to get it. On a Mac: `brew install gitleaks osv-scanner semgrep zizmor`. If [ripgrep](https://github.com/BurntSushi/ripgrep) is installed, searches run up to 70× faster on big repos.

**Also built in:**
- Live-site checks: HTTPS and certificate expiry, cookies, CORS, ~20 commonly leaked files, source maps, `security.txt`, SPF/DMARC.
- A **Supabase front-door probe** (`scripts/supabase-probe.mjs`). It looks at your project with only the public key, the way an attacker would, and shows which tables anyone can read. It's read-only.

## Commands

| Command | What it does |
|---|---|
| `/armour` | **Run the full check and fix.** The full run above. |
| `/armourcheck` | **Check the armour.** Is it there, do the saved tests still pass, and has anything new been added or gone out of date? Changes nothing unless you ask. |
| `/armourcost` | **What costs tokens.** A read-only table of what your Claude Code setup sends with every message (skills, plugins, MCP servers, CLAUDE.md, memory, agents), biggest first, with what you could turn off and the saving. All figures are estimates. It warns about secrets in your settings by file and line only, and never changes anything without asking. |
| `/armourtest` | **Stress-test the checks.** An AI *legal reviewer* (not a lawyer) reviews your legal pages and a *hacker* agent attacks local copies of your app (never live systems). Their findings are double-checked, and every confirmed one becomes a new saved test. |

You can also just ask: *"is my project safe to launch?"*

## Quick start

```bash
git clone https://github.com/AlonAI4/code-armour.git ~/code-armour
```

**Claude Code**
```bash
ln -s ~/code-armour ~/.claude/skills/code-armour
mkdir -p ~/.claude/commands && for c in armour armourcheck armourtest armourcost; do ln -sfn ~/code-armour/commands/$c.md ~/.claude/commands/$c.md; done
```
Then open your project and type `/armour`.

**Codex**
```bash
ln -s ~/code-armour ~/.codex/skills/code-armour
mkdir -p ~/.codex/prompts && for c in armour armourcheck armourtest armourcost; do ln -sfn ~/code-armour/commands/$c.md ~/.codex/prompts/$c.md; done
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

**Countries (general notes, not legal advice).** More detailed notes for the UK, the EU and the US; shorter notes for 24 more countries; AI-researched notes for 57 more, plus national rules in each of the 27 EU member states and a guide to sanctioned places. Most of the extra notes come from secondary sources and many lines are marked unverified. Last researched October 2026. Laws change, and these notes may be incomplete, out of date or wrong. Check anything you rely on with the regulator or a professional. Other countries: with web search the skill can research them, and marks the results ❓.

**Upcoming laws:** a watchlist of laws with future dates, compared with today on every run.

**Stacks:** Supabase, Firebase, Postgres/Prisma, Convex, PocketBase, Appwrite, MongoDB · Netlify, Vercel, Cloudflare, Firebase Hosting · Next.js, Express · Stripe, Lemon Squeezy, Paddle.

## Tested, not just written

Every recipe is attacked by an automated test suite. [GitHub Actions](https://github.com/AlonAI4/code-armour/actions) is set up to run it on every push (paused right now: Actions is disabled on this account while a GitHub support ticket is open). Run it yourself with `cd tests && npm install && npm test`.

| Suite | Checks | What it proves |
|---|---|---|
| `sql.test.mjs` | 83 | Database recipes on **real Postgres** (PGlite) with Supabase-style roles. Attacks include: reading other users' rows, self-admin, free coins at signup, look-alike swear words, farmed scores, double payouts, double-spending coins, reusing coupons, rate limits. |
| `webhooks.test.mjs` | 31 | Payment and AI endpoints with **real Stripe signatures** and Lemon Squeezy/Paddle HMACs: fake, tampered, replayed and duplicate events rejected; logged-out users refused; daily AI limits hold, CAPTCHAs are really verified (even when Cloudflare is down), cron endpoints need their secret. |
| `scan.test.sh` | 71 | The scanner catches planted leaks, risky GitHub workflows, legal red flags in code (SMS, face AI, crypto, extension manifests…) and the deliberately broken test game, and gives no false alarms on the clean test app or on real patterns that caused false alarms before. |
| `retest.test.sh` | 11 | A fixed game passes its saved re-test. Four typical AI "quick fixes" that undo security each turn it **red**. |
| `firestore.test.mjs` | 12 | Firestore rules in the **real Firebase emulator**. |
| `plain.test.sh` | 5 | Projects with no database: git worktrees, monorepo `npm audit`, the slow-regex detector, the scanner ignoring its own copy. |
| `findings.test.mjs` | 36 | The findings validator: refuses made-up evidence (missing files, fake line numbers), unproven or undisproven findings, hardening notes with no blocking layer, and COMPLIANCE.md rows citing rejected or unknown findings. It also enforces the 4 finding categories: legal findings need a source and a reason, are never ticked ✅, and sensitive topics need professional advice. |
| `cost.test.mjs` | 21 | `/armourcost` with a fake `~/.claude`: ranking, totals, used/unused guesses, free skills, symlinks, plugins on/off, MCP servers, read-only, and fake secrets **never** appear in the output. |
| `probe.test.mjs` | 15 | The Supabase probe against a fake leaky project: it finds every open door, **never writes**, and refuses a secret key. |
| `disclaimer.test.sh` | 23 | The standard disclaimer is in the README, every command, the templates, the scripts' output and the legal references; the old wording is gone; the 4 category labels are used; the MIT licence wording stays. |

### Reviewed and attacked

On 4 Oct 2026, every part was reviewed or attacked by separate AI agents and an automated scanner:

- **A skill test:** a fresh AI agent followed the skill on a game with 30 planted problems. It found almost all of them and fixed them, with tests.
- **An AI legal reviewer (not a lawyer):** corrected cookie, AI Act, accessibility and consumer-law details, and rewrote the privacy template to cover GDPR Art. 13.
- **A hacker agent:** found bypasses in the name filter, profile creation, the scoring and webhook replay. All fixed, all now tested.
- **NVIDIA [SkillSpector](https://github.com/NVIDIA/SkillSpector):** its AI reviewer confirmed one real bug the hacker agent had missed. In Firestore rules v2, `{sub=**}` also matches the profile document itself, so players could make themselves admin. It was reproduced in the emulator, fixed, and is now tested. SkillSpector's AI disagreed with every other high finding.

These are AI and automated reviews, **not** a human lawyer or a professional penetration test.

## What's inside

| Path | What |
|---|---|
| `SKILL.md` | The step-by-step instructions the agent follows |
| `commands/` | `/armour`, `/armourcheck`, `/armourtest`, `/armourcost` |
| `references/` | Security (~120 risks incl. GitHub Actions, AI agents, extensions, MCP), legal (UK/EU/US incl. lawsuit-heavy US laws, app-store rules, EU 2026 product laws), general notes on 83 countries and on national rules in the 27 EU members (researched Oct 2026) + sanctions, stacks, upcoming-laws watchlist (~60 dated items) |
| `recipes/` | Ready-to-adapt fixes: Supabase SQL and Edge Functions, Firebase rules, headers for Netlify, Vercel and Cloudflare, Stripe/Lemon Squeezy/Paddle webhooks, Express, Next.js |
| `scripts/scan.sh` | The scanner: secrets, git history, risky code, GitHub Actions, legal red flags in code, packages, power tools, live-site checks, and whether the project's own armour is set up |
| `scripts/supabase-probe.mjs` | Read-only Supabase front-door probe |
| `scripts/armour-cost.mjs` | Read-only token-cost report for `/armourcost` |
| `scripts/validate-findings.mjs` | Checks findings and the coverage ledger |
| `templates/` | `COMPLIANCE.md`, a plain-words privacy policy, the re-test kit, lawyer and hacker briefs, the country research template |
| `tests/` | The suites above, plus the broken and fixed test games |

## Stay safe

- **Never install a skill, plugin or repo from a link someone DMs you.** Fake copies of real repos are a common malware trick. Find it yourself, then check the owner (here: `AlonAI4`), the stars, the licence and the recent commits before installing.
- Read a skill's scripts before enabling it, or scan it with NVIDIA [SkillSpector](https://github.com/NVIDIA/SkillSpector). Skills can run code on your computer.
- Pin what you install to a version, and update on purpose, not automatically.

## Honest limits

- Laws change. Some country details are marked "unverified", and every reference file shows its research date (October 2026).
- The scanner finds known patterns. A clean scan isn't proof of safety, which is why the attack tests exist.
- Recipes need adapting to your app. The two Supabase Edge Functions are type-checked but not run in the suite, because they need a live Supabase project.
- The name filter can't catch everything (for example, random characters standing in for letters). Keep a report button.
- Findings may be wrong in either direction: missed problems, or false alarms.
- Legal notes are general information: whether a law applies to you depends on facts the skill can't check.
- Most enforcement risk depends on scale. Severity labels mean "how likely is trouble for a small app", **not** "does the law apply".

## Going deeper

Code Armour is for beginners and gives general information on laws as well as security checks. It fixes what it finds and keeps re-testing. **For a deep expert audit, also run Cloudflare's [security-audit skill](https://github.com/cloudflare/security-audit-skill).** It sends every finding to fresh agents that try to disprove it, and Code Armour's verdicts and coverage ledger borrow that idea. Their key result: one run finds only about half of what repeated runs find, so run checks again after big changes.

## Contributing

Pull requests are welcome, especially:
- new countries in `references/countries-extra/` (use `templates/country-research.md`);
- new recipes, **with a test that attacks them**;
- corrections with a source link.

## Disclaimer and limitation of liability

In short: Code Armour provides automated technical checks and general compliance information. It does not provide legal advice, certify compliance, guarantee security or identify every possible risk. Results may be incomplete or incorrect. Users remain responsible for testing their websites, reviewing applicable requirements and obtaining professional advice where appropriate.

By using Code Armour you agree to the following. It applies on top of the [MIT licence](LICENSE), which also says the software comes "as is", without warranty.

1. **No warranty.** Code Armour (the skill, scripts, recipes, templates, references and commands) is provided "as is" and "as available", without warranty of any kind, express or implied. That includes warranties of accuracy, completeness, merchantability, fitness for a particular purpose and non-infringement.
2. **Not legal or professional advice.** It's general information produced with the help of AI. It isn't legal advice, a security audit, a penetration test or a compliance certification. Using it creates no lawyer–client, consultant or other professional relationship. Laws differ by country and change often, and some content is marked unverified. For anything that matters, ask a qualified lawyer or security professional.
3. **No guarantee of results.** It can miss problems, report problems that aren't real, and suggest changes that are wrong for your project. A clean result doesn't mean your project is secure, legal or compliant.
4. **Your responsibility.** You're solely responsible for your project, for reviewing and testing every change before you use it, for backups, and for following the laws that apply to you. Only test systems you own or have permission to test.
5. **Limitation of liability.** To the fullest extent permitted by applicable law, the authors and contributors aren't liable for any claim, loss or damage of any kind arising from or connected with Code Armour or its use. That covers direct, indirect, incidental, special, consequential or punitive damages, security breaches, data loss, lost profits, fines, penalties and legal costs, even if they were told such loss was possible.
6. **Where the law doesn't allow this.** Some places don't allow certain warranties or liabilities to be excluded. There, they're excluded or limited only as far as the law allows. Nothing here excludes liability that can't legally be excluded, such as for fraud, or for death or personal injury caused by negligence.
7. **Third-party tools and links.** Code Armour can run or point to tools and services made by others (for example gitleaks, osv-scanner, Semgrep, zizmor, Supabase, Stripe, Cloudflare). Their makers are responsible for them, under their own terms.

## About

Built by Alon with Claude Code, October 2026. MIT licensed.
