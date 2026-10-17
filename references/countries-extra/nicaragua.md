# Nicaragua (researched 2026-10-07, by Claude Opus 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Low for privacy and tax (the data regulator was never set up). Med if your app hosts political user content (cybercrime law used against critics).
Marks: [V-reg] regulator/official text, [V-sec] law firm/news/tax vendor, [K] memory.
Note: La Gaceta and dgi.gob.ni not opened.

## Privacy
- [V-sec] Ley 787, Personal Data Protection Law, in force since 29 Mar 2012 (Gazette No. 61); regulation Decreto 36-2012 (DLA Piper, updated Jan 2024).
- [V-sec] The regulator (Dirección de Protección de Datos Personales) "has not been formally incorporated", so the required registration of data files can't be done and enforcement isn't happening (DLA Piper; also cited as non-operational in 2025).
- [V-sec] Rules on paper: purpose limitation; transfers to others need the person's prior consent and must tell them who receives the data; consent or public source for e-marketing with an opt-out; security measures (DLA Piper).
- [V-sec] Cookies: tell users you use them, what data they collect and how to turn them off (DLA Piper).
- [V-sec] No general breach notice duty (only for Army/Police data) (DLA Piper). A compliance vendor says breach notice and fines up to NIO 1M exist (Clym); conflicts with DLA Piper, not relied on.
- [V-sec] Transfers abroad only to countries with adequate protection (Clym, vendor; unconfirmed).

## Kids and games
- [K] Children and Adolescents Code: child under 13, adolescent 13-17. No data-consent age in Ley 787 found (DLA Piper doesn't mention minors).
- [K] No loot-box or game-time law.

## Selling
- [V-sec] IVA 15% (PwC tax summaries). Whether foreign digital sellers must register is unclear: a 2016 KPMG guide says non-residents can't register voluntarily; a 2015 reform note says self-assessment on imported services was abolished (Orbitax). No current non-resident digital regime found.
- [K] Consumer law: Ley 842 (2013) on consumer rights, enforced locally.
- [K] Stripe doesn't support Nicaraguan businesses. Use app stores or a Merchant of Record.

## Sanctions
- [V-sec] US Nicaragua-related sanctions (EO 13851, EO 14088) are list-based: officials and, since Apr 2026, gold-sector firms. Not a country-wide embargo (Federal Register, Alaco). EU Nicaragua sanctions (listed people) were extended to 15 Oct 2026.
- [V-sec] US Section 301 tariff on Nicaraguan goods (0% 2026, 10% 2027, 15% 2028) is about physical imports, not apps (Thompson Hine).
- For a consumer app: selling to ordinary people is fine; payment providers screen the lists. See `sanctioned-places.md` for how list screening works.

## AI, content and platforms
- [V-sec] Ley 1042 Special Cybercrime Law (Oct 2020), amended by Ley 1219 (Sep 2024): criminalises spreading "false" information, applies to acts inside or outside Nicaragua; used to detain critics (ICNL text, Delfino, IACHR).
- [K] No AI law.

## What a small foreign dev should consider
- Basic privacy policy plus cookie notice; ask consent before sharing data.
- If users post content, moderate it; don't host content in a way that puts Nicaraguan users at risk (e.g. show real names).
- Merchant of Record or app stores for payments.

## Upcoming
- [V-sec] EU sanctions renewal due 15 Oct 2026. Update 2026-10-17: renewed on 9 Oct 2026 until 15 Oct 2027, still 21 people and 3 entities (Council/EEAS press release). US 301 tariff steps up 1 Jan 2027.

## Unverified
- Whether the data regulator was set up in 2025-2026.
- Foreign-seller IVA rules; consumer refund period.
- Exact age bands in the Children's Code.

## Sources
- https://www.dlapiperdataprotection.com/?c=NI&t=law
- https://www.clym.io/regulations/law-no-787-on-personal-data-protection-nicaragua
- https://taxsummaries.pwc.com/nicaragua/corporate/other-taxes
- https://assets.kpmg.com/content/dam/kpmg/es/pdf/2016/11/indirect-tax-guide-nicaragua-2016.pdf
- https://orbitax.com/news/country/article/Nicaragua-Tax-Reform-for-2015--9593
- https://www.icnl.org/wp-content/uploads/Law-1042-Cybercrime-2020.pdf
- https://delfino.cr/2024/11/derechos-digitales-en-nicaragua-situacion-critica-que-se-agudiza
- https://public-inspection.federalregister.gov/2026-07699.pdf
- https://www.thompsonhinesmartrade.com/2025/12/ustr-announces-section-301-tariffs-on-nicaragua/
- https://www.eeas.europa.eu/eeas/nicaragua-council-extends-restrictive-measures-until-october-2027_en (renewal to Oct 2027, checked 2026-10-17)
