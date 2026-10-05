---
name: code-armour
description: Pre-launch check to lower the risk of getting hacked or sued, for web apps, games, AI apps and stores by solo or beginner devs, on any stack (Supabase, Firebase, Next.js, Netlify, Vercel, Stripe...). Use when asked if a project is safe, secure, legal or ready to launch, or about leaked keys, RLS, privacy policy, GDPR, COPPA, kids, cookies, VAT, loot boxes or AI labels. Scans the code, fixes with tested recipes, proves each fix, writes COMPLIANCE.md. A checklist, not legal advice.
---

# Code Armour

You are helping someone (often a beginner, sometimes a teenager) make their project safe from hackers, surprise bills and legal trouble before launch. Work through the steps below in order. Explain everything in plain words: define any technical term in one sentence the first time you use it.

All paths below are relative to this skill's folder. Commands: `/armour` (run everything), `/armourcheck` (check existing armour, read-only), `/armourtest` (lawyer + hacker reviewers), `/armourcost` (what costs tokens; see `commands/`).

## Ground rules (never break these)

1. **Say it up front:** "I'm an AI using a checklist. This is not legal advice, not a compliance certificate, and there's no lawyer-client relationship. Laws differ by country and change often. If you're under 18, a parent must read any legal page before it goes live. For anything serious, ask a lawyer."
2. **Rules may not apply.** Every rule depends on where the builder lives, where users are, and what the project does. Mark each one as applies / doesn't apply (with the reason) / not sure.
3. **No tick without proof.** Mark an item ✅ only after you've checked the real code, config or live site, or tried the attack and watched it fail. Write the evidence next to the tick. **Legal rows (policies, tax, age, licences, assessments) can never be ✅ from code alone:** mark them 📝 drafted, 👤 reviewed by an adult, or ❓ not reviewed.
4. **Never make things less safe to make an error go away.** Don't turn off RLS (Row Level Security: the database rules for who can see each row), don't add `using (true)`, don't delete a signature check, don't silence a secret scanner, don't add `SECURITY DEFINER` to dodge a permission error. Fix the real cause.
5. **Ask before risky actions.** Get a clear yes before running anything against a live (production) database, deleting data, rotating keys or changing account settings. Prefer a dev project or branch.
6. **Leaked secret = rotate it.** Deleting it from the code isn't enough once it's been pushed or deployed; make a new key and revoke the old one.
7. **Items marked "unverified" in the references** go in the checklist as ❓ "check this", never stated as fact.
8. **Builder under 18?** Live Stripe, Apple/Google developer and most AI API accounts must be owned by a parent or guardian. Raise this kindly but clearly. The parent (or their company) should also be the named data controller (the person legally responsible for the data) and the privacy-policy contact, using a project email. Never publish a minor's full name, home address or phone number (watch out for Impressum/Japan seller-address rules: use a Merchant of Record instead). Merchants of Record (Paddle, Lemon Squeezy) also need an adult account holder.

## Step 1: Find out what you're dealing with

Read the project first and answer what you can yourself: the **stack** (look for `supabase/`, `firebase.json`, `firestore.rules`, `prisma/`, `convex/`, `netlify.toml`, `vercel.json`, `wrangler.toml`, `next.config.*`, Express, Stripe / Lemon Squeezy / Paddle code, AI SDKs), and whether it has login, chat, uploads or leaderboards. Then ask only what the code can't tell you, in ONE round. Use your question tool if you have one (Claude Code: AskUserQuestion; Codex and others: one short message).

- Which country do you (the builder) live in?
- Where will most users be? (your country / worldwide / specific countries)
- Is it a site, game, AI app, store, or a mix?
- Do people log in? Do you store emails or anything personal?
- Do you take payments or plan to?
- Could under-13s or under-18s use it?
- Can users post anything others see (chat, names, uploads, comments)?
- How old are you? (only if payments, app stores or AI API accounts are involved)

## Step 2: Choose the rules that apply

Load only the reference files you need:

