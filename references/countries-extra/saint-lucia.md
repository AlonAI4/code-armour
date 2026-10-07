# Saint Lucia (researched 2026-10-07, by Claude Opus 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Low for a small foreign-run app with a few users here (data law only partly in force, no regulator yet, reach to foreign apps is narrow).
Marks: [V-reg] regulator/official law text, [V-sec] law firm/news/tracker, [K] memory. Official law pages read on attorneygeneralchambers.com (some URLs returned 404 without "www.").

## Privacy
- [V-reg] Data Protection Act No. 11 of 2011 (amended Act 2 of 2015). Only partly in force since 31 Jan 2023 (S.I. 4/2023): Part I, ss.32-43 of Part III (data protection principles, collection, consent, sensitive data, accuracy, security, duty to destroy), Part VI (exemptions), Schedule 2 paras (a)-(g). Minister can commence parts on different dates (s.1(2)-(3)).
- [V-sec] Part II (Data Protection Commissioner) not in that order; no Commissioner appointment found; rights and enforcement provisions still pending (law.ungovr.org, UWI). So: duties exist on paper, nobody to enforce them yet.
- [V-reg] Reach (s.3): controllers established in Saint Lucia, or not established but **using equipment in Saint Lucia** (then name a local representative). "Established" includes a CARICOM national. A foreign app hosted abroad is mostly outside.
- [V-reg] s.45 "Transfer of personal data" exists but is outside the 2023 commencement, so no transfer rule is in force.
- [V-reg] No children-specific section in the Act's section list. No breach-notice deadline in the commenced parts [K].

## Kids and games
- [K] No children's data age, loot-box or game-time law found. Age of majority 18. Gambling needs a local licence.

## Selling
- [V-reg] Consumer Protection Act (Revised Laws 2023), s.77: consumer can cancel a direct, distance or **electronic** marketing agreement within 10 business days of delivery (goods) or 5 business days of entering the agreement (no delivery, e.g. services/digital). 3 months if the supplier broke the Act. **Subscriptions: cancel any time on one month's notice, without penalty** (s.77(5)). Exceptions for consumed/used-up goods.
- [V-sec] VAT 12.5% (VAT Act No. 7 of 2012). IRD lists imported services as taxable. Registration threshold EC$400,000 (IRD page; one government page still says EC$180,000). No special non-resident digital-services rule found (lookuptax, expanship).
- [K] Stripe does not support Saint Lucia-based businesses; selling to Saint Lucians from abroad works.

## AI, content and platforms
- [V-sec] No AI law found; CARICOM AI Policy Roadmap endorsed 18 Jun 2026 (policy only) (CPA UK/UNESCO).
- [K] Computer Misuse Act covers hacking/illegal access.

## What a small foreign dev should consider
- Follow the commenced principles anyway (they are basic: consent, purpose, accuracy, security, delete when done).
- Subscriptions sold to Saint Lucians: let them cancel easily (one month's notice max) and state a refund/cancel window.
- No VAT action for a tiny foreign seller found; use a Merchant of Record to be safe.

## Upcoming
- [V-sec] Further DPA commencement orders (Commissioner, rights, transfers) expected; no date found.

## Unverified
- Whether any commencement order after S.I. 4/2023 exists; Commissioner appointment; whether s.77 cooling-off applies to purely digital goods; VAT on B2C digital imports.

## Sources
- https://attorneygeneralchambers.com/laws-of-saint-lucia/data-protection-act/section-1
- https://attorneygeneralchambers.com/laws-of-saint-lucia/data-protection-act/section-3
- https://attorneygeneralchambers.com/laws-of-saint-lucia/data-protection-act/section-32
- https://attorneygeneralchambers.com/laws-of-saint-lucia/data-protection-act/act
- https://www.attorneygeneralchambers.com/laws-of-saint-lucia/consumer-protection-act/section-77
- https://law.ungovr.org/ai/lc
- https://www.offlist.me/what-is-saint-lucia-data-protection-act-2011
- https://irdstlucia.gov.lc/index.php/corporations/business-taxation
- https://lookuptax.com/docs/tax-identification-number/saint-lucia-tax-id-guide
- https://www.expanship.com/lc/blog/st-lucia-sales-tax
- https://www.uk-cpa.org/media/g1tpd2m1/caribbean-ai-workshop-outcome-statements.pdf
