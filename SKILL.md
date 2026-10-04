---
name: code-armour
description: Pre-launch check to lower the risk of getting hacked or sued, for web apps, games, AI apps and stores by solo or beginner devs, on any stack (Supabase, Firebase, Next.js, Netlify, Vercel, Stripe...). Use when asked if a project is safe, secure, legal or ready to launch, or about leaked keys, RLS, privacy policy, GDPR, COPPA, kids, cookies, VAT, loot boxes or AI labels. Scans the code, fixes with tested recipes, proves each fix, writes COMPLIANCE.md. A checklist, not legal advice.
---

# Code Armour

You are helping someone (often a beginner, sometimes a teenager) make their project safe from hackers, surprise bills and legal trouble before launch. Work through the steps below in order. Explain everything in plain words: define any technical term in one sentence the first time you use it.

All paths below are relative to this skill's folder.

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
| A country not listed | Say so plainly. Apply the general rules (privacy notice, consent, delete-my-data, breach plan, kids' consent, tax via a Merchant of Record) and mark it ❓ |

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
2. Check the data rules for the stack. Also check: a profile row is created at signup (`recipes/supabase/new-user-profile.sql`), every table linked to users deletes with them (`on delete cascade`), and the banned-word list isn't empty (an empty list means the swear filter is OFF).
    (see `references/stacks.md` §1). Firebase: read `firestore.rules` / `storage.rules`, try the Rules Playground. Postgres/Prisma/Drizzle, Convex, Express: read every route or function and confirm it filters by the verified user. PocketBase/Appwrite: check each collection's rules in the admin UI. If Supabase is used, run `recipes/supabase/audit.sql` through whatever you have: the Supabase MCP `execute_sql` tool, the `supabase` CLI, or ask the user to paste it into the SQL Editor and share the output. Also open (or ask for) **Advisors → Security** and explain every warning in plain words.
3. Go through each applicable item in the references and check it against the code.

## Step 4: Fix

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

## Step 6: Write COMPLIANCE.md

Copy `templates/COMPLIANCE.md` into the project root and fill it in:

- ✅ done (with evidence);
- ❌ not done (with how to fix);
- ➖ doesn't apply (with why);
- ❓ needs checking (with what to check).

Date it. Keep it updated on later runs instead of starting over.

## Step 7: Report

End with a short, honest summary:

1. The biggest risks found, worst first.
2. What you fixed and proved.
3. What the user must do themselves (accounts, dashboards, parent sign-ups, a lawyer for anything serious).

Don't call the project "secure", "legal" or "compliant". Severity labels mean how likely enforcement is for a small project, not whether the law applies. Say what was checked and what wasn't.
