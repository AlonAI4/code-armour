# El Salvador (researched 2026-10-07, by Claude Opus 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Med on paper (new GDPR-style law, 72-hour breach notice, parent consent under 18), Low in practice for a tiny foreign app.
Marks: [V-reg] regulator/official text, [V-sec] law firm/news/tax vendor, [K] memory.
Note: law text read from the consolidated PDF on jurisprudencia.gob.sv (Supreme Court legal database). transparencia.mh.gob.sv timed out.

## Privacy
- [V-reg] Ley para la Protección de Datos Personales, Decreto 144, published 15 Nov 2024 (in force 23 Nov 2024 per PrivacyLaws). Regulator: Agencia de Ciberseguridad del Estado (ACE).
- [V-reg] Amended by Decreto Legislativo 659 (17 Sep 2026, Diario Oficial 18 Sep 2026): the Data Protection Officer article (Art. 15) was repealed; organisations must still receive and answer access/correction/deletion (ARCO-POL) requests themselves (Art. 16), within 20 working days.
- [V-reg] Art. 2: applies to any person or company, public or private, that processes personal data. No express foreign-reach clause.
- [V-sec] ACE's data policies (Oct 2025) say they cover all entities processing data in the country, "including international operations involving Salvadoran citizens" (García Bodán).
- [V-reg] Consent is the main basis; written consent (signature or equivalent) for sensitive data.
- [V-reg] Breach: notify ACE, the Attorney General (Fiscalía) and affected people within 72 hours of learning of it (Art. 25).
- [V-reg] Transfers need the person's prior informed consent and a contract with the recipient (Art. 40-41); sending data to a country below the law's protection level is a very serious infraction. No localisation rule found.
- [V-reg] Fines (Art. 57): 1-10, 11-25 or 26-40 monthly commerce-sector minimum wages for minor, serious, very serious. [K] About USD 16,000 at most.
- [V-sec] ACE policies also require a record of processing, staff training, privacy impact assessments and security measures (2FA, encryption, backups, pen tests).

## Kids and games
- [V-reg] Using data of children or adolescents without prior consent of parents/guardians is a very serious infraction. Children's own consent follows "progressive autonomy"; the law gives no fixed age. [K] Under Salvadoran law, adolescents are 12-17, so treat everyone under 18 as needing parent consent.
- [K] No loot-box or game-time law.

## Selling
- [V-sec] IVA 13%. No specific rules found for foreign digital sellers; businesses self-assess on imported services (VATCalc, PayPro). The Finance Ministry has studied taxing digital services.
- [V-sec] Consumer Protection Law has a right of withdrawal (Art. 13, added 2013) and e-commerce rules (Art. 21-A, 21-B, since Aug 2018); enforced by the Defensoría del Consumidor (Defensoría materials). [K] Withdrawal period: 8 days.
- [K] The country uses USD. Bitcoin acceptance became voluntary in 2025. Stripe doesn't support Salvadoran businesses; use app stores or a Merchant of Record.

## AI, content and platforms
- [V-sec] Ley de Fomento de la Inteligencia Artificial y Tecnologías, in force Mar 2025: mostly pro-developer; a national AI agency (ANIA) runs a voluntary register with liability benefits. ANIA Resolution 0001/2025 (25 Aug 2025) applies where there's a local establishment or AI trained/run on infrastructure in El Salvador (El Mundo, PwC, Pearl Cohen).
- [V-sec] Cybersecurity Law (Decreto 143, Nov 2024) created the ACE; HRW criticised both laws for concentrating power.

## What a small foreign dev should consider
- Get parent consent (or block) under 18 if you collect personal data from kids.
- Have a 72-hour breach plan (ACE + Fiscalía + users).
- Handle access/delete requests within 20 working days.
- Privacy policy that names where data goes (your cloud abroad) and asks consent for it.
- Merchant of Record for paid sales.

## Upcoming
- [V-reg] Decreto 659 amendments (Sep 2026) are new; ACE may issue updated policies.

## Unverified
- Whether ACE has acted against any foreign company.
- Exact withdrawal period; whether foreign sellers must collect IVA.
- What else Decreto 659 changed besides Art. 2, 15, 16, 18.

## Sources
- https://www.jurisprudencia.gob.sv/DocumentosBoveda/D/2/2020-2029/2024/11/10660E.PDF
- https://www.privacylaws.com/reports-gateway/articles/int195/int195elsalvador/
- https://garciabodan.com/en/el-salvador-strengthens-personal-data-protection/
- https://www.ecija.com/actualidad-insights/ley-de-proteccion-de-datos-en-el-salvador/
- https://www.hrw.org/es/news/2024/12/12/el-salvador-nuevas-leyes-amenazan-la-libertad-de-expresion-y-la-privacidad
- https://www.vatcalc.com/el-salvador/el-salvador-vat-on-foreign-digital-services/
- https://payproglobal.com/saas-sales-tax/el-salvador/
- https://faolex.fao.org/docs/pdf/els186196.pdf
- https://diario.elmundo.sv/politica/inicia-vigencia-de-ley-de-fomento-a-inteligencia-artificial-en-el-salvador
- https://www.pwc.com/ia/es/publicaciones/Noticias-Tax-Legal/Tax-and-legal-2025/Disposiciones-sobre-implementacion-de-IA.pdf
