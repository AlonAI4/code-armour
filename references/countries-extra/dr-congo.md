# DR Congo (researched 2026-10-07, by Claude Opus 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Med on paper (data must be stored in the DRC unless the authority approves; declaration duty), Low in practice (the data protection authority still doesn't exist; no enforcement known).
Marks: [V-reg] regulator/official text, [V-sec] law firm/news/tax vendor, [K] memory.

## Privacy
- [V-sec] Code du numérique (Ordonnance-loi n° 23/010 of 13 Mar 2023), Book on personal data. Most implementing decrees not issued (DLA Piper, updated Feb 2026).
- [V-sec] The Autorité de protection des données (APD) is not set up (needs a Prime Minister's decree, art. 262). A ministerial decree of 17 Aug 2024 handed its tasks to the telecom regulator ARPTC/ARPTIC "temporarily"; many lawyers call this illegal (DLA Piper, droitnumerique.cd May 2026).
- [V-sec] Art. 186: processing needs a prior declaration to the APD; art. 189 exempts e.g. household use and controllers that appoint a DPO (unless transferring data). Authorisation needed for sensitive data and transfers to third countries. Not followed in practice (Code text via droitnumerique.cd; DLA Piper).
- [V-sec] Consent: processing is in principle allowed only with prior, explicit, provable consent (DLA Piper).
- [V-sec] Art. 201 (localisation): personal data "are stored and/or hosted" in the DRC; transfer to a host abroad only where the APD finds the country gives adequate protection (Code text). With no APD, nobody can grant that today. DLA Piper reads the transfer rule more softly and doesn't mention localisation.
- [V-sec] Children, art. 247: for information society services offered directly to minors, processing is lawful only with consent from the holder of parental responsibility, verified with available technology. No lower age (like 13/16) is given (Code text).
- [K] Minor = under 18 (Loi portant protection de l'enfant 2009).
- [V-sec] Breach: DPO notifies the APD "without delay"; no working procedure (DLA Piper).
- [V-sec] APD fines USD 3,000-70,000; no enforcement cases known (DLA Piper).
- [K] No specific cookie rule found.

## Kids and games
- [V-sec] 28 Sep 2026: the Senate declared admissible a bill amending the Code to ban under-13s from opening social accounts or using interactive social features (single source: Osiris, 30 Sep 2026). Not law.
- [K] No loot-box law. Gambling is licensed; no cash-out items.

## Selling
- [V-sec] No dedicated VAT regime for foreign digital services found; standard VAT 16%; general non-resident rule (Ordonnance-loi 10/001, art. 23); B2B usually reverse charge (Copeps, Kintsugi; both tax vendors).
- [K] Consumer protection law: Loi n° 18/035 of 13 Dec 2018. Online cooling-off rules not confirmed.
- [V-sec] Code art. 294: sellers of ICT products/services must get a ministry certificate of conformity (Code text). Aimed at local suppliers; unclear for foreign web apps.

## AI, content and platforms
- [K] No AI law.
- [V-sec] Code art. 293: hosts are liable for stored content once aware of it unless they act fast; courts can order sites blocked (Code text). Harsh cybercrime penalties: moderate user content.

## What a small foreign dev should consider
- Get parent consent (or block) for minors; the Code gives no age below 18.
- Know the "store in the DRC" rule exists; with no APD it can't be complied with properly. Low enforcement risk for a tiny app.
- Moderate user content; have a take-down contact.
- No digital VAT for foreign sellers found; a Merchant of Record covers you if that changes.

## Upcoming
- [V-sec] APD creation decree (no date).
- [V-sec] Under-13 social media bill (admitted by Senate 28 Sep 2026).

## Unverified
- Whether the Code's data book reaches foreign controllers with no local presence (scope article not found in the text read).
- The Code text read is the copy on droitnumerique.cd (a law commentary site), not the Journal officiel.
- Digital-services VAT (only vendor sources); consumer rules for online sales; Prof. Ndukuma's slides say art. 192 lets minors consent through the legal incapacity regime (not checked).

## Sources
- https://www.dlapiperdataprotection.com/?c=CD&t=law
- https://droitnumerique.cd/wp-content/uploads/2024/08/Code-du-numerique-I-RD-Congo.pdf (Code text)
- https://droitnumerique.cd/wp-content/uploads/2026/05/Illegalite-de-la-decision-de-lARPTC-Brozeck-Kandolo-1.pdf
- https://kodjondukuma.com/assets/docs/tribunes/Presentation2.pdf
- https://www.osiris.sn/rdc-le-senat-propose-d-interdire-les-reseaux-sociaux-aux-moins-de-13-ans.html
- https://copeps.fr/actualites/taux-tva-rdc/
- https://trykintsugi.com/sales-tax-guides/africa/democratic-republic-of-congo
