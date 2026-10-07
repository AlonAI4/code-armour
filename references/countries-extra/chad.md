# Chad (researched 2026-10-07, by Claude Opus 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Med on paper (declaration to ANSICE, VAT on foreign digital sales since 2026), Low in practice for a tiny foreign app.
Marks: [V-reg] regulator/official text, [V-sec] law firm/news/tax vendor, [K] memory. No regulator or gazette page could be read; Ministry of Finance site reported returning HTTP 503 (Lookuptax).

## Privacy
- [V-sec] Law No. 007/PR/2015 of 10 Feb 2015 on personal data protection, plus implementing Decree No. 075/PR/2019. Regulator: ANSICE (Agence Nationale de Sécurité Informatique et de Certification Électronique) (DLA Piper, Lextenso).
- [V-sec] Processing must be declared to ANSICE in writing; prior authorisation for biometric, genetic, health-research, criminal and national-ID data (DLA Piper).
- [V-sec] Transfers outside CEMAC/ECCAS need an adequate level of protection and prior notice to ANSICE, or an exception (consent, contract...) (DLA Piper).
- [V-sec] No mandatory breach notification and no DPO duty (DLA Piper, DataGuidance). Lextenso's 2020 commentary mentions notification duties, so sources conflict.
- [V-sec] Penalties: ANSICE can warn, suspend or ban processing; criminal fines XAF 1-10 million and 1-5 years' jail (Criminal Code art. 438) (DLA Piper).
- [K] Reach to foreign developers is not clearly stated in the sources found; the regime is framed around processing in Chad.
- [V-sec] A "Code du numérique" covering data protection and cybersecurity is being drafted; drafting committee installed 6 May 2026, not adopted (Osiris, Digital Business Africa).

## Kids and games
- [K] No age of digital consent found in the law. Civil majority is 18, so treat under-18s as needing a parent.
- [K] No loot-box, game-time or social-media age law found.

## Selling
- [V-sec] Finance Law 2026 (Loi n° 008/AN/SENAT/2025), in force 1 Jan 2026: VAT expressly covers digital services and e-commerce; foreign digital service providers must collect and remit VAT on sales to customers in Chad; resident and non-resident platforms collect for underlying sellers; reverse charge where the supplier isn't registered (KPMG, VATCalc, Lookuptax).
- [V-sec] Circular No. 001/MFBEPCI/2026 (20 Jan 2026): foreign operators appoint a tax representative or use simplified registration (KPMG summary).
- [V-sec] Standard rate reported as 17.5% (Comarch, Alwihda). [K] Some older sources say 18%. No threshold found: treat as from sale 1.
- [V-sec] Consumer protection: Law No. 005/PR/2015; e-transactions: Law No. 008/PR/2015 (Osiris, DLA Piper). [K] No online cooling-off period confirmed.
- [K] Stripe doesn't support sellers based in Chad; local payments are mostly mobile money (Airtel, Moov).

## AI, content and platforms
- [K] No AI law found. ANSICE has publicly warned against disinformation on social networks (Tchadinfos, Apr 2025) [V-sec].

## What a small foreign dev should consider
- French privacy notice, consent, a deletion route; parent consent (or block) under 18.
- Selling to people in Chad: use a Merchant of Record or app stores; direct sales mean Chadian VAT from 2026.
- Don't collect national ID or biometric data (needs prior ANSICE authorisation).

## Upcoming
- [V-sec] Code du numérique (data protection + cybersecurity): no adoption date.

## Unverified
- Official text of Finance Law 2026 and the VAT rate; whether the 2015 law reaches foreign controllers; breach-notice duty (sources conflict); any cooling-off right for online sales.

## Sources
- https://www.dlapiperdataprotection.com/?t=law&c=TD
- https://www.labase-lextenso.fr/l-essentiel-droits-africains-des-affaires/2020-n3/tchad-effectivite-du-regime-de-protection-des-donnees-personnelles-DAA112x7
- https://www.dataguidance.com/jurisdiction/chad
- https://osiris.sn/le-tchad-prepare-la-mise-en-oeuvre-d-un-code-du-numerique.html
- https://kpmg.com/us/en/taxnewsflash/news/2026/02/tnf-chad-direct-and-indirect-tax-changes-in-finance-law-2026.html
- https://www.vatcalc.com/chad/chad-vat-on-digital-services-extended-to-platforms/
- https://lookuptax.com/tax-changes/chad/finance-law-2026-indirect-tax-package
- https://www.comarch.com/trade-and-services/data-management/legal-regulation-changes/chad-extends-vat-obligation-to-digital-platforms-effective-january-2025/
- https://www.alwihdainfo.com/tchad-loi-de-finances-2026-une-reforme-fiscale-numerique-et-economique-de-grande-ampleur-a147103/
- https://www.osiris.sn/tchad-l-avocat-de-la-partie-civile-demande-une-astreinte-contre-les-operateurs.html
- https://tchadinfos.com/2025/04/09/lansice-met-en-garde-les-auteurs-de-la-desinformation-sur-les-reseaux-sociaux/