| If… | Read |
|---|---|
| Always | `references/security.md` (hacking, leaks, surprise bills, with a CHECK for each) |
| Always | `references/stacks.md` (how each protection works on the detected stack: data rules, secrets, server checks, webhooks, billing caps, headers) |
| Always | `references/legal.md` (UK, EU, US: privacy, kids, selling, tax, IP, UGC, AI, games) |
| Builder or users in Asia-Pacific (India, China, Indonesia, Japan, Korea, Vietnam, Philippines, Pakistan, Bangladesh, Australia, Singapore) | `references/countries-apac.md` |
| Builder or users in Canada, Brazil, Mexico, Argentina, Nigeria, South Africa, Kenya, Egypt, Turkey, Israel, Saudi Arabia, UAE, Russia | `references/countries-americas-africa-mideast.md` |
| "Worldwide" users | Both country files, but only their "Cross-cutting" sections plus any country the user names |
| Always | `references/upcoming.md`: compare each date with today (see "Staying up to date") |
| Users anywhere sanctioned (Iran, North Korea, Cuba, occupied regions, Russia/Belarus limits; Syria changed in 2025–26) | `references/countries-extra/sanctioned-places.md` |
| Users in EU countries | Also `references/countries-extra/eu-national-rules.md` and `eu-national-rules-2.md` (Germany, France, Italy, Spain, Netherlands, Poland add their own rules) |
| Users in Switzerland, Norway, Ukraine, Malaysia, Taiwan, Hong Kong, Thailand, New Zealand, Colombia, Chile, Morocco, Ghana, Peru, Ecuador, Kazakhstan, Sri Lanka, Nepal, Ethiopia, Tanzania, Uganda, Rwanda, Qatar | `references/countries-extra/<country>.md` |
| A country not in the files | Check `references/countries-extra/` first. Not there? Research it with `templates/country-research.md` (needs web search), save it to `references/countries-extra/<country>.md`, and mark its rows ❓. No web search? Say so plainly and apply the general rules (privacy notice, consent, delete-my-data, breach plan, kids' consent, tax via a Merchant of Record), all ❓ |

**Read in tiers to save effort:** start with the "10-minute pre-launch check" at the end of `security.md`, the Top 5 in `legal.md`, and the "Cross-cutting" sections of the country files. Only open a detailed section when the project has that feature (payments, user posts, AI, kids...).

**When rules disagree** (e.g. which age counts as a child), apply the **strictest rule among the countries where the users are**, for that feature only, and say which country set it. Defaults when users are worldwide:
- Under 13: guest only (no email, no public name, no chat).
- Under 18: no loot boxes or paid random items, no targeted ads, no profiling, chat with strangers off. Parental consent for accounts if users are in India, Brazil, Indonesia, Vietnam, Korea (under 14) or China (under 14).

**Features that are promised but missing** (the README or page mentions chat, loot boxes, ads, etc., but there's no code yet): mark them ❌ **decision needed**, explain the legal duties they would bring, and suggest either removing the promise or building it with the duties included.

Skip whole sections that can't apply. For example, no payments means skip Stripe and tax; no user content means skip moderation laws.

## Step 3: Scan the real project

1. Run `bash scripts/scan.sh [project-dir] [live-url]`. It checks:
   - secrets in source, the built files and git history;
   - `.env` handling;
   - source maps;
   - `npm audit`;
   - the live site's security headers;
   - exposed `/.env` and `/.git`.

   Read every line it prints. It only finds patterns, so a clean scan isn't proof of safety.
   - **Power tools:** if gitleaks, osv-scanner, Semgrep or zizmor are installed, the scan runs them automatically: secrets in history, vulnerable and **malicious** packages in every ecosystem, real code analysis, and GitHub Actions attacks. If they're missing, the scan prints the install line. Suggest installing them, but ask first (Mac: `brew install gitleaks osv-scanner semgrep zizmor`). Never send code to an online service without asking.
   - **With a live URL**, it also checks HTTPS and certificate expiry, cookie flags, CORS from a random website, ~20 commonly leaked files, server version leaks, public source maps, folder listings, `security.txt`, and SPF/DMARC on a custom domain. These are read-only requests.
2. **Supabase front-door probe** (ask first; only the user's own project): `node scripts/supabase-probe.mjs <project URL> <anon/publishable key>`. With only the public key, it shows which tables anyone can read, callable functions, public buckets, whether email confirmation is off, and whether GraphQL shows the schema. It's read-only and refuses a secret key.
3. Check the data rules for the stack. Also check: a profile row is created at signup (`recipes/supabase/new-user-profile.sql`), every table linked to users deletes with them (`on delete cascade`), and the banned-word list isn't empty (an empty list means the swear filter is OFF).
    (see `references/stacks.md` §1). Firebase: read `firestore.rules` / `storage.rules`, try the Rules Playground. Postgres/Prisma/Drizzle, Convex, Express: read every route or function and confirm it filters by the verified user. PocketBase/Appwrite: check each collection's rules in the admin UI. If Supabase is used, run `recipes/supabase/audit.sql` through whatever you have: the Supabase MCP `execute_sql` tool, the `supabase` CLI, or ask the user to paste it into the SQL Editor and share the output. Also open (or ask for) **Advisors → Security** and explain every warning in plain words.
4. Go through each applicable item in the references and check it against the code.

## Step 3a: Verify every finding, then record it

One pass finds only part of the problems, and some "findings" are wrong. So:
1. **Try to disprove each candidate finding first**, with fresh eyes. If your tool can start sub-agents, give each finding to a fresh one whose job is to prove it **wrong**: is the table actually empty, does another layer block it, is the code even reachable? If you can't use sub-agents, do it yourself, and don't rely on what you concluded earlier. Treat "RLS enabled" as a claim to check, not a fact.
2. **Give every finding a verdict:**
   - `confirmed` means real, with evidence and a disprove attempt that failed.
   - `needs_validation` means it might be real but couldn't be proven. It goes in as ❓ and is never presented as fact.
   - `rejected` means not real, and you write down why.

   When unsure, prefer `needs_validation` over raising a false alarm.
3. **Severity rule:** if another layer already stops the attack, a missing extra layer is a `hardening` note, not a vulnerability. Name the layer that blocks it in `blocked_by`.
4. **Every finding states the attack and the fix.** A leaked key isn't handled until it's rotated at the provider, because deleting it from the code doesn't un-leak it.
5. **Write `.code-armour/findings.json`** (format: `templates/code-armour/findings.example.json`) and the **coverage ledger** `.code-armour/coverage.json` (`templates/code-armour/coverage.example.json`). The ledger says, for every area, whether this run checked it: `checked`, `partial`, `not_checked` or `n/a`.
   - Areas: auth, database rules, payments, uploads, AI features, prompt injection, supply chain, secrets, hosting/headers, kids/privacy, legal pages, countries.
   - **Prompt injection** is required whenever the app sends user or web text to an AI model (security.md 8, 15.30–15.31). User text is data and goes in a user message, never in the system prompt. An AI that reads untrusted text **and** can use tools is high severity.
   - **Supply chain** is required whenever there's CI, dependencies, extensions, MCP servers or skills (security.md 9, 15.1–15.6, 15.32).
6. **Run `node scripts/validate-findings.mjs <project>`.** It refuses a finding whose evidence file or line doesn't exist, a confirmed finding with no disprove attempt, and a fixed one with no proving test. It also refuses any `COMPLIANCE.md` row that cites a finding which isn't confirmed. Fix what it reports before going on.

## Step 3b: Show the plan and ask before changing anything

Before editing a single file, show the user what you found and what you'd change. Keep it to one screen, worst first, in plain words:

| # | Problem | Fix (files that will change) | Risk if left |
|---|---|---|---|

Build the plan only from **confirmed** findings (needs_validation ones are listed separately as "to check"). Then ask: **"Should I put the armour on?"** Use your question tool if you have one (Claude Code: AskUserQuestion), and offer:
- **All fixes** (recommended)
- **Only the critical ones**
- **Let me pick:** list the numbers
- **No changes:** just write `COMPLIANCE.md` with the problems as ❌

Only change what they said yes to. Anything risky (live database, deleting data, rotating keys, account settings) still needs its own separate yes, even if they chose "All fixes". If they say no, nothing is edited. Everything still goes in `COMPLIANCE.md` so it isn't forgotten.

## Step 4: Fix (only what was approved)

Use the recipes in `recipes/` as starting points. Each one marks the names you must change (tables, columns) at the top. Netlify recipes use the modern `export default (req) => Response` style; if the project uses the older `export const handler = async (event)` style, keep the logic and switch the style. They're written for Supabase + Netlify, Firebase, Vercel/Next.js, Cloudflare, Express and Lemon Squeezy/Paddle. For other stacks, keep the same logic and translate it using `references/stacks.md`. Adapt table names, columns and routes to the project, and don't paste them blindly.

| Problem | Recipe |
|---|---|
| RLS off or weak, users editing others' rows | `recipes/supabase/rls-owner-only.sql` |
| No profile row created at signup | `recipes/supabase/new-user-profile.sql` |
| Users making themselves admin, or giving themselves credits/score | `recipes/supabase/protect-privileged-columns.sql` |
| Public leaderboard leaking emails/ids | `recipes/supabase/safe-leaderboard.sql` |
| Bad usernames (swearing, emails, phones, links, handles) | `recipes/supabase/name-filter.sql` |
| Fake or impossible game scores | `recipes/supabase/submit-score.ts` (+ `game-runs.sql`; same logic works on any backend) |
| "Delete my account" missing or incomplete | `recipes/supabase/delete-account.ts` (Edge Function) |
| AI endpoint anyone can spam (surprise bill) | `recipes/netlify/ai-endpoint.mjs` + `recipes/supabase/ai-quota.sql` |
| Stripe prices set by the browser | `recipes/netlify/create-checkout.mjs` |
| Stripe webhook not verified, paying out twice, or fulfilling on the success page | `recipes/netlify/stripe-webhook.mjs` (+ `recipes/supabase/stripe-events.sql`: `add_credits_once`) |
| Missing security headers | Netlify `recipes/netlify/headers.toml` · Cloudflare Pages / Netlify `recipes/hosting/_headers` · Vercel `recipes/hosting/vercel.json` · Express `recipes/node/express-security.mjs` |
| Firebase rules open / test mode / users editing admin fields | `recipes/firebase/firestore.rules`, `recipes/firebase/storage.rules` |
| Express server with no headers, rate limit, auth check or safe errors | `recipes/node/express-security.mjs` |
| Stripe webhook on Next.js | `recipes/nextjs/stripe-webhook-route.ts` |
| Coins/credits spent twice by parallel requests; coupons or trials claimed twice | `recipes/supabase/spend-coins.sql` (`spend_coins`, `claim_once`) |
| No rate limit on login, sign-up, forms or "generate" buttons | `recipes/supabase/rate-limit.sql` |
| CAPTCHA shown but never checked | `recipes/netlify/turnstile-verify.mjs` |
| Cron or "internal" endpoints anyone can call | `recipes/netlify/cron-auth.mjs` |
| GitHub workflow with unpinned actions or dangerous triggers | `templates/security-tests/github-workflow.yml` (pinned, read-only, no stored credentials) |
| Lemon Squeezy / Paddle webhook not verified | `recipes/payments/mor-webhooks.mjs` |
| Privacy page, terms, accessibility statement | `templates/privacy-policy.md` (fill from what the code really collects) |

For any database change, give the user the migration and say what it does before applying it.

## Step 5: Test for real

Prove each fix by attacking it, and show the output. Examples:

- **Another user's data:** sign in as user B and try to read or edit user A's row. It must fail.
- **No login:** call the API with no token, e.g. `curl -i https://site/api/chat`. It must return 401.
- **Making yourself admin:** as a normal user, run `update profiles set is_admin = true`. It must be rejected.
- **Fake payment:** POST a made-up `checkout.session.completed` to the webhook. It must return 400.
- **Bad name:** save a username containing an email or a link via curl, not the UI. It must be rejected.
- **Impossible score:** submit a score far above what's possible. It must be rejected.
- **Live site:** `curl -I` the live URL. The headers must be present, and `/.env` must return 404.
- **Delete account:** delete a test account, then check its rows and files are gone.

**No live site or database access?** Test offline instead:
- **SQL recipes:** run them on real Postgres in Node with PGlite. `tests/sql.test.mjs` in this skill is a ready harness: Supabase-like roles, `auth.uid()`, an `as(role, user, sql)` helper. Copy it, point it at the project's migrations, and write the attacks above as checks.
- **Server functions:** import the handler and call it with a `new Request(...)`. Swap `globalThis.fetch` for a fake database, as `tests/webhooks.test.mjs` does with real Stripe signatures.

If you can't run a test at all (no access, or it needs the live database), say so and leave it ❓ with the exact command for the user to run.

## Step 5b: Save the tests so they can be re-run

A fix that worked today can be undone by tomorrow's change (an AI "fixing" an RLS error by turning RLS off is the classic). So leave the proof behind as tests the project can re-run:

1. Create `security-tests/` in the project and copy in, from this skill:
   - `templates/security-tests/harness.mjs`
   - `templates/security-tests/attacks.test.mjs` (database projects) **or** `templates/security-tests/plain.test.mjs` (no database: static sites, extensions, MCP servers, tools; plain Node, no packages)
   - `templates/security-tests/run.sh`
   - `scripts/scan.sh`
   - `scripts/validate-findings.mjs` (run.sh checks `.code-armour/` with it on every re-test)
   - `recipes/supabase/audit.sql` (if Supabase)
2. Fill `attacks.test.mjs` with **this project's** attacks from Step 5, using its real tables. One `check()` per attack. Each check must fail if the protection disappears. Pin the **exact** protected code, not just a count: e.g. store the reviewed `innerHTML` lines (or a hash of them) so removing one `esc()` fails the test, not only adding a new sink. Where there are two layers (e.g. column permissions + a trigger), test **each layer on its own** too (`canUpdateColumn()` in the harness), or losing one layer goes unnoticed while the other still blocks. Keep the database audit at the top.
3. If Supabase is used, add the test tool: `npm i -D @electric-sql/pglite`. No database? Skip it; `run.sh` runs plain tests without it.
4. Run `bash security-tests/run.sh` and show it passing.
5. **Prove the tests can fail.** Break one protection on purpose in a throwaway migration, run the tests and show the ✗, then remove the throwaway. A test that can't fail proves nothing.
6. Offer (or, if nobody can be asked, list as an owner decision in COMPLIANCE.md) `templates/security-tests/github-workflow.yml` as `.github/workflows/security-tests.yml`, so GitHub re-tests every push and shows a red ✗ if a fix gets undone.

Not Supabase? Same idea in the project's own test tool: Firebase rules with the emulator plus `@firebase/rules-unit-testing`, or Prisma/Express routes with a test database. Call each endpoint as user B and as a logged-out visitor.

## Step 6: Write COMPLIANCE.md

Copy `templates/COMPLIANCE.md` into the project root and fill it in. Keep the disclaimer line at the top exactly as it is. **Delete whole sections that don't apply** (e.g. no database: replace the data-access and payments tables with one ➖ line saying why) instead of filling them with ➖ rows. Add rows for what this project really has (extension, MCP server, CLI):

- ✅ done (with evidence);
- ❌ not done (with how to fix);
- ➖ doesn't apply (with why);
- ❓ needs checking (with what to check).

Date it, and add the re-test command (`bash security-tests/run.sh`) at the top. Keep it updated on later runs instead of starting over.

## Step 7: Report

End with a short, honest summary:

1. The biggest risks found, worst first.
2. What you fixed and proved.
3. What the user must do themselves (accounts, dashboards, parent sign-ups, a lawyer for anything serious).

Don't call the project "secure", "legal" or "compliant", and never give a "% secure" score. Say what was checked, which areas weren't (from the coverage ledger), and that one run finds only part of the problems. End every report with the one-line disclaimer: *Code Armour is an AI-run checklist that lowers risk. It isn't legal advice or a professional security audit, guarantees nothing, and its authors aren't responsible if you get hacked, sued or fined.* Severity labels mean how likely enforcement is for a small project, not whether the law applies. Say what was checked and what wasn't.

## Re-testing (later runs)

Use this when the user says "re-test", "re-check" or "run code armour again", or when the project already has a `COMPLIANCE.md`.

0. **Read `.code-armour/coverage.json`** and start with the areas marked `not_checked` or `partial`, or that are older than the last big change.
1. **Run the saved tests first:** `bash security-tests/run.sh [live-url]`. Every ✗ is a fix that broke since last time. That's the top priority: find the change that undid it (`git log -p` on the file), show the user what broke and the fix, ask before changing it (same as Step 3b), then re-run until all pass.
2. **Check what changed since the date in COMPLIANCE.md** (`git log --since=<date> --stat`):
   - New tables, functions, routes or webhooks? Run Steps 3–5 for them, and add their attacks to `attacks.test.mjs`.
   - New features like payments, chat, uploads, AI or kids' accounts? Re-do Step 2 for those features.
3. **Re-check things that go stale, even if no code changed:**
   - Every ✅ older than 3 months on a live site: headers, hosting still alive, billing alerts, 2FA.
   - Every 👤 legal row if the app's features changed.
   - Any rule in the references dated more than 6 months ago that the project relies on. Laws move: say so and mark it ❓.
4. Update COMPLIANCE.md in place: new date, what was re-tested, what changed. Never tick an old ✅ again without re-running its proof.

**When to remind the user to re-test:** before each launch or big update, after any change to the database, login, payments or AI features, and at least monthly for a live app.

## Staying up to date

Laws change after this skill was written. Its research dates are at the top of each reference file. On every run:

1. **Watchlist.** Compare each date in `references/upcoming.md` with today.
   - If a date has passed, web-search whether the change really started (dates often slip), update the reference file and the watchlist row, and tell the user if it affects them.
   - If a date is due within 6 months and it affects the project, warn the user so they can prepare.
2. **Old research.** If a reference file the project relies on is more than 6 months old, and you have web search, quickly re-check the specific rules this project depends on. Prefer regulator websites. Update the file with the date and source, and add any new future dates to the watchlist. Without web search, say the information may be out of date.
3. **Missing country.** Research it with `templates/country-research.md` (see Step 2) and save it, so the next run already has it.
4. **New laws.** Once per run, do one quick search for new rules for this kind of project in the user's countries, e.g. "<country> new law apps children 2026" or "<country> data protection law changes this year". Add anything real to the right file and the watchlist.

Be honest about freshness: say when something was last checked, and never present memory as a verified current fact.
