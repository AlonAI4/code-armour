# Burkina Faso (researched 2026-10-07, by Claude Opus 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Med on paper (2021 law covers foreign controllers; digital VAT since 2025), Low in practice for a tiny foreign app (regulator enforcement is light).
Marks: [V-reg] regulator/official text, [V-sec] law firm/news/tax vendor, [K] memory.
Note: law text read from the National Assembly PDF (assembleenationale.bf), but the text layer was patchy, so some articles are only partly read. cil.bf and dgi.bf were not read.

## Privacy
- [V-reg] Law No. 001-2021/AN on protection of persons with regard to personal data processing, adopted 30 Mar 2021; replaces Law 010-2004/AN. Regulator: CIL (Commission de l'Informatique et des Libertés). (Assemblée nationale, DLA Piper)
- [V-reg] Reach: art. 3 covers controllers established in Burkina Faso and also names controllers and processors not established there (the exact trigger wording did not extract cleanly; likely GDPR-style targeting).
- [V-reg] Direct marketing using personal data needs prior consent (art. 14). [K] Treat cookies and trackers the same way: ask first.
- [V-sec] Declaration to, or authorisation from, the CIL depending on the processing; simplified declaration for processing that meets a CIL standard. A controller abroad needs a local representative for some declarations. (DLA Piper)
- [V-sec] Transfers abroad need CIL authorisation, contract clauses on confidentiality and reversibility, and an adequate destination (art. 42). (DLA Piper)
- [V-sec] No general breach-notification duty. (DLA Piper)
- [V-sec] Fines XOF 5M-100M, or 1% of turnover (first) / 5% (repeat). (DLA Piper)
- [V-sec] Enforcement by the CIL is described as nascent. (law.ungovr.org)
- [V-reg] Minors: parents or legal guardian exercise a minor's rights (seen in the rights section). No age for a child's own consent found.

## Kids and games
- [K] No game-time, social-age or loot-box law found. Gambling is state-run (LONAB); avoid cash-out prizes.

## Selling
- [V-sec] 2025 Finance Act (adopted 23 Dec 2024), from 1 Jan 2025: sales of goods and services through e-commerce platforms, including by foreign digital providers (streaming etc.), are subject to VAT. (L'Économiste du Faso, Osiris, vatupdate)
- [V-sec] Rate conflict: vatcalc says 10% and a local resident agent/representative is required; local press says the General Tax Code rate of 18% applies. Treat as 18% until confirmed. Practical rules for foreign firms were not published as of the sources. (vatcalc, Osiris)
- [V-sec] Stripe Tax added Burkina Faso in 2025 (tax calculation only). (Condia)
- [K] Stripe does not onboard sellers in Burkina Faso; mobile money (Orange Money, Moov) dominates.

## AI, content and platforms
- [V-sec] No AI law or national AI strategy found; Burkina is among six francophone countries that adopted shared non-binding AI ethics guidelines in Jul 2026. (WeAreTech)
- [K] The military government has suspended foreign media and restricted social networks at times; moderate political content and expect possible blocking.

## Sanctions and regional blocs
- [K] No US, EU or UN country-wide sanctions on Burkina Faso; it is not in sanctioned-places.md. Normal SDN list screening (done by Stripe/MoR) is enough.
- [V-sec] Burkina Faso, Mali and Niger formed the Alliance of Sahel States (AES) and announced their exit from ECOWAS (Jan 2024). They remain in UEMOA and keep the CFA franc (BCEAO says no exit process). So ECOWAS data rules may no longer bind it; UEMOA monetary/banking rules still do. (Le360, Seneweb)
- [K] Card payments from Burkina Faso often fail fraud checks; local buyers mostly use mobile money.

## What a small foreign dev should consider
- French privacy policy, consent before marketing and trackers, deletion route; parent consent for kids.
- Selling to people there: VAT has applied since 2025 with unclear mechanics. Use a Merchant of Record or app stores.
- Don't store more than you need; transfers abroad technically need CIL authorisation (low risk for a tiny app, but true).

## Upcoming
- [V-sec] Implementation guidelines for the e-commerce VAT were expected; none found. (vatupdate)

## Unverified
- VAT rate (10% vs 18%) and representative rule; exact wording of art. 3 reach; any children's consent age; cookie-specific rules.

## Sources
- https://assembleenationale.bf/storage/Loi/kDsWHXOTUCQFVESChh8BlBdiZnCrdTsOpXe1rzmH.pdf (Law 001-2021/AN)
- https://www.dlapiperdataprotection.com/?c=BF&t=law
- https://law.ungovr.org/ai/bf
- https://leconomistedufaso.com/2024/12/30/loi-de-finances-2025-les-nouvelles-dispositions-fiscales/
- https://osiris.sn/le-burkina-faso-taxe-l-e-commerce-pour-accroitre-ses-recettes-budgetaires.html
- https://www.vatupdate.com/2025/03/23/burkina-faso-introduces-vat-on-digital-services-in-2025-finance-act/
- https://www.vatcalc.com/burkina-faso/botswana-vat-digital-services-sept-2025/
- https://thecondia.com/stripe-africa-payments-tax-2025/
- https://www.wearetech.africa/fr/fils/actualites/gestion-publique/six-pays-d-afrique-de-l-ouest-adoptent-des-lignes-directrices-communes-sur-l-ia
- https://afrique.le360.ma/economie/apres-la-sortie-de-la-cedeao-lalliance-des-etats-du-sahel-face-a-lequation-a-plusieurs-inconnues-de_M7LPAAXJXRDZBI7SJ7DFAKFLUM/
- https://www.seneweb.com/fr/news/Economie/sortie-du-franc-cfa-les-revelations-du-gouverneur-de-la-bceao-sur-les-etats-de-laes_n_466551.html
