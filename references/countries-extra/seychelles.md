# Seychelles (researched 2026-10-07, by Claude Opus 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Low-Med (modern law with under-18 parent consent and 72-hour breach notice, but it seems to cover only processing in Seychelles).
Marks: [V-reg] regulator/official text, [V-sec] law firm/news/tax vendor, [K] memory.

## Privacy
- [V-sec] Data Protection Act, 2023 (Act 24 of 2023), in force 22 Dec 2023; replaced the never-used 2003 Act. 18-month transition ended about June 2025. Regulator: Information Commission (DataGuidance, DLA Piper, Appleby).
- [V-reg] The Information Commission says it can investigate complaints and breaches, audit, issue enforcement notices and impose administrative fines (infocom.sc).
- [V-sec] Reach (s.3): processing "within the territory of Seychelles". No clear reach to foreign apps (TechHive, DataGuidance).
- [V-sec] Children = under 18 (s.23): parent/guardian consent, or check that a third party got it. No age-verification method set (TechHive).
- [V-sec] Breach: tell the Commission within 72 hours (later with reasons); tell users promptly if serious (ss.43-44) (TechHive).
- [V-sec] Transfers (s.47): to countries with comparable protection or under safeguards (TechHive, DLA Piper). No localisation.
- [V-sec] No general registration found; DPO only for large-scale monitoring/sensitive data (s.45) (DLA Piper, TechHive).
- [K] Fine amounts not found.

## Kids and games
- [V-sec] Under-18 parent consent is the main rule. [K] No loot-box/game-time law.

## Selling
- [V-sec] Consumer Protection Act 2010 (in force 29 Nov 2010), enforced by the Fair Trading Commission; no online/distance-selling or cooling-off rule found (SeyLII).
- [V-sec] VAT 15%. SRC's non-resident brochure: if the customer is unregistered (a consumer), a foreign supplier of services enjoyed in Seychelles must register to charge VAT; business customers use reverse charge with 15% withholding (SRC brochure, seen as search snippet; PDF not readable by the tool). Compulsory threshold reported as SCR 2,000,000 (afrotools; check with SRC). So a tiny app is likely under it.
- Practical: Merchant of Record.

## AI, content and platforms
- [K] No AI law.

## Regional
- [K] SADC member; the SADC Model Law on Data Protection (2013) is a template, not binding. No SADC-wide digital VAT rule.

## What a small foreign dev should consider
- Parent consent (or block) for under-18s if you target Seychelles.
- 72-hour breach plan.
- Merchant of Record for paid sales.

## Upcoming
- [V-sec] SRC mandatory e-invoicing for VAT-registered taxpayers: target end-2026, no binding date (Edicom).

## Unverified
- Whether the Act reaches foreign apps targeting Seychelles; fine amounts; how SRC treats tiny foreign digital sellers; Budget 2025 proposal to drop withholding on foreign digital technical services; cookie rules (none found). The gazette PDF of the Act was too large for the tool.

## Sources
- https://www.gazette.sc/sites/default/files/2023-12/Act%2024%20-%202023%20-%20Data%20Protection%20Act%202023.pdf (too large for the tool)
- https://www.infocom.sc/?p=7834
- https://www.techhiveadvisory.africa/insights/review-of-seychelles-dpa
- https://www.dlapiperdataprotection.com/?c=SC&t=law
- https://www.dataguidance.com/news/seychelles-data-protection-act-enters-force
- https://applebyglobal.com/publications/data-protection-law-now-in-force-in-seychelles
- https://seylii.org/akn/sc/act/2010/30/eng@2015-12-31
- https://src.gov.sc/wp-content/uploads/2022/12/VAT-for-Non-Resident-Brochure.pdf
- https://afrotools.com/blog/seychelles-vat-filing-guide-2026/
- https://edicomgroup.com/electronic-invoicing/seychelles
