# Palestine (West Bank and Gaza) (researched 2026-10-07, by Claude Opus 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Low for a small foreign app (no data-protection law in force; no country sanctions). Main practical issues: payments and connectivity.
Marks: [V-reg] regulator/official text, [V-sec] law firm/news/NGO, [K] memory.

## Sanctions
- [K] No US/UN/EU/UK country sanctions on Palestine or the Palestinian Authority's territory. Some named groups and people are designated (e.g. Hamas is a US FTO/SDGT); don't deal with listed parties. Ordinary users: no restriction. Check the SDN list before business deals.

## Privacy
- [V-sec] No comprehensive personal-data-protection law. A draft decree-law has been in cabinet since a 2016 committee; third reading dated 15 Jun 2022; not enacted as of the latest sources found (7amleh 2022-23). No enactment found in 2024-26 searches.
- [V-sec] Related rules: Decree-Law on Cybercrime (No. 10 of 2018, replacing No. 16 of 2017) has privacy-intrusion offences; Decree-Law No. 15 of 2017 on Electronic Transactions (security-legislation.ps, 7amleh).
- [V-sec] E-Commerce Decree-Law No. 21 of 2025: mandatory registration of online businesses, advertising transparency, e-contracts, store policies, data protection, payment methods (Andersen Palestine, Dec 2025). Details and whether it reaches foreign sellers not confirmed.
- [K] No cookie, breach-notice or localisation rule known for foreign apps.

## Kids and games
- [K] Palestinian Child Law (2004) defines a child as under 18. No data-consent age or game rules found.

## Selling
- [K] PA VAT (16%) exists but no rule found taxing foreign digital services sold to consumers.
- [V-sec] Payments: PayPal does not serve Palestinians in the West Bank and Gaza (Reuters via Oman Observer 2021; Noon Post 2025-26 reports frozen accounts). Stripe is not available for Palestinian businesses (doola guide; not confirmed on Stripe's own list). Payoneer reportedly restricted. Palestinian banks are on SWIFT. Card payments from Palestinian-issued cards may or may not work with your provider.
- [K] Users in Israeli settlements use Israeli banks/services, so availability differs by location, not by "Palestine" as a whole.

## Connectivity
- [V-sec] West Bank operators (Jawwal, Ooredoo Palestine) have been limited to 3G since 2018; Israel approved a 4G upgrade on 6 Jan 2026, with rollout expected over about six months (Arab News, Times of Israel). Gaza networks are limited to 2G, and Gaza infrastructure is heavily damaged.
- Practical: keep pages light, work on slow mobile data, allow offline/retry.

## AI, content and platforms
- [K] No AI law. Cybercrime decree has broad speech offences; moderate user content.

## What a small foreign dev should consider
- No local privacy law to comply with, but follow good practice (your home country's law still applies to you).
- Don't rely on PayPal/Stripe working for users there; offer a free tier or test card acceptance.
- Build for 2G/3G speeds.
- Screen business partners against sanctions lists (named groups only).

## Upcoming
- [V-sec] West Bank 4G rollout (approved Jan 2026; ~6-month timeline). Possible enactment of the data-protection decree-law (no date).

## Unverified
- Whether a data-protection decree passed in 2024-26; Decree-Law 21/2025 details and reach; "Electronic Transactions and Trust Services Law 2024" (one database mention only); whether 4G has launched; Stripe/Payoneer current status.

## Sources
- https://7amleh.org/post/1227 ; https://7amleh.org/post/privacy-and-personal-data-protection-in-palestine
- https://security-legislation.ps/?p=12552
- https://ps.andersen.com/publications/804.html
- https://dti.eui.eu/database/page/107/
- https://www.omanobserver.om/article/1108506/world/region/palestinians-urge-paypal-to-offer-services-in-west-bank-and-gaza
- https://www.noonpost.com/en/363532/amp/
- https://www.doola.com/stripe-guide/how-to-open-a-stripe-account-in-palestine/
- https://www.arabnews.com/node/2628443/ ; https://www.timesofisrael.com/months-after-4g-service-okayed-plodding-talks-keep-palestinian-networks-throttled/
