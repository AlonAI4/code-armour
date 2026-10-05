# Morocco (researched 2026-10-05, by Claude Opus 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Low for a small foreign-run app with a few users here. Law 09-08 mainly reaches controllers established in Morocco or using means there; VAT on foreign digital services is now enforced.
Note: no regulator site was read (cndp.ma, tax.gov.ma not fetched). Marks: [V-reg] regulator/law text today, [V-sec] law firm/news today, [K] memory.

## Privacy
- [V-sec] Law 09-08 (18 Feb 2009) + Decree 2-09-165; regulator CNDP. Still in force; reform discussed but no replacement law enacted as of 2026. (Chambers 2026, DPO Consulting)
- [V-sec] Reach: controllers established in Morocco, or not established but using means located in Morocco (e.g. servers there). Those must name a local representative and file declarations/authorisations with CNDP. A foreign app hosted abroad is likely outside. (Upsilon Consulting)
- [K] Most processing needs a prior declaration to CNDP; sensitive data, biometrics and some transfers need authorisation.
- [V-sec] Cross-border transfers: only to countries with adequate protection, otherwise prior CNDP authorisation. (Upsilon)
- [V-sec] CNDP has started sending formal notices and investigations. (Hespress)
- [K] Consent must be unambiguous; children not specifically covered (majority 18, so parental consent).
- [K] No mandatory breach notification in 09-08.

## Kids and games
- [V-sec] Draft Law No. 471 on minors' access to online gaming platforms (introduced 13 Apr 2026): no accounts for under-13s; 13-18 only with parental supervision. Not law. (Hespress, MEA Tech Watch)
- [V-sec] Debate on restricting minors' social media; separate draft on child exploitation in online content. Not law. (Hespress)
- [K] No loot-box rule.

## Selling
- [V-sec] VAT 20% on digital services by non-residents to Moroccan consumers (Finance Law 2024); DGI platform "Taxation on Digital Services" opened 15 May 2026, fully live 11 June 2026; get a tax ID, file quarterly. Covers games, apps, AI, cloud, e-learning. (Le360, Morocco World News)
- [K] No registration threshold found.
- [V-sec] Consumer Law 31-08 (art. 36): right of withdrawal for distance sales, 7 days (up to 30 if info missing). Draft reform would extend to 14 days. (SNRT News, Hespress)
- [K] Stripe does not onboard Moroccan merchants; Moroccan cards can pay foreign Stripe/MoR (some cards limited for international use).

## AI, content and platforms
- [V-sec] Draft AI law No. 396 (introduced 31 Dec 2024): 4-tier risk system, right to opt out of interacting with AI. Not law. Government "Digital X.0" law and National AI Agency planned under Maroc Digital 2030. (Hespress, Africa Arbitration)
- [K] Press and Penal Code apply to user content (insulting monarchy, religion, territorial integrity): moderate chat.

## What a small foreign dev realistically must do
- Privacy policy (French/Arabic is a plus); don't host servers in Morocco unless you're ready for CNDP declarations.
- 7-day withdrawal: show it, or get consent to immediate digital delivery.
- 20% VAT, no threshold: use a Merchant of Record.
- Keep under-13s out if you run accounts (draft law direction); label AI.

## Upcoming
- [V-sec] Draft Law 471 (minors and online gaming): in Parliament since Apr 2026; no date.
- [V-sec] AI law (No. 396 / Digital X.0): pending; AI certification planned from 2027.
- [K] Law 09-08 reform: drafts discussed, no date.

## Unverified
- Declaration duties for foreign apps without Moroccan means; breach notice; VAT threshold; consumer rules for digital goods.

## Sources
- https://practiceguides.chambers.com/practice-guides/data-protection-privacy-2026/morocco
- https://www.dpo-consulting.com/blog/morocco-data-protection-law-09-08
- https://upsilon-consulting.com/en/law-09-08-foreign-companies-morocco/
- https://upsilon-consulting.com/en/international-personal-data-transfer-morocco/
- https://en.hespress.com/111530-111530.html
- https://en.hespress.com/136007-draft-law-in-morocco-seeks-to-restrict-childrens-access-to-online-gaming-platforms.html
- https://meatechwatch.com/2026/04/20/morocco-drafts-law-to-restrict-childrens-access-to-online-gaming-platforms/
- https://en.le360.ma/society/morocco-begins-enforcing-vat-on-netflix-chatgpt-and-other-foreign-digital-services_QC4SKKDX5FG37HDWLLTFPJDWY4/
- https://moroccoworldnews.com/2026/07/328303/moroccans-will-now-pay-20-vat-on-netflix-chatgpt-and-other-digital-services
- https://snrtnews.com/fr/article/e-commerce-au-maroc-une-croissance-rapide-face-a-une-protection-juridique-encore-limitee
- https://en.hespress.com/100403-100403.html
- https://africaarbitration.org/2025/11/05/morocco-drafts-landmark-law-to-govern-ai-data-and-digital-identity/
