# Djibouti (researched 2026-10-07, by Claude Opus 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Med on paper (GDPR-style law that reaches foreign apps), Low in practice (law adopted June 2025, promulgation not confirmed, regulator not set up).
Marks: [V-reg] regulator/official text, [V-sec] law firm/news/tax vendor, [K] memory.

## Privacy
- [V-sec] Digital Code (Code du numérique), Book I = personal data protection. Adopted by the National Assembly 30 Jun 2025 (some reports say 1 Jul). Jones Day (who drafted it) said it still had to be promulgated by the President and published in the Journal Officiel; no source found confirming either step (Jones Day, Ecofin, Digital Business Africa).
- [V-sec] Reach: applies to controllers/processors outside Djibouti that offer goods or services to people in Djibouti or monitor their behaviour there; non-established controllers may need a local representative (TechHive Advisory, ConsentStack).
- [V-sec] Tiered filing: declaration for normal processing, simplified declaration for common low-risk processing, prior authorisation from the regulator for high-risk processing (biometrics, genetic data, offences, national ID number). Appointing a DPO can exempt you, except for international transfers (TechHive).
- [V-sec] Breach: notify the regulator within 72 hours unless unlikely to cause risk; tell users without undue delay if high risk (TechHive, ConsentStack).
- [V-sec] Transfers abroad: only to countries/organisations the regulator finds adequate, under listed exceptions, or with authorised safeguards. No localisation rule reported (TechHive).
- [V-sec] Regulator: Commission Nationale de Protection des Données à Caractère Personnel (CNDP), listed as "not yet established" (MoFo privacy library, TechHive, ConsentStack).
- [V-sec] Fines up to DJF 70M or 5% of global turnover; criminal penalties up to 10 years for serious cases (TechHive; figures differ between sources).
- [V-sec] Absolute right to object to direct marketing (TechHive).
- [K] No cookie-specific rule found.

## Kids and games
- [V-sec] The Code has provisions on minors' data (at least in research contexts), but no source gives an age for consent (TechHive). Treat under-18s as needing parent consent until the text is checked.
- [K] Age of majority 18. No loot-box or game-time law found.

## Selling
- [V-sec] Digital Code covers e-commerce and electronic contracts; details (seller info, withdrawal right) not found (Jones Day).
- [K] Standard VAT (TVA) 10%. No specific VAT regime for foreign digital services found; only a generic tax-rate aggregator says foreign sellers "often" must register (not reliable).
- [V-sec] PayPal lists Djibouti as a PayPal country (paypal.com country list). Djibouti is not on Stripe's prohibited-jurisdiction list (stripe.com restricted businesses). [K] Stripe doesn't onboard Djibouti-based merchants.

## Sanctions
- [K] No UN, US, EU or UK country sanctions on Djibouti. Normal screening only (don't deal with listed people). Nothing in `sanctioned-places.md` applies to ordinary users here.

## AI, content and platforms
- [K] No AI law. [V-sec] The Code regulates online service providers and hosts and defines cyber offences (Jones Day); details not found.

## What a small foreign dev should consider
- A GDPR-style privacy policy and data-subject rights process covers you if the Code comes into force.
- 72-hour breach plan.
- Parent consent (or block) for under-18s until the age in the Code is known.
- If you target Djibouti specifically, watch for the CNDP being set up (declarations, local representative).

## Upcoming
- [V-sec] Promulgation and Journal Officiel publication of the Digital Code; implementing decrees; CNDP creation (no dates).

## Unverified
- Whether the Code has been promulgated and is in force; law number; children's consent age; e-commerce/withdrawal rules; digital VAT for foreign sellers.

## Sources
- https://www.jonesday.com/en/insights/2025/07/national-assembly-of-the-republic-of-djibouti-approves-digital-code
- https://www.techhiveadvisory.africa/insights/review-of-djiboutis-data-protection-law
- https://www.consentstack.io/regulations/dj-digital-code
- https://www.mofo.com/privacy-library/djibouti
- https://www.ecofinagency.com/news-digital/0107-47508-djibouti-introduces-digital-code-to-structure-its-digital-ecosystem
- https://www.digitalbusiness.africa/djibouti-la-ministre-mariam-hamadou-ali-celebree-suite-a-ladoption-du-code-du-numerique/
- https://www.paypal.com/us/webapps/mpp/country-worldwide ; https://stripe.com/legal/restricted-businesses
