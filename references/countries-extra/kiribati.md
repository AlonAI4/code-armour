# Kiribati (researched 2026-10-07, by Claude Opus 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Med on paper (new GDPR-style law that reaches foreign apps, in force since Aug 2026), Low in practice for a tiny foreign app.
Marks: [V-reg] regulator/official text, [V-sec] law firm/news/tax vendor, [K] memory.

## Privacy
- [V-reg] Data Protection Act 2025. In force 20 Aug 2026 (Minister's commencement notice under s.2, published 20 Aug 2026). Regulator: Digital Transformation Office (DTO), Ministry of Information, Communications and Transport.
- [V-reg] Reaches foreign developers: s.5(1)(b) covers processing outside Kiribati that relates to offering goods or services to, or monitoring the behaviour of, people in Kiribati.
- [V-reg] Two-year grace (to 20 Aug 2028) only for controllers domiciled, resident or operating in Kiribati that are not a "controller of major importance" (s.6(2)). A foreign app gets no grace period on the text.
- [V-reg] Children: under 18, consent comes from a parent or guardian (s.12). Exception: a child aged 13+ can consent to online services they ask for themselves (s.12(2)(c)).
- [V-reg] Breach: keep a record of every breach (s.19). Breaches likely to cause significant harm: tell the DTO and each affected person "as soon as practicable" (s.20). No fixed hour count.
- [V-reg] Transfers abroad: check the destination gives "adequate protection" (similar laws, contract clauses, etc.) (s.23-24). Not a localisation rule.
- [V-reg] Right not to be subject to a decision based solely on automated processing (s.17).
- [V-reg] DPIA submitted to the DTO only for "controllers of major importance" (in Kiribati, >10,000 Kiribati data subjects) (s.21). Not a small foreign app.
- [V-reg] Penalties: a DTO notice can order an administrative penalty up to $100,000 (s.28); ignoring a DTO notice is an offence, fine up to $100,000 and/or up to 10 years' prison (s.29). ("$" in the Act; Kiribati uses the Australian dollar.)

## Kids and games
- [K] No game-time or loot-box law found. Treat paid random items with cash-out value as gambling risk.

## Selling
- [V-sec] VAT Act 2013: 12.5% VAT; non-resident sellers of digital/electronic services to Kiribati consumers must register and collect (vatcalc, 2024). Threshold reported as AUD 100,000 (one vendor source only; see Unverified).
- [K] No general consumer refund law for online sales found. Kiribati uses the Australian dollar.
- Practical: use a Merchant of Record.

## AI, content and platforms
- [K] No AI law found. The automated-decision right in s.17 above is the only AI-adjacent rule.

## What a small foreign dev should consider
- If you target people in Kiribati, the DPA 2025 applies to you now: privacy notice, a lawful basis, user rights (access, correction, deletion).
- Parent consent under 18, except 13+ signing up for an online service themselves. Simplest: ask age and block or get parent consent under 13.
- Breach plan: notify the DTO and users as soon as practicable for harmful breaches.
- Merchant of Record for paid sales (12.5% VAT).

## Upcoming
- [V-reg] 20 Aug 2028: two-year grace ends for small controllers based in Kiribati (s.6(2)). Not relevant to foreign apps.

## Unverified
- VAT threshold (AUD 100,000) and whether non-resident VAT is actively enforced; whether the DTO has issued regulations, adequacy lists or a complaint channel; exact Act number.

## Sources
- https://www.mict.gov.ki/sites/default/files/publications/Data%20Protection%20Act%202025.pdf (Act text, read)
- https://www.president.gov.ki/images/Gazettes/2026/240826/Notice_of_Commencement_Data_Protection_Act.pdf (commencement notice, read)
- https://www.vatcalc.com/tag/kiribati/
- https://vatcalc.com/?p=38827
