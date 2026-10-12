# Code Armour pre-launch checks: <project name> (not a compliance certificate)

> ⚠️ Code Armour provides automated technical checks and general compliance information. It does not provide legal advice, certify compliance, guarantee security or identify every possible risk. Results may be incomplete or incorrect. Users remain responsible for testing their websites, reviewing applicable requirements and obtaining professional advice where appropriate. Laws differ by country and change often.

Checked: <date> · Stack: <e.g. Vite + Supabase + Netlify + Stripe> · Builder in: <country> · Users in: <countries>
Project type: <site / game / AI app / store> · Logins: <yes/no> · Payments: <yes/no> · Under-13s / under-18s possible: <yes/no>

Re-test any time: `bash security-tests/run.sh [live-url]` (also runs on every push if the GitHub workflow is added). Last re-test: <date> · result: <passed / N failed>

Key: ✅ check passed (with proof; not a statement of compliance) · ❌ problem not fixed · ➖ likely doesn't apply (why) · ❓ needs checking
Finding categories: 🔧 Confirmed technical issue · 🔍 Potential issue requiring verification · 📋 General compliance consideration · ⚖️ Professional advice recommended. A row that cites a finding shows its category; a 📋 or ⚖️ row is never ✅.
Legal rows can never be ✅ from code alone: use 📝 drafted · 👤 reviewed by an adult · ❓ not reviewed.
If the builder is under 18, a parent reads every legal page before launch.

<!-- Rules the checker (scripts/validate-findings.mjs) applies to EVERY line that mentions a finding id, in the lists
     below and in the tables. Follow them and the first draft passes. Delete this comment when the file is filled in.
     1. Only cite ids that are in .code-armour/findings.json. Never cite a rejected finding.
     2. The line shows the finding's category: its icon (🔧 🔍 📋 ⚖️) or its full label.
     3. Verdict needs_validation (every 🔍, and most 📋 and ⚖️): the line must contain ❓.
     4. Confirmed and still open: no ✅ anywhere on that line (use ❌).
     5. Confirmed and fixed (it has a proving test): don't mark the line ❌ (use ✅, or no status mark in the lists).
     6. A line citing a 📋 or ⚖️ finding can never contain ✅, even next to another finding that is fixed.
     Two findings on one line must each obey these, so give a fixed finding and an open one separate lines. -->
## Findings by category
### 🔧 Confirmed technical issue
<one line per finding, worst first. Fixed: "- 🔧 F-NNN <problem in plain words>. Fixed, proven by <test name>." Open: "- 🔧 ❌ F-NNN <problem>. Open: <what to do>.">
### 🔍 Potential issue requiring verification
<one line per finding: "- 🔍 ❓ F-NNN <what might be wrong>. Check: <exact step or command>.">
### 📋 General compliance consideration
<one line per finding: "- 📋 ❓ F-NNN <rule that may apply>. <what to do or decide>.">
### ⚖️ Professional advice recommended
<one line per finding: "- ⚖️ ❓ F-NNN <topic>. Ask: <who, e.g. a parent, a privacy lawyer, an accountant>.">

## 1. Data access
| Item | Status | Proof / what to do |
|---|---|---|
| Every table/collection has server-side rules (RLS / Firebase rules / server filters) | | |
| Users can only read & change their own rows (tested as a second user) | | |
| Nobody can make themselves admin or add credits/score (tested) | | |
| Profiles private by default; public lists come from a safe-columns table | | |
| No "anyone can call" functions / open RPCs | | |
| Storage: private buckets, size + type limits | | |
| Security Advisor / rules checker: every warning explained and fixed or justified | | |

## 2. Keys & secrets
| Item | Status | Proof / what to do |
|---|---|---|
| Only public keys in the app and the build (scan clean) | | |
| No secrets in the repo or git history (leaked ones rotated) | | |
| GitHub secret scanning, push protection, Dependabot on | | |
| 2FA on GitHub, host, database, payments, domain, npm | | |
| Shared as a zip or folder: built from git, no `.env` or real key value inside (`recipes/sharing/share-zip.sh`) | | |

