# Uganda (researched 2026-10-05, by Claude Opus 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Med. The regulator has said offshore companies must register, and it has acted against foreign firms (Meta/WhatsApp order).
Marks: [V-reg] regulator/official text, [V-sec] law firm/news/tax vendor, [K] memory.

## Privacy
- [V-sec] Data Protection and Privacy Act 2019 (+ Regulations 2021). Regulator: Personal Data Protection Office (PDPO, under NITA-U).
- [V-sec] 2025 PDPO decision: any entity processing data of Ugandan citizens, even abroad, must register with the PDPO and renew yearly. Fee about UGX 100,000 (~USD 30) (DLA Piper, Aug 2025).
- [V-sec] Cross-border transfers: no per-transfer approval, but keep records of the legal basis and safeguards for audits.
- [K] Children's data needs parent/guardian consent (s.8); child = under 18 in Uganda.
- [K] Breach: notify the PDPO immediately. Exact deadline not confirmed.

## Kids and games
- [K] Computer Misuse (Amendment) Act 2022 criminalises sharing info about a child without parent consent. Gambling is licensed; no cash-out items.

## Selling
- [V-sec] 18% VAT on digital services supplied by non-residents to Ugandan consumers (vatcalc). One source gives a UGX 150M registration threshold; others say none. Conflict.
- [V-sec] 5% Digital Services Tax from 1 Jul 2023; reported replaced from 1 Jul 2025 by a 15% withholding mechanism for non-registered providers (vatcalc). Check.
- Practical: a Merchant of Record removes this headache.

## AI, content and platforms
- [K] No AI law. Facebook has been blocked since 2021; the Computer Misuse Act punishes "hate speech" and misleading info, used against critics.
- [K] UCC licensing applies to online broadcasters, not small apps.

## What a small foreign dev realistically must do
- If you actively collect data from Ugandan users: consider the cheap PDPO registration.
- Parent consent for under-18 data; never post info about children without consent.
- Keep a simple record of where your data goes (Supabase/Vercel region + DPA).
- Merchant of Record for paid sales.

## Upcoming
- None dated found.

## Unverified
- VAT threshold; 2025 DST/withholding change; breach deadline; whether PDPO enforces registration on tiny foreign apps.

## Sources
- https://privacymatters.dlapiper.com/2025/08/uganda-data-protection-regulator-clarifies-compliance-requirements-for-offshore-entities/
- https://www.afriwise.com/blog/ugandas-data-protection-regulator-clarifies-compliance-requirements-for-offshore-entities
- https://ulii.org/akn/ug/act/2019/9 (law text, not read)
- https://www.vatcalc.com/uganda/uganda-non-resident-5-digital-services-tax-july-2023/
- https://kpmg.com/us/en/home/insights/2023/10/tnf-uganda-tax-authority-publishes-notice-implementing-dst.html
