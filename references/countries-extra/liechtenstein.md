# Liechtenstein (researched 2026-10-07, by Claude Opus 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Med on paper (the GDPR applies via the EEA), Low in practice for a tiny foreign app (population about 40,000).
Marks: [V-reg] regulator/official text, [V-sec] law firm/news/tax vendor, [K] memory.

Liechtenstein is in the EEA but not the EU. The GDPR applies here in full, so start with `references/legal.md` (GDPR basics). This file only adds national specifics. For VAT it is tied to **Switzerland**, not the EU.

## Privacy
- [V-sec] The GDPR has applied since 20 Jul 2018 (EEA Joint Committee Decision 154/2018). The national Datenschutzgesetz (DSG, LGBl. 2018 Nr. 272, of 4 Oct 2018) and the Datenschutzverordnung took effect on 1 Jan 2019. Regulator: Datenschutzstelle (DSS), Vaduz.
- [V-reg] Children: the DSG does not lower the GDPR Art. 8 age, so the GDPR default of **16** applies for consent to online services. Read the full DSG text on gesetze.li: no national age clause.
- [V-reg] The DSG mostly adds rules on video surveillance, employee data, research and archives, scoring/credit checks, private-sector DPOs (Art. 38), and criminal offences for unlawfully obtaining data (Art. 41) (gesetze.li).
- [V-sec] Cookies: ePrivacy is implemented in the Kommunikationsgesetz (KomG). One vendor says it was never fully updated to the strict 2009 opt-in. In practice, use the EU standard of consent before non-essential cookies; the DSS covered cookies in its 2019 activity report.
- [K] Transfers: EEA member, so data flows freely with the EU/EEA. Other transfers follow GDPR Chapter V.

## Kids and games
- [K] No national loot-box rule found. Gambling is licensed under the Geldspielgesetz.

## Selling
- [V-reg] Distance-selling law (FAGG, LGBl. 2015 Nr. 276), Art. 12: 14-day withdrawal right with no reason needed. Art. 19(l): for digital content not on a physical medium, the right ends once delivery starts, but only if the consumer expressly agreed to that and acknowledged losing the right. This matches the EU/Austrian model (gesetze.li).
- [V-sec] VAT 8.1%, same as Switzerland: one shared VAT area. The EU OSS and its EUR 10,000 threshold do **not** apply. Foreign providers of electronic services must register once their **worldwide** turnover reaches CHF 100,000 (Liechtenstein Business portal via search snippet, VATCalc, Kintsugi). Registration is with the Swiss/Liechtenstein authorities, usually through a fiscal representative.
- Practical: below CHF 100k worldwide, nothing to register. Above it, a Merchant of Record handles the Swiss/LI VAT.

## AI, content and platforms
- [V-sec] The EU AI Act is marked EEA-relevant but is not yet part of the EEA Agreement, so it is not yet binding in Liechtenstein (Lex Mundi / Marxer). Liechtenstein signed the Council of Europe AI Convention on 27 Feb 2025; ratification is pending.
- [K] EU platform laws (DSA etc.) apply only once incorporated into the EEA. Check before assuming.

## What a small foreign dev should consider
- If you already follow the GDPR checklist in `references/legal.md`, you are basically covered.
- Parent consent (or block) under 16.
- For digital-content sales: get express consent plus acknowledgement before giving instant access, or the 14-day refund right stays.
- VAT only matters above CHF 100k worldwide turnover (shared with Switzerland, see `switzerland.md`).

## Upcoming
- [V-sec] EEA incorporation of the EU AI Act: pending, no date.

## Unverified
- Exact KomG cookie wording; whether the CHF 100k test counts worldwide or local turnover (sources conflict, most say worldwide); DSA status in the EEA.

## Sources
- https://www.gesetze.li/konso/2018272000 (DSG; PDF read)
- https://www.gesetze.li/konso/pdf/2015276000 (FAGG; PDF read)
- https://www.recordinglaw.com/de/world-laws/world-data-privacy-laws/liechtenstein-data-privacy-laws/
- https://www.consentstack.io/regulations/li-dsg
- https://www.vatcalc.com/liechtenstein/liechtenstein-vat-on-digital-services-non-residents/
- https://trykintsugi.com/sales-tax-guides/europe/liechtenstein
- https://www.lexmundi.com/guides/ai-legislative-guide/jurisdictions/europe/liechtenstein/
- Blocked: liechtenstein-business.li (403); dlapiperdataprotection.com returned the wrong country.
