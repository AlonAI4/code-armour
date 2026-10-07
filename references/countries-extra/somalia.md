# Somalia (researched 2026-10-07, by Claude Opus 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Med on paper (law reaches foreign apps that target Somalia; regulator active and registering controllers since May 2026), Low in practice for a tiny foreign app.
Marks: [V-reg] regulator/official text, [V-sec] law firm/news/tax vendor, [K] memory.

## Privacy
- [V-sec] Data Protection Act, Law No. 005 of 2023, in force 23 Mar 2023. Regulator: Somalia Data Protection Authority, officially launched Feb 2024; Implementation Regulation and DPA Guidance issued (TechHive Advisory, Wikipedia, dataprotection.africa).
- [V-sec] Reach: controllers "based or operating in Somalia", or processing that targets, monitors or offers goods/services to people in Somalia; foreign entities are covered (TechHive Arts. 4-5; dataprotection.africa).
- [V-sec] Registration: required for "data controllers of major importance" (a prescribed number of data subjects), within six months, renewed yearly (TechHive Art. 32). The Authority opened registration for public and private controllers/processors "operating in Somalia" on 31 May 2026 (Dawan Africa).
- [V-sec] DPO needed if you process data of over 1,000 people a year or regularly handle sensitive data (TechHive, DPA Guidance).
- [V-sec] Children (Art. 16): child = under 18; parent/guardian consent, but a controller may rely on the consent of a child aged 16+; the Authority may lower this to 13 by regulation (TechHive only; dataprotection.africa factsheet silent).
- [V-sec] Breach: notify the Authority within 72 hours (TechHive Arts. 25-27).
- [V-sec] Transfers abroad: adequate country, or safeguards (contract clauses, BCRs, certification), or exceptions like consent; no localisation (TechHive, dataprotection.africa).
- [V-sec] Fines exist; amounts not found.
- [K] No cookie-specific rule.

## Kids and games
- [K] No loot-box or game-time law. Gambling is banned under Islamic-law-based rules in practice: no cash-out or betting features.

## Selling
- [V-sec] Federal sales tax (5% reported for 2025-26); a 5% digital collection on local merchant accounts since Sep 2024 (Central Bank brief via vatcalc/Trading Economics). No rule for foreign digital sellers found.
- [V-sec] PayPal lists Somalia as a PayPal country (paypal.com). Not on Stripe's prohibited-jurisdiction list (stripe.com). [K] Most people pay by mobile money (EVC Plus etc.), not cards; few will pay a foreign app.
- [K] Somaliland (self-declared, separate) has its own sales tax; it isn't federal law.

## Sanctions (as of 2026-10-07)
- [V-sec] UN: the general Somalia sanctions were lifted in Dec 2023; what remains is the **Al-Shabaab** regime: arms embargo on Al-Shabaab, charcoal export ban, IED-components ban, maritime interdiction, renewed by Res. 2806 (12 Dec 2025) to 30 Nov 2026; Panel of Experts to 31 Dec 2026 (unscr.com; The EastAfrican). The government and its forces are exempt.
- [V-reg] US: OFAC Somalia program (EOs 13536, 13620; 31 CFR 551) blocks **listed** persons only; last Somalia action listed 24 May 2023 (OFAC page). [K] Al-Shabaab is also a US Foreign Terrorist Organization / SDGT.
- [K] EU and UK implement the UN Al-Shabaab measures; list-based.
- Effect for a small app: targeted, not a broad embargo. Users in Somalia can sign up and pay. Never send money to, or knowingly serve, listed people or groups. See `sanctioned-places.md`.

## AI, content and platforms
- [K] No AI law. Moderate extremist content (terrorism laws).

## What a small foreign dev should consider
- Parent consent (or block) under 16; 18 to be safe.
- 72-hour breach plan.
- If you actively target Somalia, check whether you need to register with the Authority.
- Payments: cards rare; don't rely on Somali revenue.

## Upcoming
- [V-sec] UN Al-Shabaab measures expire 30 Nov 2026 unless renewed; Panel of Experts 31 Dec 2026 (one source says 13 Jan 2027).
- [V-sec] Possible regulation lowering the child consent age to 13 (no date).

## Unverified
- Exact Art. 16 wording (official PDF is image-only, couldn't be read); registration threshold number and whether it covers foreign apps; fine amounts; foreign digital sales tax.

## Sources
- https://www.techhiveadvisory.africa/insights/review-of-somalias-data-protection-act-and-implementing-regulations
- https://dataprotection.africa/somalia/ ; https://dataprotection.africa/wp-content/uploads/Somalia_DPA.pdf (image PDF, not readable)
- https://en.wikipedia.org/wiki/Data_Protection_Act,_2023
- https://www.dawan.africa/news/somali-data-protection-authority-opens-registration-for-institutions-handling-personal-data
- https://cipit.strathmore.edu/?p=4850
- https://unscr.com/en/resolutions/2806/
- https://theeastafrican.co.ke/tea/news/east-africa/why-un-security-council-extended-sanctions-on-al-shabaab-4957580
- https://ofac.treasury.gov/sanctions-programs-and-country-information/somalia-sanctions
- https://www.vatcalc.com/somalia/somalia-split-payments-sales-tax/ ; https://tradingeconomics.com/somalia/sales-tax-rate
- https://www.paypal.com/us/webapps/mpp/country-worldwide ; https://stripe.com/legal/restricted-businesses
