# Code Armour checklist: <project name>

Checked: <date> · Stack: <e.g. Vite + Supabase + Netlify + Stripe> · Builder in: <country> · Users in: <countries>
Project type: <site / game / AI app / store> · Logins: <yes/no> · Payments: <yes/no> · Under-13s / under-18s possible: <yes/no>

> This is a checklist, not legal advice. Laws differ by country and change often. For anything serious, ask a lawyer.

Key: ✅ done (with proof) · ❌ not done · ➖ doesn't apply (why) · ❓ needs checking

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
| Only public keys in the app and the build (scan clean) | | |
| No secrets in the repo or git history (leaked ones rotated) | | |
| GitHub secret scanning, push protection, Dependabot on | | |
| 2FA on GitHub, host, database, payments, domain, npm | | |

## 3. Server code
| Every API route / function checks the login on the server (401 without it) | | |
| Ids from requests checked against the caller (no IDOR) | | |
| Payment webhook signature verified; purchase granted only by the webhook (fake POST → 400) | | |
| Prices decided by the server | | |
| AI / paid endpoints: login + per-user limit + provider spend cap | | |
| Rate limits / CAPTCHA on signup, login, forms | | |
| Errors don't show stack traces or database details | | |

## 4. Website & dependencies
| HTTPS + HSTS, CSP, no framing, nosniff, Permissions-Policy (curl -I) | | |
| /.env, /.git not downloadable; no source maps | | |
| npm audit: no high/critical | | |
| New packages checked to be real (no invented names) | | |
| Hosting/database not paused or out of credits; billing alerts set | | |
| Sign-in Site URL / redirect URLs = live site only | | |
| Backups exist and a restore was tried | | |

## 5. Kids
| Neutral age question before any account | | |
| Under 13 = guest only (no email, no public name) | | |
| Private by default; leaderboards/friends opt-in; no chat with strangers | | |
| Country-specific rules for minors checked (see country files) | | |

## 6. Privacy
| Plain-words privacy page: what, why, how long, who it's shared with, how to delete, a parents section | | |
| Working "delete my account" that removes everything (tested) | | |
| No trackers or ads (or a real consent banner) | | |
| Fonts self-hosted | | |
| Breach plan: who to tell and how fast (72h in many countries) | | |

## 7. Names & user content
| Names filtered ON THE SERVER: swearing, slurs, emails, phones, links, handles (tested via curl) | | |
| Report button + takedown process (if users can post) | | |

## 8. Legal pages & selling
| Terms of service | | |
| Privacy policy | | |
| Accessibility statement | | |
| Refund / withdrawal rules shown before purchase | | |
| Tax: Merchant of Record, or registered where needed | | |
| Accounts owned by an adult where required (Stripe, app stores, AI APIs) | | |
| Licences/credits file for every asset, font, sound and library | | |
| AI content labelled where required | | |
| Loot boxes: odds shown / not sold to minors / geo-blocked where banned | | |

## Not checked
<anything you couldn't verify, and the exact command or step for the owner to do it>
