# Central African Republic (researched 2026-10-07, by Claude Opus 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Low for a small foreign-run app: the law reaches foreign apps on paper, but no data authority exists yet. Sanctions are targeted only (screen names, not the country).
Marks: [V-reg] regulator/official text, [V-sec] law firm/news/tax vendor, [K] memory. The law text was read from a scanned PDF on the telecoms regulator's site (ARCEP-CF); OCR was imperfect. press.un.org failed to load.

## Privacy
- [V-reg] Law No. 24.001 on the protection of personal data, promulgated by President Touadéra, "takes effect from its promulgation" (final article). Exact date not legible; Tech Hive says January 2024 [V-sec].
- [V-reg] Applies to processing by an establishment in CAR, and to processing "qui déploie des effets en République Centrafricaine", even by a controller located abroad. So a foreign app with CAR users is in scope on paper.
- [V-reg] Every controller must appoint a data protection officer (Art. 38), and only people resident in CAR can be appointed. [K] Impractical for a foreign solo dev; no sign it is enforced.
- [V-reg] Transfers abroad need a similar level of protection; derogations for consent, contract, vital interest etc.; the authority can authorise transfers with safeguards. CEMAC/ECCAS transfers have their own conditions (Tech Hive [V-sec]).
- [V-reg] Administrative fines up to 5% of annual turnover; criminal fines from XAF 100,000 up to XAF 10 million.
- [V-reg] The digital-economy ministry had 12 months from promulgation to set up the data authority; until then the ministry does its job. [V-sec] Tech Hive describes the authority as not yet established; no newer news found.
- [V-sec] Breach: controller must notify the authority; no deadline stated (Tech Hive).

## Kids and games
- [V-reg] Where consent is the basis and the person is a minor, a parent must give or authorise consent, including for online services offered directly to children. No age given. [K] Civil majority is 18, so treat under-18s as minors.
- [K] No loot-box or game-time law found.

## Selling
- [V-sec] No VAT rule for foreign digital sellers found. Standard VAT reported as 19% (taxratesbycountry, aggregator only).
- [K] CAR is a CEMAC member; neighbours (Cameroon, Chad, Congo, Gabon) now tax foreign digital sales, so a CAR rule may follow.
- [K] Card payments and Stripe-style checkout are rare; very few paying users are likely.

## Sanctions
- [V-sec] UN: the 2745 regime (arms embargo on armed groups, travel ban, asset freeze on listed people) was renewed unanimously on 29 Jul 2026 to 31 Jul 2027; Panel of Experts to 31 Aug 2027 (Security Council Report, Africanews).
- [V-reg] US: OFAC CAR program, EO 13667 (2014) and 31 CFR Part 553, blocks listed persons. It is not a country-wide embargo.
- [V-sec] UK: Central African Republic (Sanctions) (EU Exit) Regulations 2020, asset freezes on designated persons; 2025 amendment reportedly lifted the arms embargo; guidance updated 18 Mar 2026 (GlobalSanctions). EU: targeted restrictive measures too.
- What it means: selling to ordinary people in CAR is allowed. Don't deal with anyone on the SDN/UK/EU lists; Stripe Radar and app stores screen this. See `sanctioned-places.md` for screening basics (CAR is not comprehensively sanctioned).

## AI, content and platforms
- [K] No AI law found.

## What a small foreign dev should consider
- French privacy notice, consent, deletion route; parent consent (or block) under 18.
- Know the law claims reach and wants a CAR-resident DPO; low practical risk until the authority exists.
- Sanctions: list-screening via your payment provider is enough; no geo-block needed.

## Upcoming
- [K] Creation of the data protection authority (12-month deadline from promulgation has passed): no date.
- [V-sec] UN sanctions renewal due by 31 Jul 2027.

## Unverified
- Exact promulgation date; whether the authority exists now; breach deadline; any digital VAT rule; EU designation count.

## Sources
- https://arcep.cf/documents/textes/lois/Loi_24_001_portant_protection_des_donnes_a_caractere_personnel.PDF
- https://www.techhiveadvisory.africa/insights/review-of-the-central-african-republic-data-protection-law
- https://taxratesbycountry.com/fr/vat-rate-central-african-republic/
- https://www.securitycouncilreport.org/whatsinblue/2026/07/central-african-republic-vote-on-a-draft-resolution-extending-the-2745-sanctions-regime-2.php
- https://africanews.com/2026/07/29/united-nations-extends-sanctions-against-armed-groups-in-central-african-republic
- https://ofac.treasury.gov/sanctions-programs-and-country-information/central-african-republic-sanctions
- https://mf.globalsanctions.com/2026/03/uk-updates-central-african-republic-sanctions-guidance/
- https://mf.globalsanctions.com/2025/12/uk-amends-central-african-republic-sanctions-regulations-to-lift-arms-embargo/
