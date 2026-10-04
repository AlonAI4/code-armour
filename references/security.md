# Security: how vibe-coded projects get hacked (Netlify + Supabase + Stripe + GitHub)

Researched 2026-10-04. Key: S site, G game, A AI app, $ store. Severity Crit/High/Med/Low.
[V] = checked against a source. [GK] = standard practice, not fetched. Re-verify anything marked unverified.

## Real incidents
- Lovable CVE-2025-48757: 170+ apps with missing/weak Supabase RLS, anyone could read/write tables with the anon key. https://www.sentinelone.com/vulnerability-database/cve-2025-48757/
- Moltbook (Feb 2026): Supabase key in client JS, no RLS: ~30k emails, ~1.5M API tokens exposed. https://www.wiz.io/blog//exposed-moltbook-database-reveals-millions-of-api-keys
- Tea app (Jul 2025): public storage bucket, ~13k ID selfies + 1.1M DMs leaked.
- EnrichLead (Mar 2025): keys in frontend, no auth, no rate limit, paywall hidden by CSS. Dead in a week.
- Replit agent (Jul 2025): AI agent deleted a production DB during a code freeze.
- Netlify $104,500 bill from a DDoS on one file (waived).
- Stolen Gemini key: $82k in ~24h (Feb 2026).
- GitGuardian 2026: Claude Code co-authored commits leaked secrets at 3.2% vs 1.5% baseline.

## 1. Secrets & keys
1.1 Secret key in frontend bundle [V] (all, Crit). AI calls OpenAI/Stripe/Supabase-admin from the browser, or adds VITE_/NEXT_PUBLIC_ to secrets. Fix: secrets only in Netlify/Supabase Edge Functions. CHECK: after build `grep -rEi "sk-|sk_live|sk_test|sb_secret_|service_role|AIza|ghp_|xox" dist/ .next/static build/`; grep source for `VITE_.*(SECRET|SERVICE|KEY)`, `NEXT_PUBLIC_.*(SECRET|SERVICE)`.
1.2 .env committed / secrets in git history [V] (all, Crit). Fix: `.env*` in .gitignore before first commit; GitHub secret scanning + push protection. CHECK: `gitleaks detect` or `git log --all -p | grep -Ei "sk_live|service_role|sb_secret|api_key"`. If found: ROTATE the key; deleting doesn't help.
1.3 Repo made public with secrets in history (all, Crit). Run 1.2 before going public.
1.4 "Harmless" key gains powers (e.g. Maps key + Gemini) [V] (S/A, High). Restrict keys by API + referrer, budget alerts.
1.5 Users paste their own keys into your app [V] (A, High). Encrypt (Supabase Vault), never return to client.

## 2. Supabase data access (#1 vibe-coder breach)
2.1 RLS disabled [V] (all, Crit). AI "fixes" RLS errors by turning RLS off. CHECK: Advisors → Security, or `select tablename from pg_tables where schemaname='public' and not rowsecurity;` = 0 rows.
2.2 Fake policies: `using (true)` on private data, or writes `to anon` (all, Crit). An UPDATE policy without `with check` is NOT a hole: Postgres reuses `using` as the check (tested). CHECK: `select tablename, policyname, roles, cmd, qual, with_check from pg_policies where schemaname='public';` Owner rows: `(select auth.uid()) = user_id`. Test with curl: logged out, and as user B reading user A.
2.3 Policies trusting `user_metadata` (users can edit it → become admin) [V] (all, Crit). Use app_metadata or a server-written roles table.
2.4 Views / SECURITY DEFINER functions bypass RLS [V] (all, Crit). `alter view x set (security_invoker = on)`; advisor lint 0010.
2.5 Column leaks: RLS is per row, a public profiles table exposes email, stripe_customer_id, is_admin (all, High). Split private columns or use column grants.
2.6 Users update own privileged fields: credits, is_pro, role, score (G/A/$, Crit). Block with trigger/column grants; change only from server.
2.7 Public/permissive storage buckets (all with uploads, Crit). Private buckets + signed URLs; policy `(storage.foldername(name))[1] = auth.uid()::text`.
2.8 Edge Function `verify_jwt = false` or service-role client without checking caller (all, Crit).
2.9 Public RPC functions callable by anyone (EXECUTE granted to PUBLIC by default) [V] (all, High). `revoke execute ... from anon, public`.

## 3. Auth & access control
3.1 IDOR: change ?order=124 → 125 and see someone else's (all, Crit). Compare every id to the verified caller.
3.2 Client-only gating: paywall/admin/pro only in React or CSS [V] (all, Crit). Test with curl, no UI.
3.3 Unprotected /admin routes (all, Crit). Server-side role check.
3.4 Trusting unverified JWTs / body.userId (all, Crit). Use `supabase.auth.getUser()` or `getClaims()`, not `jwt.decode`/`getSession()` on server.
3.5 Email confirmation off → sign up as someone else (all, High). Auth → Email → Confirm email ON.
3.6 Wildcard redirect URLs (e.g. *.netlify.app) leak login tokens (all, High). Exact domains only.
3.7 No 2FA on the dev's own GitHub/Netlify/Supabase/Stripe/npm/registrar (all, Crit).
3.8 Anonymous sign-ins make "authenticated" policies public (G/A, Med).

