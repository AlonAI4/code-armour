# Mali (researched 2026-10-07, by Claude Opus 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Low for a small foreign-run app: old-style privacy law, no foreign digital VAT found. Watch the US list-based sanctions (screen names, not the whole country).
Marks: [V-reg] regulator/official text, [V-sec] law firm/news/tax vendor, [K] memory.
Note: apdp.ml loaded only a title (JavaScript site); dgi.gouv.ml not read. No official law text read.

## Privacy
- [V-sec] Law No. 2013-015 of 21 May 2013 on personal data protection, amended by Law 2017-070 (18 Dec 2017, regulator's workings). Regulator: APDP (Autorité de Protection des Données à caractère Personnel), working since 2016. The 2023 Constitution names data protection as a right. (dataprotection.africa, search results)
- [V-sec] Applies to processing done wholly or partly in Mali, including by foreign entities (not mere transit). (dataprotection.africa)
- [V-sec] Transfers only to countries with sufficient protection; APDP approves transfers. No breach-notification duty found. (dataprotection.africa)
- [V-sec] APDP does enforce locally: 2025 fine of XOF 5M on a Bamako clinic for blocking an inspection about undeclared CCTV. (Droit Media Finance)
- [K] Prior declaration/authorisation to APDP before processing; consent-based. No children's consent age found.

## Kids and games
- [K] No minors' data age, game-time, social-age or loot-box rule found. Majority is 18; get parent consent for young users. Gambling is state-run (PMU-Mali).

## Selling
- [V-sec] No VAT regime for foreign digital services found: not in vatcalc's global table, and searches for Finance Acts 2025/2026 found nothing. (vatcalc)
- [K] Standard VAT 18% (UEMOA). A rule could appear in any Finance Act; re-check yearly.
- [K] Stripe does not onboard sellers in Mali; buyers mostly use mobile money (Orange Money, Moov). Foreign cards from Mali often fail fraud checks.

## AI, content and platforms
- [V-sec] No AI law; Mali is in the 2026 shared non-binding francophone AI ethics guidelines. (WeAreTech)
- [V-sec] Law 2019-056 on cybercrime has content offences. (dataprotection.africa) [K] The military government has suspended media and blocked platforms; moderate political content.

## Sanctions and regional blocs
- [V-reg] US: Mali-related sanctions (EO 13882 of 26 Jul 2019, 31 CFR Part 555) block listed persons only; it is not a country-wide embargo. Latest action: designation removals on 28 May 2026. (OFAC)
- [K] EU and UN have had targeted (list-based) Mali regimes; status in 2026 not checked.
- [K] Mali is not comprehensively sanctioned and is not a "block" country in `sanctioned-places.md`. Selling to ordinary people there is allowed; your payment provider/MoR screens buyers against the SDN list. Don't deal with listed officials or groups (incl. Wagner/Africa Corps-linked entities).
- [V-sec] Mali, Burkina Faso and Niger formed the AES and announced their exit from ECOWAS (Jan 2024); they remain in UEMOA and keep the CFA franc. (Le360, Seneweb)

## What a small foreign dev should consider
- French privacy policy, consent, deletion route; parent consent for kids.
- No digital VAT to register for as of now; a Merchant of Record covers you if that changes.
- Let Stripe/MoR do sanctions screening; don't override blocks.
- Moderate user content; political speech is policed strictly.

## Upcoming
- None dated found.

## Unverified
- Regulator site and law text not read. Declaration duty for foreign apps, children's age, current EU/UN listings, whether any 2026 Finance Act adds digital VAT.

## Sources
- https://dataprotection.africa/mali/
- https://droitmediasfinance.com/index.php/actualites/droit-tech-fintech/1026-mali-lautorite-de-protection-des-donnees-a-caractere-personnel-inflige-une-sanction-pecuniaire-a-la-societe-aminata-konate-sarl-sak
- https://law.ungovr.org/ai/ml
- https://www.vatcalc.com/global/global-vat-and-gst-on-digital-services-to-consumers/
- https://ofac.treasury.gov/sanctions-programs-and-country-information/mali-related-sanctions
- https://www.wearetech.africa/fr/fils/actualites/gestion-publique/six-pays-d-afrique-de-l-ouest-adoptent-des-lignes-directrices-communes-sur-l-ia
- https://afrique.le360.ma/economie/apres-la-sortie-de-la-cedeao-lalliance-des-etats-du-sahel-face-a-lequation-a-plusieurs-inconnues-de_M7LPAAXJXRDZBI7SJ7DFAKFLUM/
- https://www.seneweb.com/fr/news/Economie/sortie-du-franc-cfa-les-revelations-du-gouverneur-de-la-bceao-sur-les-etats-de-laes_n_466551.html
