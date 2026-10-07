# Niger (researched 2026-10-07, by Claude Opus 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Med on paper (19% VAT on digital platforms since Jan 2025; transfers abroad need equal protection), Low in practice for a tiny foreign app.
Marks: [V-reg] regulator/official text, [V-sec] law firm/news/tax vendor, [K] memory.
Note: no regulator or tax site read (hapdp.ne, impots.gouv.ne). KPMG's Niger alert URL now returns 404; its content was seen only as a search summary.

## Privacy
- [V-sec] Law No. 2022-59 of 16 Dec 2022 on personal data protection, amended by Law No. 2023-31 of 4 Jul 2023 (replaced Law 2017-28). Regulator: HAPDP (Haute Autorité de Protection des Données à caractère Personnel), independent but attached to the Presidency; launched Aug 2020. (DLA Piper, DataGuidance copy of Law 2023-31, dataprotection.africa)
- [V-sec] Prior notification to HAPDP, unless a data protection correspondent is appointed (still needed if data crosses borders); authorisation for genetic, medical and research data; annual report to HAPDP. (DLA Piper)
- [V-sec] Breach: tell HAPDP as soon as you know; tell people as soon as possible if risk is high (art. 83). Criminal penalties for not notifying (art. 98). (DLA Piper)
- [V-sec] Transfers only to countries with "superior or equivalent" protection (art. 62). (DLA Piper)
- [V-sec] The older law applied to foreign entities; reach of the 2022 law not stated in sources. (dataprotection.africa)
- [V-sec] No notable HAPDP enforcement decisions reported (as of Dec 2023). (DLA Piper)
- [V-sec] Children: only an erasure right for data shared while a minor is mentioned; no consent age found. (DLA Piper)

## Kids and games
- [K] No game-time, social-age or loot-box rule found. Majority is 18; get parent consent for young users.

## Selling
- [V-sec] Finance Act 2025 (published 31 Dec 2024), from 1 Jan 2025: 19% VAT on electronic services (streaming, software, e-books etc.) and online sales via local and foreign digital platforms. Circular No. 004 of 24 Jan 2025 confirmed the duties but gave few registration details. (KPMG summary, vatcalc)
- [V-sec] Draft-stage reports said no local fiscal representative, bank account or company needed, and no input-VAT deduction; not confirmed in the enacted text. (vatcalc)
- [K] Stripe does not onboard sellers in Niger; mobile money dominates. Cards from Niger often fail fraud checks.

## AI, content and platforms
- [K] No AI law or strategy found in searches; Niger is not in the 2026 francophone AI guidelines group.
- [K] The military government has suspended media and restricted platforms (e.g. TikTok) at times; moderate political content.

## Sanctions and regional blocs
- [K] No US country-wide sanctions on Niger (no OFAC Niger program); the EU created a framework for targeted Niger sanctions in Oct 2023. Niger is not in `sanctioned-places.md`; normal SDN/EU list screening by Stripe/MoR is enough.
- [V-sec] ECOWAS lifted most economic and financial sanctions on Niger on 24 Feb 2024 (border closures, central-bank asset freeze); some targeted measures reported as remaining. (Guardian NG, ICIR)
- [V-sec] Niger, Mali and Burkina Faso formed the AES and announced their exit from ECOWAS (Jan 2024); they remain in UEMOA with the CFA franc. (Le360, Seneweb)

## What a small foreign dev should consider
- French privacy policy, consent, deletion route; parent consent for kids.
- Have a breach plan: tell HAPDP straight away if Nigerien users' data leaks.
- Selling to people there: 19% VAT since 2025. Use a Merchant of Record or app stores.
- Let your payment provider screen for listed people; don't override blocks.

## Upcoming
- None dated found.

## Unverified
- Reach of Law 2022-59 to foreign apps; whether direct foreign sellers (not via a platform) must register and how; EU Niger listings in 2026; children's age.

## Sources
- https://www.dlapiperdataprotection.com/?c=NE&t=law
- https://www.dataguidance.com/sites/default/files/loi_ndeg_2023-31_modifiant_la_loi_ndeg_2022-59.pdf
- https://dataprotection.africa/niger/
- https://kpmg.com/us/en/taxnewsflash/news/2025/02/niger-vat-obligations-digital-platforms-january-1-2025.html (now 404)
- https://vatcalc.com/niger/niger-vat-on-b2c-digital-services-proposal
- https://guardian.ng/news/ecowas-lifts-economic-sanctions-on-niger-mali-burkina-faso/
- https://www.icirnigeria.org/ecowas-lifts-sanctions-on-niger-mali-burkina-faso/
- https://afrique.le360.ma/economie/apres-la-sortie-de-la-cedeao-lalliance-des-etats-du-sahel-face-a-lequation-a-plusieurs-inconnues-de_M7LPAAXJXRDZBI7SJ7DFAKFLUM/
- https://www.seneweb.com/fr/news/Economie/sortie-du-franc-cfa-les-revelations-du-gouverneur-de-la-bceao-sur-les-etats-de-laes_n_466551.html
