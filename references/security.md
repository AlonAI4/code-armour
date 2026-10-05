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

## 15. Added after gap review (2026-10-05)
New keys: E extension, M mobile, B Discord/Telegram bot, P MCP server/AI plugin, D desktop (Electron), CI GitHub Actions. [V] = checked against the source; [GK] = standard practice, not fetched.

### CI/CD and GitHub
15.1 "Pwn request": `pull_request_target` runs a stranger's PR code with your secrets [V] https://securitylabs.datadoghq.com/articles/case-for-github-actions-security/ (CI, Crit). The 2025 s1ngularity/Nx attack used it to steal an npm token. AI copies it "so secrets work on fork PRs" and checks out `head.sha`. Fix: `pull_request` for anything that builds/tests PR code; `pull_request_target` only for labelling/commenting, never checking out the PR head. CHECK: `grep -rn "pull_request_target" .github/workflows/` (a hit that also checks out head.sha/head.ref = Crit).
15.2 Workflow script injection via issue/PR titles [V] https://docs.github.com/en/actions/concepts/security/script-injections (CI, High). `run: echo "${{ github.event.issue.title }}"` is pasted into the shell before it runs. Fix: pass through `env:` and use `"$TITLE"`. CHECK: `grep -rnE '\$\{\{ *github\.event\.(issue|pull_request|comment|review|head_commit)\.[a-z_.]*(title|body|message|name|ref|label)' .github/workflows/`; tools like zizmor [GK].
15.3 Unpinned third-party actions (tj-actions style) [V] https://www.sentinelone.com/vulnerability-database/cve-2025-30066 (CI, High). March 2025: moved tags printed secrets into public logs on ~23k repos. Fix: pin third-party actions to a full commit SHA (with a version comment; Dependabot updates SHAs) and `permissions: contents: read` at the top. CHECK: `grep -rnE "uses: [^@]+@(v?[0-9]+(\.[0-9]+)*|main|master)$" .github/workflows/ | grep -v "actions/"`; Settings → Actions → Workflow permissions = Read.
15.4 Secrets printed into Actions logs [GK] (CI, High). `echo $TOKEN`, `set -x`, `env` dumps; masking misses base64/JSON-wrapped values; public repos have public logs. CHECK: `grep -rnE "set -x|printenv|env$|echo .*secrets\." .github/workflows/`.
15.5 Bot auto-merge [GK] (CI, High). Auto-merging every Dependabot PR ships a hijacked package with nobody looking (how 9.2 worms spread). Fix: auto-merge only dev-dependency patch updates after CI, require review on main.
15.6 Secrets baked into Docker images [V] https://www.esecurityplanet.com/threats/flare-finds-10000-docker-hub-images-exposing-sensitive-secrets/ (containers/bots, Crit). `COPY . .` copies `.env`; `ARG/ENV API_KEY=` stays in layers. Fix: `.dockerignore` with `.env*` and `.git`, runtime secrets or `RUN --mount=type=secret`. CHECK: `grep -nE "^(ARG|ENV) .*(KEY|SECRET|TOKEN)" Dockerfile`; `docker history --no-trunc IMAGE | grep -iE "key|secret|token"`.

