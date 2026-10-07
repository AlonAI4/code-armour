# Malawi (researched 2026-10-07, by Claude Opus 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Med on paper (GDPR-style law that reaches foreign apps, under-18 parent consent, new VAT on foreign digital sales from sale 1), Low-Med in practice for a tiny foreign app.
Marks: [V-reg] regulator/official text, [V-sec] law firm/news/tax vendor, [K] memory.

## Privacy
- [V-sec] Data Protection Act, 2024 (Act No. 3 of 2024), in force 3 June 2024 (Government Notice No. 40 of 2024). Regulator: Malawi Communications Regulatory Authority (MACRA). It replaced the data protection parts of the Electronic Transactions and Cyber Security Act 2016 (TechHive Advisory, CIPIT Strathmore, search summaries).
- [V-sec] s.3 reach: applies to controllers/processors outside Malawi that target people in Malawi online (offer goods/services or monitor them) (TechHive).
- [V-sec] Registration (ss.41-42) only for "data controllers/processors of significant importance": domiciled in Malawi AND more than 10,000 data subjects in Malawi, or data of significance to the economy/society/security. A small foreign app is normally outside this (TechHive).
- [V-sec] Children = under 18 (s.17). Where you rely on consent, get a parent/guardian's consent and use "appropriate mechanisms" to verify age and the parent's identity (TechHive; second search summary).
- [V-sec] Breach: tell MACRA within 72 hours; processors tell the controller within 72 hours; tell users within 72 hours if high risk (ss.36-37) (TechHive, CIPIT).
- [V-sec] Transfers abroad (ss.38-40): only to an adequate country or with safeguards (contract clauses, BCRs, codes, certification), or by consent / contract necessity. Keep a record of the transfer basis. No data localisation rule found (TechHive).
- [V-sec] DPO only for public bodies or large-scale monitoring / sensitive data (s.33) (TechHive).
- Unverified: fine amounts (one vendor says up to MWK 5,000,000 and/or 12 months; not confirmed in the Act).

## Kids and games
- [V-sec] Under-18 parent consent rule above is the main one.
- [K] No loot-box or game-time law found. Gambling is licensed (Gaming and Lotteries Act); don't offer cash-out prizes.

## Selling
- [V-sec] Electronic Transactions and Cyber Security Act 2016, s.35: 7-day cooling-off for online contracts (goods: 7 days from receipt; services: 7 days from contract), no reason or penalty; refund within 14 days. Exceptions include services already started with the consumer's consent. s.33 lists information the supplier must show (heading seen; full list not read) (Malawi LII and Commonwealth trade repository snippets).
- [V-sec] VAT: Value Added Tax (Amendment) Act 2026, in force 15 April 2026. Non-resident sellers of digital services (streaming, software, apps/subscriptions, cloud, e-books, online ads...) to consumers in Malawi must register and charge 17.5% VAT, regardless of turnover. Marketplaces/intermediaries that issue invoices and collect payment take the duty. Customer location by billing address, IP, etc. No input VAT deduction (KPMG, Fonoa, VATCalc).
- Practical: use a Merchant of Record (Paddle / Lemon Squeezy / app stores) so they collect the VAT. Add a clear refund / cancellation policy that respects the 7-day rule (and say when a digital service starts, since that ends the right).

## AI, content and platforms
- [K] No AI law found. Cybercrime provisions of the 2016 Act (offensive communications) apply to user content; moderate it.

## Regional
- [K] SADC member; the SADC Model Law on Data Protection (2013) is a template, not binding. No SADC-wide digital VAT rule.

## What a small foreign dev should consider
- If you target Malawi: parent consent (or block) for under-18s, as Malawi's age is 18, not 13.
- 72-hour breach plan.
- Merchant of Record for paid sales (17.5% VAT from sale 1 since Apr 2026).
- Show a refund/cancellation policy that covers the 7-day cooling-off.

## Upcoming
- None dated found. Watch for MACRA opening registration and publishing regulations under the 2024 Act.

## Unverified
- Exact fine amounts; whether MACRA has opened controller registration; full s.33 supplier-information list; whether the 7-day rule was amended after 2017; cookie rules (none found).

## Sources
- https://www.techhiveadvisory.africa/insights/malawis-data-protection-act-aligning-to-the-new-regulatory-framework
- https://cipit.strathmore.edu/review-of-the-malawi-data-protection-act-2024/
- https://cdh-malawi.com/wp-content/uploads/2025/09/Data-Protection-Act-2024.pdf (Act text; could not be read by the tool)
- https://malawilii.org/akn/mw/act/2016/33/eng@2017-12-31
- https://kpmg.com/us/en/taxnewsflash/news/2026/05/tnf-malawi-nonresident-digital-services-providers-to-register-for-vat.html
- https://fonoa.com/resources/blog/malawi-vat-foreign-digital-services
- https://www.vatcalc.com/?p=49556
