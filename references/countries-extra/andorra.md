# Andorra (researched 2026-10-07, by Claude Opus 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Low for a small foreign app. GDPR-style law, but its reach to foreign apps is narrow; low IGI tax.
Marks: [V-reg] regulator/official text, [V-sec] law firm/news/tax vendor, [K] memory.

Andorra sits between **Spain and France** (both EU) but is not in the EU or EEA. It has its own GDPR-modelled law and has had **EU adequacy since 2010**.

## Privacy
- [V-reg] Llei 29/2021, of 28 Oct, qualificada de protecció de dades personals, in force May 2022. It replaced Llei 15/2003 and is modelled on the GDPR. Regulator: Agència Andorrana de Protecció de Dades (APDA) (Decree 368/2022 preamble, APDA annual report).
- [V-reg] Reach (Art. 48.1, per search excerpt): the APDA covers controllers based in Andorra and non-domiciled controllers that **use processing means located in Andorra**. This is an old-style test that a foreign app hosted elsewhere usually does not meet. [V-sec] One vendor says covered foreign controllers must appoint an Andorran representative.
- [V-reg] Children: **under 16**, consent must be given or authorised by a legal representative (APDA cookies/privacy guide v4, Jan 2024, p. 37). The guide also recommends extra-simple language for sites aimed at minors.
- [V-reg] Cookies: the APDA guide requires informed consent for non-essential cookies, with a cookie policy and privacy notice (model texts in its annexes). It follows EU ePrivacy guidance.
- [V-sec] EU adequacy: Decision 2010/625. The Commission's 15 Jan 2024 review of 11 old adequacy decisions kept Andorra adequate, so EU-to-Andorra transfers need no extra tools.
- [K] Breach notice: likely 72 hours as in the GDPR; not confirmed.

## Kids and games
- [K] No loot-box or game-time law found.

## Selling
- [V-sec] Tax is IGI (Impost General Indirecte), standard rate 4.5%; digital services are taxed at 4.5%. VATCalc lists no threshold for foreign digital suppliers (since 2015). Lookuptax says B2C registration (NRT number plus a resident fiscal representative) is needed only above EUR 40,000 a year of Andorran sales. The sources conflict.
- [K] Consumer protection: Llei 13/2013 on effective competition and consumer protection. Withdrawal period for online sales not confirmed.
- Practical: tiny market; a Merchant of Record covers IGI if needed.

## AI, content and platforms
- [K] No AI law found.

## What a small foreign dev should consider
- A GDPR-grade setup (consent banner, privacy policy) already meets the APDA's guide.
- Parent consent (or block) under 16.
- If you're in the EU, sending data to Andorra is fine (adequacy).
- IGI is low and probably has a threshold; a Merchant of Record removes the question.

## Upcoming
- [K] Next EU adequacy review expected around 2028.

## Unverified
- Exact text of Art. 48 and any representative duty; breach deadline; IGI threshold (nil vs EUR 40,000); consumer withdrawal period; any AI rules.

## Sources
- https://www.apda.ad/storage/helps/b090S1LGln1k0StXyghFvQ5SeEdVmk3WrCFlfwU6.pdf (APDA cookies guide v4; PDF read)
- https://www.apda.ad/assets/pdf/agency/Decret_368-2022_del_14-9-2022_d_aprovacio_del_Reglament_de_l_Agencia_Andorrana_de_Proteccio_de_Dades.pdf
- https://www.cookieyes.com/blog/andorra-personal-data-protection-law/
- https://eur-lex.europa.eu/eli/dec/2010/625/oj
- https://www.hunton.com/privacy-and-cybersecurity-law-blog/european-commission-reviews-and-reaffirms-adequacy-decisions-for-11-jurisdictions
- https://www.vatcalc.com/albania/albania-vat-on-digital-services/ (Europe table)
- https://lookuptax.com/docs/es/numero-identificacion-fiscal/guia-nrt-andorra
- Unreadable: the APDA French law PDF (llei_qualificada..._fr.pdf) had no extractable text.
