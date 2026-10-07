# Botswana (researched 2026-10-07, by Claude Opus 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Med on paper (new GDPR-style law reaches foreign apps, "keep a copy in Botswana" rule), Low in practice for a tiny foreign app (regulator still building up; VAT has a P500,000 threshold).
Marks: [V-reg] regulator/official text, [V-sec] law firm/news/tax vendor, [K] memory.

## Privacy
- [V-sec] Data Protection Act 2024 (Act No. 18 of 2024) replaced the 2018 Act. Passed 29 Oct 2024; in force 14 Jan 2025 per most sources (DLA Piper says 29 Oct 2024). Regulator: Information and Data Protection Commission (IDPC) (Michalsons, IFEX/MISA, DLA Piper).
- [V-sec] Reaches foreign controllers/processors that offer goods or services to people in Botswana or monitor their behaviour there. Most must appoint a written representative in Botswana; exception for occasional, non-large-scale processing (TechHive Advisory, Strathmore CIPIT).
- [V-sec] Children (under 18 under the Children's Act): parent/guardian consent for information society services; a 16-year-old may consent alone. Make reasonable efforts to verify (TechHive; a s.29-based privacy notice says the same).
- [V-sec] Breach: tell the Commission within 72 hours where feasible; users without undue delay if risky (DLA Piper, TechHive).
- [V-sec] Transfers abroad: only to adequate countries (a 2022 list of 45 countries; Kenya and South Africa the only African ones) or with safeguards/derogations (consent, contract). A copy of transferred data must be kept in Botswana ("soft localisation") (TechHive; second summary in search). DLA Piper describes transfers to non-designated countries as needing prior Commissioner authorisation.
- [V-sec] Controllers notify the Commissioner before automated processing unless they appointed a data protection representative (DLA Piper).
- [V-sec] Fines up to BWP 50M (TechHive); criminal penalties up to BWP 500,000 / 9 years for security failures (DLA Piper).
- [K] No separate cookie law; consent rules apply to tracking.

## Kids and games
- [K] No loot-box or game-time law found. Gambling is licensed (Gambling Authority); no cash-out items.

## Selling
- [V-sec] VAT (Amendment) Act 2025 + Statutory Instrument No. 74 of 2026: non-resident B2C digital/remote services, 14%. Register if supplies to Botswana residents exceed P500,000 (about US$35,000) in 12 months. Registration from 1 Jun 2026, charging from 1 Oct 2026. B2B = reverse charge (VATCalc, PwC Botswana, LookupTax).
- [V-sec] A local agent/representative may be needed (VATCalc, PwC).
- Practical: below P500,000 a small app owes nothing; a Merchant of Record handles it anyway.
- [K] Consumer Protection Act 2018 and the Electronic Communications and Transactions Act 2014 include e-commerce consumer rules; the cooling-off period could not be confirmed (search only found South Africa's 7-day rule).

## AI, content and platforms
- [K] No AI law found.

## What a small foreign dev should consider
- Parent consent (or block) under 16.
- 72-hour breach plan.
- If you really target Botswana: representative, and note the "keep a copy in Botswana" transfer rule.
- VAT only above P500,000/year; use a Merchant of Record to be safe.

## Upcoming
- [V-sec] Digital-services VAT charging starts 1 Oct 2026 (just passed at research date; actual collection not confirmed).

## Unverified
- Exact in-force date of the 2024 Act and any grace period (a Michalsons article mentions a grace-period extension; page didn't load).
- Exact section numbers; children's age wording; whether the local-copy rule applies to all transfers.
- VAT return frequency (quarterly vs monthly); consumer cooling-off period; IDPC site (idpc.org.bw) not found in search.

## Sources
- https://www.dlapiperdataprotection.com/?c=BW&t=law
- https://www.techhiveadvisory.africa/insights/understanding-botswanas-new-data-protection-act-key-updates-and-changes
- https://cipit.strathmore.edu/understanding-botswanas-2018-and-2024-data-protection-acts/
- https://www.michalsons.com/blog/botswanas-data-protection-act-grace-period-extended/60775
- https://misa.org/blog/new-botswana-data-protection-act-progressive-step-to-a-more-secure-digital-environment/
- https://www.kfcbotswana.com/en/Botswana-Privacy-Addendum
- https://vatcalc.com/botswana/botswana-vat-on-non-resident-digital-services
- https://www.pwc.com/bw/en/assets/pdf/tax-alert-vat-on-remote-services.pdf
- https://lookuptax.com/tax-changes/botswana/remote-services-vat-si-74-2026
