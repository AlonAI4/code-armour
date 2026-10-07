# Eswatini (researched 2026-10-07, by Claude Opus 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Med on paper (registration for every controller, children's data is "sensitive", big fines), Low in practice for a tiny foreign app with no presence there.
Marks: [V-reg] regulator/official text, [V-sec] law firm/news/tax vendor, [K] memory.

## Privacy
- [V-sec] Data Protection Act, 2022 (Act No. 5 of 2022), gazetted 4 March 2022. Regulator: Eswatini Communications Commission (ESCCOM), acting as the Eswatini Data Protection Authority (Hogan Lovells; Act PDF seen only as a search snippet).
- [V-sec] Reach: controllers/processors whether or not domiciled in Eswatini, if they use automated or non-automated means in Eswatini (POPIA-style "means" test) (Hogan Lovells). A foreign app with foreign servers is arguably outside it, but don't rely on that if you target Eswatini.
- [V-sec] Registration: s.5 register; you may process only after notifying the Commission (s.46). Registration opened 1 March 2024 (General Notice 5/2024); General Notice 8/2025 announced enforcement against unregistered entities (ESCCOM notices seen only as search snippets; direct fetch returned 404).
- [V-sec] Children: "child" as in the Children's Protection and Welfare Act 2012 [K: under 18]. Children's data is sensitive data, processable only in limited cases (Hogan Lovells). Exact parental-consent rule not confirmed.
- [V-sec] Breach: tell the Authority and the user "as soon as reasonably possible"; no hour limit (Hogan Lovells; one blog says 72 hours, weaker source).
- [V-sec] Transfers: separate rules for SADC members (relaxed) and non-SADC countries (Part V) (Hogan Lovells, Act contents page).
- [V-sec] Fines up to E100,000,000 or 5% of annual turnover, and up to 10 years' prison. DPO not mandatory (Hogan Lovells).

## Kids and games
- [K] No loot-box or game-time law. Children's data being "sensitive" is the main issue: avoid collecting it, or get parent consent.

## Selling
- [K] Electronic Communications and Transactions Act, 2022 (Act No. 3 of 2022) governs online contracts; the consumer/cooling-off part was not read. South Africa-style 7-day cooling-off is possible but unconfirmed.
- [V-sec] VAT: no rule found that makes foreign digital sellers register. Grant Thornton says VAT registration needs a fixed place of business in Eswatini; threshold SZL 500,000. The Ministry of Finance was studying digital-services tax in 2023 (UNDP).
- Practical: Merchant of Record.

## AI, content and platforms
- [K] No AI law. Computer Crime and Cybercrime Act 2022 covers content offences.

## What a small foreign dev should consider
- Don't collect children's data unless you need it; if you do, get parent consent.
- If you target Eswatini specifically (local marketing, local payments), registering with ESCCOM is the cautious move.
- Breach plan: notify quickly.
- Merchant of Record for paid sales.

## Upcoming
- None dated. Watch for a VAT measure on foreign digital services.

## Unverified
- Exact child-consent rule; ECT Act 2022 consumer rights; whether ESCCOM has acted against any foreign app; cookie rules (none found).

## Sources
- https://www.hlc.com/en/publications/recent-developments-in-african-data-protection-laws-outlook-for-2023
- https://www.esccom.org.sz/legislation/DATA%20PROTECTION%20ACT.pdf (404 to the tool)
- https://www.esccom.org.sz/publications/notices/docs/Notice%203%20EDPA%20FINAL%20DECISION%20-REGISTRATION%20OF%20DATA%20CONTROLLERS%20AND%20DATA%20PROCESSORS.pdf (404 to the tool)
- https://esccom.org.sz/publications/notices/docs/Notice%208.pdf (404 to the tool)
- https://dataprotection.africa/?p=19758
- https://www.grantthornton.co.za/insights2/africa-tax-landscape-eswatini/
- https://www.undp.org/node/421731