## 3. Server code
| Item | Status | Proof / what to do |
|---|---|---|
| Every API route / function checks the login on the server (401 without it) | | |
| Ids from requests checked against the caller (no IDOR) | | |
| Payment webhook signature verified; purchase granted only by the webhook (fake POST → 400) | | |
| Prices decided by the server | | |
| AI / paid endpoints: login + per-user limit + provider spend cap | | |
| Rate limits / CAPTCHA on signup, login, forms | | |
| Errors don't show stack traces or database details | | |

## 4. Website & dependencies
| Item | Status | Proof / what to do |
|---|---|---|
| HTTPS + HSTS, CSP, no framing, nosniff, Permissions-Policy (curl -I) | | |
| /.env, /.git not downloadable; no source maps | | |
| npm audit: no high/critical | | |
| New packages checked to be real (no invented names) | | |
| Hosting/database not paused or out of credits; billing alerts set | | |
| Sign-in Site URL / redirect URLs = live site only | | |
| Backups exist and a restore was tried | | |

## 5. Kids
| Item | Status | Proof / what to do |
|---|---|---|
| 📋 Neutral age question before any account | | |
| 📋 Under 13 = guest only (no email, no public name) | | |
| 📋 Private by default; leaderboards/friends opt-in; no chat with strangers | | |
| 📋 Country-specific rules for minors checked (see country files) | | |

## 6. Privacy
| Item | Status | Proof / what to do |
|---|---|---|
| 📋 Plain-words privacy page: what, why, how long, who it's shared with, how to delete, a parents section | | |
| 📋 Working "delete my account" that removes everything (tested) | | |
| 📋 No trackers or ads (or a real consent banner) | | |
| 📋 Fonts self-hosted | | |
| 📋 Breach plan: who to tell and how fast (72h in many countries) | | |
| 📋 No backend: users told which outside services their device contacts and what each one sees (legal 16) | | |

## 7. Names & user content
| Item | Status | Proof / what to do |
|---|---|---|
| Names filtered ON THE SERVER: swearing, slurs, emails, phones, links, handles (tested via curl) | | |
| Report button + takedown process (if users can post) | | |

## 8. Legal pages & selling
| Item | Status | Proof / what to do |
|---|---|---|
| 📋 Terms of service | | |
| 📋 Privacy policy | | |
| 📋 Accessibility statement | | |
| 📋 Refund / withdrawal rules shown before purchase | | |
| ⚖️ Tax: Merchant of Record, or registered where needed | | |
| ⚖️ Accounts owned by an adult where required (Stripe, app stores, AI APIs) | | |
| 📋 Licences/credits file for every asset, font, sound and library | | |
| 📋 Cloned or renamed project: original licence file unchanged, original author credited, credits for added data and services (legal 16) | | |
| 📋 Free public data services used within their usage rules (attribution, request limits; legal 16) | | |
| 📋 Lawful basis written down for each use of personal data | | |
| 📋 Data processing agreements accepted (database, host, payments, AI) | | |
| ⚖️ EU/UK representative needed? (builders outside the EU/UK) | | |
| 📋 Parent named as data controller and contact (builder under 18) | | |
| 📋 Legal pages reviewed by an adult | | |
| 📋 UK Online Safety Act: written illegal-content risk + children's access assessments (if users post, UK users) | | |
| 📋 AI provider: training/retention off, user age rules respected | | |
| 📋 Cookie consent (EU) or UK analytics exemption; email opt-in | | |
| 📋 No ad/analytics pixels or session replay without consent (US CIPA suits) | | |
| 📋 Every promise in the privacy policy matches the code | | |
| 📋 UK: ICO data protection fee paid (if required) | | |
| 📋 AI content labelled where required | | |
| ⚖️ Loot boxes: odds shown / not sold to minors / geo-blocked where banned | | |

## Not checked (coverage gaps: problems here may be missed)
<anything you couldn't verify, and the exact command or step for the owner to do it>
