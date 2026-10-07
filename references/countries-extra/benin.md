# Benin (researched 2026-10-07, by Claude Opus 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Med for a small foreign-run app: GDPR-style law that reaches foreign apps, parent consent under 16, and foreign digital VAT with no threshold.
Marks: [V-reg] regulator/official text, [V-sec] law firm/news/tax vendor, [K] memory.
Note: the law text read is a copy of the original Digital Code (Law 2017-20, 2018 PDF). Book V (data) was revised by Law 2020-35, so article numbers may have moved. apdp.bj was not read.

## Privacy
- [V-sec] Digital Code (Law 2017-20 of 20 Apr 2018, Book V on personal data, amended by Law 2020-35 of 6 Jan 2021). Regulator: APDP (Autorité de Protection des Données Personnelles). (DLA Piper)
- [V-reg] Reaches foreign developers: Book V applies to a controller or processor not established in Benin when the processing is linked to offering goods or services to people in Benin (paid or free) or to monitoring their behaviour there. (Code du numérique text)
- [V-reg] Children: art. 446 (2018 text): for online services offered directly to minors, processing is lawful from age 16; under 16 a parent must give or authorise consent, and the controller must make reasonable efforts to check. A "minor" is anyone under 18.
- [V-sec] Processing must be declared to the APDP before it starts (art. 405), or listed in a register kept by a designated person; controllers keep a records register (art. 435, some SMEs exempt) and file an annual compliance report. (DLA Piper)
- [V-sec] Breach: notify the APDP "without delay" (art. 427); no fixed hours. (DLA Piper)
- [V-sec] Transfers abroad: allowed to countries with adequate protection; otherwise APDP can approve with safeguards (contract clauses, internal rules). (DLA Piper)
- [V-sec] Fines up to XOF 50M (first breach), up to XOF 100M or 5% of turnover for repeats; enforcement is described as low in practice. (DLA Piper)
- [K] Cookies: no dedicated cookie article found in the text search; use the GDPR-style consent approach.

## Kids and games
- [K] No game-time, social-media age or loot-box law found. Gambling is state-licensed; avoid cash-out prizes.

## Selling
- [V-reg] Anyone running e-commerce in Benin or aimed at it must show, easily and permanently (e.g. from the home page): name/company name, email and phone, registered office, and more (art. 328). Use a Merchant of Record so you don't publish a home address.
- [V-reg] Right of withdrawal for business-to-consumer distance contracts (arts. 347-351); extended to 90 days if the pre-contract information was not given; refund within 30 working days. The base number of days did not extract cleanly from the PDF. (Code du numérique text)
- [V-sec] VAT 18%: Circular No. 0426/DC/SGM/DGI/DLC/DCFR of 14 Apr 2023 makes non-resident sellers of digital services to consumers register and charge VAT, whatever the sales amount (no threshold). (PayPro Global, vatcalc table "Oct 2023")
- [V-sec] Law 2026-10 (in force 24 Jun 2026) adds platform rules: platform services count as supplied in Benin when the customer is resident there; 12% withholding on accommodation bookings. It does not create a new VAT regime. (KPMG)
- [V-sec] Stripe Tax added Benin in 2025 (tax calculation only, not payouts). (Condia)
- [K] Stripe does not onboard sellers based in Benin; mobile money (MTN, Moov) dominates local payments.

## AI, content and platforms
- [V-sec] National AI and Big Data Strategy (SNIAM) 2023-2027; no AI law. 2026: shared AI ethics guidelines with five other francophone countries (Niyel initiative, non-binding). (WeAreTech, Droit Media Finance)
- [V-reg] Hosting safe harbour: a host is not liable for users' content if it acts promptly once it knows it is illegal (art. 506 on hosting); art. 498 lists what a takedown notice must contain. Have a report button and act fast.

## What a small foreign dev should consider
- Treat it like GDPR: privacy policy (French), consent, deletion route, and parent consent or an age gate under 16.
- Selling to people in Benin: 18% VAT from the first sale. Use a Merchant of Record or app stores.
- Show contact details on the site (via MoR or business email, not a home address).
- Moderate user content and handle takedown notices quickly.

## Upcoming
- [V-sec] ECOWAS experts validated a revised Supplementary Act on personal data (Nov 2024); not yet adopted as far as found. (ECOWAS)

## Unverified
- Article numbers after the 2021 revision; base withdrawal period; whether APDP expects declarations from foreign apps; any APDP cookie guidance.

## Sources
- https://www.dlapiperdataprotection.com/?c=BJ&t=law
- https://database.cyberpolicyportal.org/api/files/1663679910216euq2m15qn6f.pdf (Code du numérique, Law 2017-20)
- https://payproglobal.com/fr/taxe-de-vente-saas/benin/
- https://www.vatcalc.com/global/global-vat-and-gst-on-digital-services-to-consumers/
- https://kpmg.com/us/en/taxnewsflash/news/2026/08/benin-vat-rules-withholding-obligation-digital-platforms.html
- https://cio-mag.com/comprendre-la-taxation-du-commerce-electronique-au-benin/
- https://thecondia.com/stripe-africa-payments-tax-2025/
- https://www.wearetech.africa/fr/fils/breves/le-benin-se-dote-dune-strategie-quinquennale-dintelligence-artificielle-et-des-megadonnees
- https://www.wearetech.africa/fr/fils/actualites/gestion-publique/six-pays-d-afrique-de-l-ouest-adoptent-des-lignes-directrices-communes-sur-l-ia
- https://ecowas.int/member-states-experts-validate-the-revised-supplementary-act-a-sa-1-01-10-on-personal-data-protection-within-ecowas/
