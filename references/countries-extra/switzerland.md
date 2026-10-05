# Switzerland (researched 2026-10-05, by Claude Opus 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Low-Med for a small foreign-run app with a few users here. Switzerland is NOT in the EU: GDPR does not apply because of Swiss users alone, but the Swiss FADP is close to it. Fines hit individuals (not companies), and only for intentional breaches.

## Privacy
- [V-sec] Revised Federal Act on Data Protection (FADP / nDSG), in force 1 Sep 2023. Reaches foreign developers by its "effects" principle (processing that has effects in Switzerland). https://iapp.org/news/a/revised-swiss-data-protection-law-soon-in-effect-with-new-scope-obligations-implications
- [V-reg] Swiss representative (Art. 14 FADP) is needed only if ALL FOUR apply: you offer goods/services to or monitor people in Switzerland, processing is large-scale, regular, AND high-risk. A small app almost never meets all four. https://edoeb.admin.ch/en/representatives-in-accordance-with-article-14-fadp
- [V-sec] Breach notice: tell the FDPIC (data protection commissioner) "as soon as possible" if a breach is likely to cause high risk; no fixed 72h clock. https://iapp.org/news/a/revised-swiss-data-protection-law-soon-in-effect-with-new-scope-obligations-implications
- [V-sec] Fines up to CHF 250,000, criminal, against the responsible PERSON, only for intentional breaches (e.g. lying in a privacy notice, not answering access requests, ignoring security minimums). The FDPIC can investigate and order changes but cannot fine; cantons prosecute. https://cms.law/en/media/local/cms-vep/files/publications/publications/revision-of-the-swiss-federal-act-on-data-protection-final
- [V-sec] Cookies: Telecommunications Act Art. 45c is opt-out: tell users about cookies and their purpose and how to refuse. No banner is strictly required for ordinary cookies; consent is needed for high-risk profiling. FDPIC updated cookie guidance on 6 Oct 2025 (covers consent and cookie paywalls). https://www.cookieyes.com/blog/fdpic-swiss-cookie-consent/
- [K] No privacy-law small-business exemption for the core duties (privacy notice, security, user rights). Firms under 250 staff are exempt from keeping a record of processing unless the processing is high-risk.
- [K] Children: no fixed digital-consent age. A child can consent alone if they have "capacity of judgment" (often taken as about 13-16, case by case); otherwise a parent consents.
- [K] Transfers abroad: allowed to countries on the Federal Council's adequacy list (EU/EEA, UK, and the US via the Swiss-US Data Privacy Framework since Sep 2024); otherwise standard contractual clauses. Supabase/Netlify DPAs usually cover this.

## Kids and games
- [V-reg] Federal Act on the Protection of Minors in Film and Video Games (JSFVG): partly in force since 1 Jan 2025. Industry has two years (to about 1 Jan 2027) to write its own youth-protection rules, which then become binding. Expect age labels, age checks at sale, and, for platform services, parental controls and reporting tools. https://www.bsv.admin.ch/de/jugendschutz-in-den-bereichen-film-und-videospiele-jsfvg
- [V-sec] Online retailers and video/game platform services must use age labels and age checks; the federal office BSV supervises online commerce and platforms, the cantons do local shops. https://cms.law/en/che/legal-updates/upcoming-new-law-on-the-protection-of-youth-in-films-and-video-games-in-switzerland
- [K] Loot boxes: no specific law; under the Money Gaming Act they are generally not treated as gambling unless items can be cashed out. Don't allow cash-out or trading for money.

## Selling
- [V-reg] VAT: a foreign business selling electronic services (apps, games, SaaS, downloads) to Swiss consumers must register once its WORLDWIDE turnover reaches CHF 100,000/yr, even if Swiss sales are tiny. Below that, no Swiss VAT. https://www.estv.admin.ch/estv/en/home/value-added-tax/vat-tax-liability/foreign-companies.html
- [V-sec] Rate 8.1% (since 2024); a registered foreign seller must appoint a Swiss tax representative. Easiest fix: a Merchant of Record (Paddle, Lemon Squeezy, app stores) handles it. https://www.quaderno.io/tax-guides/switzerland-vat-guide
- [V-sec] Unfair Competition Act (UWG) Art. 3(1)(s): anyone selling online must show clear identity and contact address INCLUDING an email, explain the order steps, let buyers fix input errors, and confirm the order by email right away. Use an MoR's or business address, not your home, where possible. https://law.ch/lawinfo/ict-law-informations-und-kommunikationstechnologie/impressumspflicht-e-commerce/
- [K] No general 14-day right to cancel online purchases (unlike the EU); only doorstep/phone sales. Your own refund policy rules. Many Swiss shops still offer one voluntarily.
- [K] Stripe, Paddle and Lemon Squeezy all support Swiss buyers. Stripe accounts can be opened in Switzerland.

## AI, content and platforms
- [V-sec] No Swiss AI Act. Switzerland signed the Council of Europe AI Convention (Mar 2025) and will add targeted changes to existing laws; consultation draft due by end of 2026. The current FADP already applies to AI that processes personal data. https://www.bakom.admin.ch/en/artificial-intelligence
- [K] Federal Council proposed a law on large communication platforms (consultation late 2025), aimed at very large platforms (reporting, transparency). Not relevant to small apps.
- [K] No local representative or registration duty for small online services.

## Accessibility and other
- [K] Disability Discrimination Act (BehiG) binds federal authorities, not private small websites. No real enforcement against small private apps.

## What a small foreign dev realistically must do
- Have an honest privacy notice (what, why, who, where data goes); intentional lies are what get punished.
- Answer access/deletion requests within 30 days.
- Explain cookies and give an easy way to refuse them (a GDPR-style banner covers this).
- Selling: show an email and contact address, confirm orders by email. If worldwide turnover could reach CHF 100k, use a Merchant of Record.
- Games with violent or adult content: give an age rating and check age at purchase.

## Upcoming
- ~1 Jan 2027: JSFVG industry youth-protection rules for films/games become binding (two-year window from 1 Jan 2025). Exact date unconfirmed.
- End of 2026: consultation draft of Swiss AI rules (implementing the Council of Europe AI Convention).

## Unverified
- Exact JSFVG obligations and dates for small online game sellers (fedlex text not readable without JavaScript).
- Child capacity-of-judgment ages; loot-box status; no general withdrawal right; platform-law consultation; adequacy list incl. US.

## Sources
- https://edoeb.admin.ch/en/representatives-in-accordance-with-article-14-fadp
- https://www.bsv.admin.ch/de/jugendschutz-in-den-bereichen-film-und-videospiele-jsfvg
- https://www.estv.admin.ch/estv/en/home/value-added-tax/vat-tax-liability/foreign-companies.html
- https://www.bakom.admin.ch/en/artificial-intelligence
- https://iapp.org/news/a/revised-swiss-data-protection-law-soon-in-effect-with-new-scope-obligations-implications
- https://cms.law/en/media/local/cms-vep/files/publications/publications/revision-of-the-swiss-federal-act-on-data-protection-final
- https://cms.law/en/che/legal-updates/upcoming-new-law-on-the-protection-of-youth-in-films-and-video-games-in-switzerland
- https://www.cookieyes.com/blog/fdpic-swiss-cookie-consent/
- https://www.quaderno.io/tax-guides/switzerland-vat-guide
- https://law.ch/lawinfo/ict-law-informations-und-kommunikationstechnologie/impressumspflicht-e-commerce/
- Blocked/unreadable: fedlex.admin.ch (JavaScript-only), bag.admin.ch JSFVG page (404).