## 4. Injection & browser attacks
4.1 XSS via innerHTML, dangerouslySetInnerHTML, v-html, document.write, AI/markdown output as HTML, `javascript:` hrefs (all, High). Use textContent or DOMPurify.
4.2 SQL injection: template-string SQL, `execute '...' || input`, user strings in `.or()`/`.filter()` (all, High).
4.3 CSRF with cookie sessions (S/$, Med). POST-only, SameSite=Lax, check Origin.
4.4 SSRF: "fetch this URL"/link previews/AI browsing (A/S, High). Allowlist, block private IPs.
4.5 Open redirect `?next=https://evil.com` (all, Med). Relative paths only.
4.6 Insecure uploads: SVG/HTML = stored XSS, no size limit, EXIF GPS (all, High). allowed_mime_types, file_size_limit, strip EXIF.
4.7 Mass assignment: `.update(req.body)` lets users set role/price/user_id (all, High). Pick fields explicitly.

## 5. Payments (Stripe)
5.1 Webhook signature not verified [V] (Crit). `stripe.webhooks.constructEvent(rawBody, sig, whsec)`. Test: fake POST must get 400.
5.2 Client-supplied price/amount/quantity (Crit). Server uses stored Price IDs; reject weird quantities.
5.3 Fulfilling on the success URL instead of the webhook [V] (Crit).
5.4 No idempotency: retried events grant twice (Med). Unique `event.id`.
5.5 Card testing by bots [V] (High). Stripe Checkout/Payment Element, CAPTCHA, rate limits.
5.6 Full secret key where a restricted key would do (Med).

## 6. Abuse, bots & surprise bills
6.1 AI endpoint with no auth / no per-user quota (A, Crit $$). Login + daily cap in DB, cap max_tokens & input length, provider hard spend limit. CHECK: curl with no token → 401.
6.2 Hosting overage (all, High). Netlify credits plans; keep auto-recharge off. Verify https://docs.netlify.com/pricing.
6.3 Supabase overage (all, Med). Spend cap on.
6.4 Bot signups, email bombing, SMS pumping [V] (all, High). CAPTCHA in Supabase Auth, rate limits, custom SMTP, avoid SMS.
6.5 No rate limits on own functions: contact forms, leaderboards, generate buttons (all, Med).
6.6 Runaway loops: useEffect without deps, self-triggering webhooks (all, Med). Watch usage graphs after launch.

## 7. Games
7.1 Client-authoritative scores / leaderboard tampering (G, Med; High with prizes). Submit via Edge Function: plausible score/sec, server session tokens, block direct inserts.
7.2 Coins/items in localStorage or client-writable column (G/$, High).
7.3 Usernames/chat: XSS, offensive names, impersonation (G, Med). Length limits, filter, report button.
7.4 Realtime channels with no authorization: players spoof others (G, Med). Private channels.

## 8. AI apps (OWASP LLM Top 10 2025)
8.1 Prompt injection (A, High). Can't fully fix; limit what the model can do, treat output as untrusted.
8.2 Model output used as HTML/SQL/code/URL (A, High). Sanitize, never eval.
8.3 System prompt leakage (A, Med). Assume it leaks: no keys, internal URLs or secret rules in it.
8.4 Excessive agency: tools run as admin (A, Crit). Tools run as the calling user, read-only by default, human confirm writes.
8.5 Sensitive info disclosure / RAG returns other users' docs (A, High). Filter vectors by user_id with RLS.

