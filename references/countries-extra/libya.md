# Libya (researched 2026-10-07, by Claude Opus 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Low (no comprehensive privacy law; sanctions are targeted; payments mostly don't work). Harsh cybercrime law for content.
Marks: [V-reg] regulator/official text, [V-sec] law firm/news/tax vendor, [K] memory.

## Privacy
- [V-sec] No comprehensive data protection law and no regulator. A law is only a draft/project; Council of Europe ran a workshop with the Libyan parliament (Oct 2023) toward Convention 108+ alignment (DataGuidance, Chambers 2025, Council of Europe).
- [V-sec] Law No. 6 of 2022 on Electronic Transactions, Ch. 7 (Arts. 73-79): data protection basics, mainly explicit consent for collecting and using data (DLA Piper; aimed at e-transactions/certificate providers).
- [V-sec] Central Bank Circular No. 18 of 2025: data protection rules for banks only (Libyan Law Society listing).
- [K] No cookie, breach or transfer rules.

## Kids and games
- [V-sec] Age of majority 18 (Law No. 17 of 1992, Art. 9; Libyan Law Society). No online-age or children's data rule found.
- [K] Gambling is banned: no betting or cash-out items.

## Selling
- [V-sec] Consumer protection sits in Commercial Law No. 23 of 2010 (Arts. 1308-1327); executive regulations Resolution 6/2024. Clauses that exclude the seller's liability to consumers are banned (UN ESCWA). No online cooling-off rule found.
- [V-sec] No confirmed VAT; a 2016-17 tax guide says Libya has no VAT, an aggregator claims 20% (unreliable). No digital-services tax for foreign sellers found.
- [V-sec] PayPal does NOT list Libya as a PayPal country (paypal.com). Not on Stripe's prohibited-jurisdiction list (stripe.com). [K] Libyan cards rarely work abroad; currency controls.

## Sanctions (as of 2026-10-07)
- [V-sec] UN: arms embargo, targeted travel bans and asset freezes (incl. the frozen Libyan Investment Authority), and measures against illicit petroleum exports. Renewed by Res. 2819, 14 Apr 2026 (unanimous): Panel of Experts to 15 Aug 2027, petroleum measures to 1 Aug 2027 (UNSMIL, unscr.com).
- [V-reg] US: OFAC Libya program (EOs 13566, 13726; 31 CFR 570) blocks **listed** persons; latest actions were removals (30 Sep 2026, 28 May 2026) (OFAC page).
- [V-sec] EU: Reg. 2016/44 amended by Reg. 2026/1332 (12 Jun 2026) to implement Res. 2819 (Malta sanctions board). UK Libya list moved into the consolidated UK list from 28 Jan 2026 (gov.uk).
- Effect for a small app: targeted, not a broad embargo. Users in Libya can sign up for a free app; paid sales aren't banned but rarely go through. Don't deal with listed people or the frozen state funds. See `sanctioned-places.md`.

## AI, content and platforms
- [K] No AI law.
- [V-sec] Anti-Cybercrime Law No. 5 of 2022 (published 27 Sep 2022): lets the National Information Security and Safety Authority block content seen as undermining "security, stability and social peace"; reportedly criminalises some encryption use (Arts. 9, 39); used to arrest bloggers. Rights groups (HRW, Article 19, Access Now) want it repealed.

## What a small foreign dev should consider
- No real privacy law: GDPR-style basics are enough; get clear consent.
- Moderate user content; be careful with features that could get Libyan users in trouble (public posts, real names).
- Payments won't work for most users (no PayPal).
- Normal sanctions screening for business deals.

## Upcoming
- [V-sec] UN Panel interim report 15 Dec 2026; petroleum measures 1 Aug 2027; Panel mandate 15 Aug 2027.
- [V-sec] Possible personal data protection law (no date).

## Unverified
- Libya's VAT status; full text of Law 6/2022 Ch. 7; whether the encryption articles of Law 5/2022 are enforced.

## Sources
- https://www.DataGuidance.com/jurisdiction/libya
- https://www.dlapiperdataprotection.com/guide.pdf?c=LY
- https://gpg-pdf.chambers.com/doing-business-in-2025/469
- https://coe.int/en/web/data-protection/on-going-cooperation-projects/-/asset_publisher/JmAlrLQZ5INs/content/reflection-workshop-on-the-harmonisation-of-the-libyan-legislative-and-institutional-framework-with-international-standards-on-the-protection-of-personal-data
- https://lawsociety.ly/en/legislation/law-no-6-of-2022-concerning-electronic-transactions/
- https://lawsociety.ly/en/legislation/law-no-17-of-1992-regolating-of-minors-and-those-of-equivalent-status/
- https://unescwa.org/sites/default/files/inline-files/ABLF-2023-consumer-CP-Libya-english.pdf
- https://unsmil.unmissions.org/en/node/135012 ; https://unscr.com/en/resolutions/2819/
- https://ofac.treasury.gov/sanctions-programs-and-country-information/libya-sanctions
- https://www.gov.uk/guidance/libya-list-of-designations-and-sanctions-notices
- https://smb.gov.mt/category/eu-and-un-sanctions/
- https://www.hrw.org/news/2023/04/03/libya-revoke-repressive-anti-cybercrime-law ; https://www.accessnow.org/libya-anti-cybercrime-law/
- https://www.paypal.com/us/webapps/mpp/country-worldwide ; https://stripe.com/legal/restricted-businesses
