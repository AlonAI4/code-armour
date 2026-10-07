# Kosovo (researched 2026-10-07, by Claude Opus 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Low for privacy (weak reach to foreign apps, rare enforcement). Med on paper for paid sales, because VAT applies from the first sale with no threshold.
Marks: [V-reg] regulator/official text, [V-sec] law firm/news/tax vendor, [K] memory.

## Privacy
- [V-sec] Law No. 06/L-082 on Protection of Personal Data, in force since 13 Feb 2019. It copies most of the GDPR. Regulator: Information and Privacy Agency (IPA / AIP) (DLA Piper).
- [V-sec] Reach: it applies to controllers outside Kosovo only if they use "equipment" in Kosovo (not just transit). This is the old EU-1995-style test, so it is weaker than the GDPR's "offering services to people there" test. Covered foreign controllers must name a representative registered in Kosovo (DLA Piper; search summary of Art. 2(3)).
- [V-sec] No general registration with the IPA. Notification is needed only in special cases, e.g. high-risk processing after a DPIA or biometrics.
- [V-sec] Children: one source says users under 16 of "information society services" need a guardian's consent (Global Child Exploitation Policy summary). The official article text could not be read (PDF unreadable). Treat 16 as likely, not confirmed.
- [V-sec] Breach: tell the IPA within 72 hours; tell users without undue delay if the risk is high.
- [V-sec] Transfers: no IPA authorisation needed to EU/EEA countries or countries the EU has found adequate (DLA Piper lists UK, Japan, US). Other countries are assessed case by case. No localisation rule found.
- [V-sec] Fines EUR 20,000-40,000, or 2% of global turnover for companies for serious breaches. Sources disagree on the exact cap.
- [V-sec] Cookies: no dedicated cookie law. Online identifiers count as personal data, so consent or another legal basis is still needed (DLA Piper).
- [K] EU adequacy: Kosovo has none.

## Kids and games
- [K] No loot-box, game-time or social-media age law found. Gambling is licensed; avoid cash-out prizes.

## Selling
- [V-sec] VAT 18%. Foreign sellers of digital services to consumers in Kosovo must register from the first B2C sale, with no threshold. B2B is reverse charge (Anrok, Quaderno, PayPro Global).
- [V-sec] On 30 Jul 2025 the Tax Administration (ATK) reportedly issued a clarification: B2C digital services by non-residents are taxed in Kosovo. Non-residents appoint a tax representative and register within 5 days of that appointment. One secondary source only.
- [K] Consumer Protection Law No. 06/L-034 (2018) is EU-modelled, so expect a 14-day withdrawal right for online sales. A new consumer law was drafted in 2023; its status is unknown.
- Practical: use a Merchant of Record (Paddle, Lemon Squeezy) if you sell to people in Kosovo.

## AI, content and platforms
- [V-reg] No AI law, no national AI strategy and no AI authority yet. The government's EU AI Act readiness assessment (June 2026) proposes phased alignment with the EU AI Act (kryeministri.rks-gov.net).

## What a small foreign dev should consider
- Follow your GDPR-style basics: privacy policy, consent for non-essential cookies, 72-hour breach plan.
- Ask for parent consent (or block sign-up) under 16.
- For paid sales, a Merchant of Record handles the "VAT from sale 1" rule.

## Upcoming
- [V-reg] AI law expected to follow the EU AI Act; no date yet.

## Unverified
- Exact text and age in the child-consent article of 06/L-082; the fine cap; the withdrawal period and digital-content exception in 06/L-034 or its replacement; the text of the July 2025 VAT clarification.

## Sources
- https://www.dlapiperdataprotection.com/?c=XK&t=law
- https://www.globalchildexploitationpolicy.org/content/dam/gpp/legal-research/Kosovo%20-%20Legal%20Research.pdf
- https://www.anrok.com/vat-software-digital-services/kosovo
- https://quaderno.io/guides/kosovo/vat/
- https://payproglobal.com/saas-sales-tax/kosovo/
- https://kryeministri.rks-gov.net/wp-content/uploads/2026/06/EU-AI-Act-Readiness-Assessment-Republic-of-Kosovo_ENG.docx
- Blocked/unreadable: the law PDF on dataguidance.com was fetched but its text could not be extracted.
