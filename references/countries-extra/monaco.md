# Monaco (researched 2026-10-07, by Claude Opus 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Low-Med. The new 2024 law reaches foreign apps and has EUR 10M fines, but enforcement against a tiny foreign app is unlikely. VAT follows France: 20% from sale 1.
Marks: [V-reg] regulator/official text, [V-sec] law firm/news/tax vendor, [K] memory.

Monaco is not in the EU or EEA, but it is tied to **France**: it uses the euro and shares the French VAT system through a customs union.

## Privacy
- [V-sec] Law No. 1.565 of 3 Dec 2024 on personal data protection replaced Law 1.165 of 1993. It is GDPR-style, with 118 articles. Published 13 Dec 2024, in force the next day. Existing controllers had until 14 Dec 2025, and until Dec 2027 for impact assessments. Implementing rules: Sovereign Ordinance 11.327 (10 Jul 2025) (CMS, gouv.mc press release).
- [V-sec] Regulator: Autorité de Protection des Données Personnelles (APDP), which replaced the CCIN in 2025. Older guides that still mention the CCIN and its prior declarations are out of date.
- [V-sec] Reach: it applies to controllers abroad that offer goods or services to, or monitor, people in Monaco (CMS).
- [V-sec] Most prior declarations and authorisations are gone. Exceptions include transfers to non-adequate countries, public-space CCTV and high-risk processing.
- [V-sec] Breach: tell the APDP within 72 hours; tell users "as soon as possible" if high risk (KPMG Monaco, Art. 32+).
- [V-sec] Fines up to EUR 10M, and one source says 4% of global turnover. Some offences are criminal.
- [V-sec] Children: the government says the law "strengthens" minors' rights, but no source gave a consent age. [K] France uses 15; a Monaco age could not be confirmed.
- [V-sec] Cookies: under the old regime, CCIN Deliberation 2019-083 required a banner with real accept/refuse and no non-essential cookies before consent (DLA Piper, outdated page). Assume the APDP keeps this.
- [V-sec] EU adequacy: none yet. Monaco renewed its request in spring 2025, and the EU's 2025 tax protocol with Monaco still says it has no adequacy decision. EU apps sending data to Monaco need SCCs.

## Kids and games
- [K] Gambling is a state-granted monopoly (Société des Bains de Mer). Keep loot boxes free of cash-out.

## Selling
- [V-sec] VAT 20%, using the French rules (1963 Franco-Monegasque convention). Other EU states treat Monaco sales as French. Foreign sellers of electronic services to Monaco consumers owe 20% from the first sale; non-EU sellers register through an accredited tax representative (VATCalc, copeps.fr). [K] In practice EU OSS registrations usually treat Monaco as France; check.
- [K] Consumer rules: Monaco has its own consumer and e-commerce laws (e.g. Law 1.383 of 2011 on the digital economy), but no source confirmed a withdrawal period. Expect EU/French-style 14 days.
- Practical: Merchant of Record.

## AI, content and platforms
- [K] No AI law found. EU AI Act and DSA do not apply directly.

## What a small foreign dev should consider
- A GDPR-grade setup (consent banner, privacy policy, 72-hour breach plan) covers most of it.
- Use the stricter age (16) for parent consent until Monaco's age is confirmed.
- Merchant of Record for VAT.
- No EU adequacy: if you're EU-based and store data with a Monaco host, use SCCs.

## Upcoming
- [V-sec] EU adequacy decision pending, no date.

## Unverified
- Child consent age in Law 1.565; whether the 2019 cookie deliberation survives under the APDP; consumer withdrawal rules; how OSS handles Monaco B2C.

## Sources
- https://cms.law/en/mco/publication/the-new-monegasque-data-protection-law
- https://www.gouv.mc/en/news/monaco-adopts-personal-data-protection-legislation-in-line-with-the-highest-european-standards
- https://assets.kpmg.com/content/dam/kpmgsites/mc/pdf/newsletters/no4/KPMG-Monaco_Newsletter-2025-No4_Loi_1565_Securite_donnees_notification_violations.pdf
- https://www.dlapiperdataprotection.com/?c=MC&t=law (still describes the CCIN; partly outdated)
- https://babl.ai/monaco-modernizes-data-protection-laws-to-meet-european-standards/
- https://www.edps.europa.eu/system/files/2025-08/25-08-20_opinion_eu_monaco_financial_account_information_tax_compliance_en.pdf
- https://www.vatcalc.com/monaco/monaco-vat-on-non-resident-digital-services/
- https://copeps.fr/actualites/fiscalite-monaco-tva/
- Not found: law text on legimonaco.mc / apdp.mc (not reached by search).