## 9. Supply chain
9.1 Slopsquatting: AI invents package names, attackers register them (~20% of suggested packages didn't exist) [V] (all, High). Check every new package on npmjs.com (age, downloads, repo).
9.2 Malicious postinstall worms (Shai-Hulud 2025) [V] (all, High). Commit lockfile, `npm ci`, pin versions, consider ignore-scripts, no long-lived tokens in ~/.npmrc.
9.3 Typosquats & outdated deps (all, Med). `npm audit`, Dependabot.
9.4 Third-party scripts from random CDNs without SRI (S/G, Med).
9.5 Untrusted MCP servers, extensions, Claude skills read your keys (all, High).

## 10. AI agents with too much power [V] (all, Crit)
Agent has prod DB, service-role keys, force-push, rm -rf, db reset. Fix: separate dev/prod Supabase, MCP read-only and scoped to dev, never auto-approve destructive commands, protect main branch, backups. CHECK: read .mcp.json / connector config.

## 11. Config & infrastructure
11.1 Missing security headers: CSP, frame-ancestors, X-Content-Type-Options, Referrer-Policy, HSTS (all, Med). netlify.toml [[headers]]; check securityheaders.com.
11.2 CORS `*` with credentials or reflecting any Origin (all, Med).
11.3 Verbose errors / catch blocks that fail open (all, Med). Auth catch blocks must deny.
11.4 Logging emails/tokens/request bodies (all, Med).
11.5 Deploy previews hitting the prod DB; preview URLs public (all, Med).
11.6 Source maps published (all, Low–Med).
11.7 Subdomain takeover / expired domain (all, High). Audit DNS, auto-renew, registrar lock.
11.8 .env, .git, backup.sql in publish dir (S, High). `curl site/.env` must 404.

## 12. Resilience
12.1 No backups / never tested restore (all, High). Scheduled pg_dump, test a restore. Supabase free projects pause when inactive.
12.2 No monitoring/billing alerts (all, Med).

## 10-minute pre-launch check
1. Build, grep dist/ for keys; gitleaks on history.
2. Supabase Security Advisor 0 errors; no RLS-off tables; no `using (true)` on private data.
3. curl every table with anon key: logged out, and as a second user.
4. No sensitive public buckets; Edge Functions verify JWT + ownership.
5. Stripe: constructEvent, server-side prices, fulfil only in webhook.
6. Paid/AI endpoints 401 without token, per-user cap, provider spend limits.
7. 2FA everywhere; dev/prod separate; agent/MCP read-only on prod.

Not verified: Supabase rate-limit defaults, Netlify credit numbers, Supabase free backup policy.

## 13. Added from Alon's pre-launch list (2026-10-04)
13.1 Public leaderboards/profiles must read from a safe-columns table or view (security_invoker on) that holds only display name + score, never email/ids/flags (G, High). Extends 2.5.
13.2 Admin/owner flag protected by a trigger that rejects any change not made by the service role; test by trying `update profiles set is_admin=true` as a normal user (all, Crit). Extends 2.6.
13.3 Profiles private by default: select policy = owner only; public view is opt-in (all, Med).
13.4 Supabase Security Advisor: run it, then explain EVERY warning in plain words and fix or justify it (all, High).
13.5 Only the publishable/anon key in the app and in the built files; GitHub secret scanning + push protection + Dependabot alerts ON (all, Crit). CHECK: repo Settings → Code security.
13.6 Permissions-Policy header: `camera=(), microphone=(), geolocation=()` unless the app truly needs them; plus HSTS, CSP, `frame-ancestors 'none'`, `X-Content-Type-Options: nosniff` (all, Med). CHECK: `curl -I https://site`.
13.7 `npm audit --audit-level=high` must exit 0 (no high/critical) (all, High).
13.8 Usernames/display names filtered on the SERVER (Edge Function or DB check/trigger), not only in the browser: swearing, slurs, emails, phone numbers, links/URLs, @handles; length limit (G/all with names, Med). Test by sending a bad name with curl.
13.9 Hosting alive: Supabase project not paused (free projects pause after ~1 week idle), Netlify site not paused/out of credits (all, High). CHECK: dashboards + load the live site.
13.10 Auth Site URL = the live domain only; Redirect URLs only exact live + localhost dev, no broad wildcards (all, High). Extends 3.6.

## Test-for-real rule
Every fix must be proven, not assumed: e.g. sign in as user B and try to edit user A's row → must fail; call a paid/AI endpoint with no token → 401; POST a fake Stripe webhook → 400; set a slur as a username via curl → rejected. Show the failing attempt as evidence.

## 14. Non-database projects: extensions, MCP servers, tools (added after the Forge run, 2026-10-04)
Found for real on a live project: the risk is often slowness and crashes, not data leaks.
14.1 Slow regex / ReDoS: a pattern like `(\s*\w+\s*)+` or nested `*`/`+` can take seconds to minutes on long or odd input (4,000 spaces froze a real engine for 67 s). Pasted text, file names, chat logs are all attack input (all, High). Fix: avoid nested quantifiers, cap input length, test with long inputs in a worker that's killed after a few seconds (templates/security-tests/plain.test.mjs `finishesWithin`).
14.2 Decompression / zip bombs: a 1 MB PNG, zip or gzip can unpack to gigabytes and crash the process. A file-size limit doesn't help: cap the UNPACKED size (e.g. width × height × channels) (any upload or image/file tool, High).
14.3 Browser extensions: ask for the fewest permissions (no `<all_urls>`, list exact sites); a strict extension CSP; no `eval`/remote code; never auto-press Send or act for the user without a click; message handlers check the sender; Chrome Web Store needs an adult account + data disclosure + privacy link (extension, High).
14.4 MCP servers / AI tools: every tool input is untrusted (it can come from a prompt-injected AI): validate paths (no reading files outside an allowed folder), cap sizes and time, prefer read-only tools, never return secrets or file contents the user didn't ask for (MCP, High).
14.5 Local dev servers (bench/preview receivers): CORS only hides the reply; it doesn't stop a write. Check the Origin header and refuse other websites, block path traversal (`../`) (dev tools, Med).
14.6 Big bundles and word lists cause scanner noise: review XSS/PROMPT hits in your own source, not in generated bundles.