### Auth, sessions, email
15.7 Password-reset poisoning [V] https://portswigger.net/web-security/host-header/exploiting/password-reset-poisoning (custom auth, Crit). Reset links built from `req.headers.host`/`X-Forwarded-Host` send the victim's token to evil.com. Fix: build links from a fixed SITE_URL. CHECK: `grep -rnE "headers\.(host|\[.x-forwarded-host.\])|req\.get\(.host.\)" .`.
15.8 Account enumeration [GK] (login, Med). "No account with that email" tells attackers which emails are real (and on kids' apps, who uses it). Fix: one generic message on login/signup/reset. CHECK: reset for a real and a fake email give identical responses.
15.9 Hand-rolled login with no lockout [GK] (custom auth/admin PIN pages, High). Fix: limit per IP and per account, CAPTCHA after failures. CHECK: 30 wrong logins in a curl loop must hit 429.
15.10 CAPTCHA shown but never verified [GK] (all, High). Bots skip the widget. Fix: verify the token server-side (siteverify) or enable CAPTCHA inside Supabase Auth. CHECK: `grep -rn "siteverify" .` (widget present but no hit = fail); submit the form via curl with no token: rejected.
15.11 JWT pitfalls in hand-rolled auth [GK] (custom auth, Crit/High). decode without verify, `alg: none`/unpinned algorithm, weak secret, no or long `exp`, tokens in localStorage. Fix: pinned algorithm / JWKS, short tokens + refresh, HttpOnly Secure SameSite cookies where you control the server. CHECK: `grep -rnE "jwt\.decode|algorithms:|expiresIn|localStorage\.setItem\(.*(token|jwt)" src/`.
15.12 Hand-rolled OAuth without state/PKCE [V] https://datatracker.ietf.org/doc/html/rfc9700 (custom social login, High). Login CSRF / stolen codes. Fix: provider SDK, Supabase Auth or Auth.js; else PKCE + single-use state + exact redirect_uri.
15.13 Magic links and OTPs [GK] (Med). Reusable or hours-long links, unlimited OTP guesses. Fix: single-use, ≤15 min, attempt limits. CHECK: using a magic link twice fails.
15.14 Skippable 2FA [GK] (High). Session is already valid after the password step. Fix: require `aal2` on the server/RLS for sensitive actions (`(select auth.jwt()->>'aal') = 'aal2'`). CHECK: password-only token calling a protected endpoint is refused.
15.15 No SPF/DKIM/DMARC on your domain [V] https://digicert.com/blog/google-yahoo-announces-new-bulk-email-requirements (any custom domain, Med/High). Anyone can spoof support@yourgame.com; your real emails land in spam. Fix: SPF + DKIM for your mail sender, `_dmarc` p=quarantine; if you send no mail: `v=spf1 -all` and `p=reject`. CHECK: `dig +short TXT yourdomain.com` and `dig +short TXT _dmarc.yourdomain.com`.

### Server-side bugs AI writes
15.16 Zip slip / path traversal in app code [GK] (uploads, mod/level loaders, High). `../../.env` in filenames or zip entries. Fix: resolved path must start with base + separator; generated names; extractors that reject `..`. CHECK: `grep -rnE "path\.join\([^)]*(req\.|params|query|body|filename|entry)" .`; upload `../x.txt`.
15.17 Unsafe deserialization and server-side templates [GK] (backends, Crit). `pickle.loads`, `yaml.load`, `torch.load` on user files, `eval`/`new Function`/`vm` on input, rendering user text as a template (SSTI). Fix: JSON only, `yaml.safe_load`, user data as template variables only. CHECK: `grep -rnE "pickle\.loads?|yaml\.load\(|torch\.load|render_template_string|new Function\(|\beval\(|vm\.run|ejs\.render\(|Handlebars\.compile\(" .`.
15.18 PDF/screenshot generators and image proxies = SSRF [GK] (High). Puppeteer rendering user URLs can reach `169.254.169.254` or `file://`; `/api/image?url=` becomes an open proxy on your bill. Fix: render your own templates with escaped data, block private IPs after DNS, allowlist hosts (`remotePatterns` with exact hosts). CHECK: submit `http://169.254.169.254/` and `file:///etc/passwd`: both fail.
15.19 CDN caching private pages [V] https://osv.dev/vulnerability/CVE-2024-46982 (High). A cached personal page is shown to the next visitor. Fix: anything reading cookies/auth sends `private, no-store`; keep Next.js updated. CHECK: `curl -sI https://site/account | grep -i cache-control` logged in and out; `grep -rn "s-maxage\|public, max-age" .`.
15.20 Supabase Realtime without policies [V] https://supabase.com/docs/guides/realtime/authorization (games/chat, High). Extends 7.4: public channels are open to anyone with the anon key; `private: true` needs RLS on `realtime.messages`. CHECK: `select * from pg_policies where schemaname='realtime';`.
15.21 Cron/webhook/"internal" endpoints with no auth [GK] (High). `/api/cron/reset-leaderboard` is a public URL. Fix: `Authorization: Bearer $CRON_SECRET` with a timing-safe compare, or scheduled functions with no public route. CHECK: curl it with no header: 401.
15.22 Double-spend races [GK] (games/stores/AI credits, High). "Read balance, check, write" in two steps lets 20 parallel requests spend the same coins 20 times; same for one-time coupons and trials. Fix: one atomic statement (`update wallets set coins = coins - 10 where user_id = $1 and coins >= 10 returning coins`) or a unique constraint / `for update` inside an RPC. CHECK: `seq 20 | xargs -P20 -I{} curl ...`: the balance drops by exactly what's allowed.

### Storage and data
15.23 Public R2/S3 buckets and `r2.dev` [V] https://developers.cloudflare.com/r2/buckets/public-buckets/ (uploads, Crit). Same leak as 2.7 outside Supabase. Fix: private bucket + presigned URLs for user files; public assets in a separate bucket on a custom domain. CHECK: bucket public-access setting; try listing the root anonymously.
15.24 Unencrypted backups in the repo or public places [GK] (High). Fix: encrypt (age/gpg), store privately, set retention. CHECK: `git ls-files | grep -iE "\.sql|\.dump|backup"` is empty.
15.25 Personal data in logs and error trackers [GK] (Med). Session replay records inputs; logs keep IPs/emails forever. Fix: mask inputs, scrub PII, ≤30-day retention, list the tracker in the privacy policy. CHECK: `grep -rn "Sentry.init\|LogRocket.init\|replayIntegration" src/`.

### Bots, desktop, mobile, extensions
15.26 Discord/Telegram bot token leaks and command injection [GK] (B, Crit). Hardcoded tokens; `exec(\`ping ${args}\`)`; admin commands checking only the name. Fix: env var, `execFile` with an argument array, server-side permission/owner checks, `allowedMentions: { parse: [] }`. CHECK: `grep -rnE "[MN][A-Za-z0-9_-]{23,25}\.[A-Za-z0-9_-]{6}\.[A-Za-z0-9_-]{27,}|[0-9]{8,10}:AA[A-Za-z0-9_-]{33}" .` and `grep -rn "exec(\|execSync(" .`. (Unverified: whether Telegram tokens are reported by GitHub secret scanning.)
15.27 Electron: XSS becomes computer takeover [V] https://electronjs.org/docs/latest/tutorial/security (D, Crit). Fix: `contextIsolation: true`, `sandbox: true`, `nodeIntegration: false`, narrow `contextBridge` functions (never ipcRenderer itself), https allowlist for `shell.openExternal`. CHECK: `grep -rnE "nodeIntegration: *true|contextIsolation: *false|webSecurity: *false|sandbox: *false|exposeInMainWorld\(.*ipcRenderer" .`.
15.28 Mobile deep links and debug settings [GK] (M, High). `myapp://pay?amount=` can be opened by any app; custom schemes can be claimed. Fix: untrusted parameters, confirmations, verified Universal/App Links for auth. CHECK: `grep -rnE "usesCleartextTraffic|NSAllowsArbitraryLoads|debuggable" android/ ios/ app.json`.
15.29 Extension content script relaying page messages to the background [GK] (E, High). Extends 14.3: any website can then drive your extension. Fix: check `event.source === window` and origin, allowlist action names, keep tokens away from content scripts. CHECK: `grep -rn "addEventListener(.message" ` in content scripts; review `externally_connectable`.

### AI tools, agents, MCP
15.30 MCP tool poisoning, rug pulls, shadowing [V] https://labs.cloudsecurityalliance.org/research/csa-research-note-mcp-tool-poisoning-ai-agent-exfiltration-2/ (High). Hidden instructions in tool descriptions; a clean server can change later. Fix: known publishers, pinned versions (no `npx -y pkg@latest`), re-review after updates; if you publish one, keep descriptions plain. CHECK: `grep -n "@latest\|npx -y"` in your MCP config files.
15.31 The "lethal trifecta" (private data + untrusted text + a way out) [V] https://generalanalysis.com/blog/supabase-mcp-blog (all devs, Crit). A support ticket told an agent with service_role to copy tokens into the ticket. Fix: never combine prod/service_role access with reading user content; read-only, project-scoped MCP; approve each tool call when browsing. CHECK: MCP config has no service_role; Supabase MCP has `--read-only` and a project_ref.
15.32 Malicious editor extensions and AI skills [V] https://thehackernews.com/2025/12/glassworm-returns-with-24-malicious.html (all devs, High). GlassWorm fake extensions stole GitHub/npm tokens. Fix: verified publishers only, remove unused ones, read a skill's scripts before enabling it (or scan it with NVIDIA SkillSpector). CHECK: `code --list-extensions --show-versions`.
15.33 AI "make it work" shortcuts [GK] (all, High). TLS verification off, real-looking keys in tests/fixtures, `// TODO auth` stubs returning true. CHECK: `grep -rnE "rejectUnauthorized: *false|NODE_TLS_REJECT_UNAUTHORIZED|verify=False|InsecureSkipVerify|return true; *// *TODO" .`; run gitleaks over test folders too.

## 16. Third sweep (2026-10-05)
16.1 Dev server exposed or used in production [V] https://osv.dev/CVE-2025-30208 (S/G/A, High). Vite before 6.2.3/5.4.15/4.5.10 with `--host`: `?raw??` returns any file (.env, ~/.ssh). Next.js CVE-2025-48068: any website can read your `next dev` source. AI deploy configs often start with `npm run dev`. Fix: update; never `--host`/0.0.0.0 on cloud VMs, public Codespaces or café Wi-Fi; production runs the build. CHECK: scanner; `npm ls vite next`.
16.2 Branch deploys indexed; robots.txt and sitemap as a treasure map [V] https://answers.netlify.com/t/how-do-i-prevent-google-from-crawling-domains-that-are-not-my-custom-domain/48489 (S, Med). Netlify branch deploys aren't noindex; `Disallow: /admin` points attackers there. Fix: noindex for non-production, password-protect staging, robots.txt isn't access control. CHECK: scanner; `curl -sI https://branch--site.netlify.app | grep -i x-robots`.
16.3 CSV/formula injection in exports [V] https://owasp.org/www-community/attacks/CSV_Injection (admin exports, Med). A name like `=HYPERLINK(...)` runs in Excel/Sheets. Fix: prefix cells starting with `= + - @ tab CR` with `'`. CHECK: export a row with `=1+1`.
16.4 GraphQL surface [V] https://supabase.com/changelog/46320-breaking-change-in-pg-graphql-1-6-0-graphql-introspection-disabled-by-default (Med). Older Supabase projects publish the anon-visible schema at `/graphql/v1`; custom Apollo/Yoga servers: introspection off in production, depth/complexity limits, rate-limit aliased batches. Fix: `drop extension pg_graphql;` if unused. CHECK: `select extname from pg_extension where extname='pg_graphql';`.
16.5 AI image/video generation abused for illegal content [GK] (A, Crit). Moderation on prompt AND output, block img2img/face-swap of real people, per-user caps and cooldowns, stricter tier for new accounts, keep flagged items (1-year NCMEC preservation). CHECK: scanner; 5 known-bad prompts all refused and logged.
16.6 WebRTC P2P reveals players' home IPs [GK] (G voice/video, High for kids). Fix: SFU or TURN with `iceTransportPolicy: 'relay'`, short-lived server-made TURN credentials, voice off by default for minors. CHECK: scanner; chrome://webrtc-internals shows a `relay` pair.
16.7 Business-logic abuse (OWASP API6) [GK] (G/$/A, Med). Referral/trial/vote farming with `+alias` emails or scripts. Fix: rewards after verified signals, normalise emails, one trial per card fingerprint, CAPTCHA on reward actions. CHECK: `a+1@` and `a+2@` don't both get the reward.
16.8 "Deceptive site" flags [GK] (Med). New sites on *.netlify.app/*.pages.dev/*.vercel.app with lookalike login forms get Safe Browsing red pages; user-uploaded HTML/PDF on your domain gets it blocklisted. Fix: own domain + Search Console, official OAuth buttons, user files on a separate domain with `Content-Disposition: attachment`. CHECK: https://transparencyreport.google.com/safe-browsing/search?url=yourdomain
16.9 Personal data left in browser storage [GK] (Low–Med). Emails, chats, AI conversations in localStorage/IndexedDB survive logout on shared school computers. Fix: clear on logout, keep personal data server-side. CHECK: after logout, DevTools storage holds no personal data.
