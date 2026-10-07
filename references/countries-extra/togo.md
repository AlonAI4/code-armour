# Togo (researched 2026-10-07, by Claude Opus 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Med on paper (new 18% digital VAT from Feb 2026; regulator now active), Low in practice for a tiny foreign app.
Marks: [V-reg] regulator/official text, [V-sec] law firm/news/tax vendor, [K] memory.
Note: law text read from the Official Journal copy (JORT 29 Oct 2019, no. 26 ter) hosted by AFAPDP. The IPDCP and tax-office (OTR) sites were not read.

## Privacy
- [V-reg] Law No. 2019-014 of 29 Oct 2019 on personal data protection. Regulator: IPDCP (Instance de protection des données à caractère personnel), created by the law (art. 55). (JORT)
- [V-sec] IPDCP formally started work on 28 Mar 2025 in Lomé; from Jul 2025 it began mandatory declarations (starting with CCTV). (CIO Mag)
- [V-reg] Reach: applies to controllers established in Togo, and to controllers established or not in Togo that use means of processing located in Togo (art. 2). A purely foreign app on foreign servers is only clearly covered if it uses means in Togo. (JORT)
- [V-reg] Formalities: exemption, declaration, authorisation or opinion regimes (arts. 5-9). [V-sec] IPDCP gives a receipt within one month. (Lextenso)
- [V-reg] Consent is the base principle (art. 14). Transfers to a third country need an adequate level of protection (art. 28); one-off non-massive transfers with express consent allowed (art. 29); IPDCP can authorise others (art. 30).
- [V-reg] Cookies (art. 36): users must be told clearly what reads/writes on their device and how to object. Strictly necessary ones are exempt. This is inform + opt-out, but consent banners are the safer default.
- [V-reg] No article on minors' consent or breach notification found in the law text (only a general security duty, art. 52).
- [V-reg] IPDCP fines up to XOF 100M after a formal notice (art. 71); criminal offences in arts. 79-93.

## Kids and games
- [K] No minors' data age, game-time, social-age or loot-box rule found. Majority is 18; get parent consent for young users.

## Selling
- [V-sec] VAT 18% on electronic services from non-residents to customers in Togo, from 19 Feb 2026: 2026 Finance Law (Law 2025-002) + Ministerial Order 031/MFB/CAB/UPF. Platform-led: platforms/intermediaries collect and remit for the foreign seller. Threshold: nil. Registration process and IT still being built. (vatcalc)
- [V-sec] Platforms must also report users' annual income; 10% penalty on undeclared amounts. (vatcalc)
- [K] Consumer and e-transactions rules exist (e-transactions law 2017-07); refund period not confirmed.
- [K] Stripe does not onboard sellers in Togo; mobile money (T-Money, Flooz) dominates. Selling via app stores or a Merchant of Record means they handle the VAT.

## AI, content and platforms
- [K] No AI law or AI strategy found. [K] Cybersecurity and cybercrime law (2018) has content offences; moderate user content.

## What a small foreign dev should consider
- French privacy policy, consent, an easy objection route for cookies and marketing.
- Parent consent (or block) for children, even though the law sets no age.
- Selling to people in Togo: use a Merchant of Record or app store so the 2026 VAT is handled.
- The IPDCP is new (2025) and starting with local companies; declarations for foreign apps are unlikely to be enforced now but are possible.

## Upcoming
- [V-sec] VAT registration and e-invoicing systems still being set up in 2026; watch OTR announcements. (vatcalc)
- [V-sec] Revised ECOWAS personal-data Supplementary Act validated by experts (Nov 2024), not yet adopted as found. (ECOWAS)

## Unverified
- Whether the IPDCP declaration applies to foreign apps without means in Togo; consumer refund period; B2B treatment of the VAT; whether a direct foreign seller (not via a platform) must register.

## Sources
- https://www.afapdp.org/wp-content/uploads/2020/02/TOGO-JOS_29_10_2019-64E-ANNEE-N°26-TER.pdf (Law 2019-014, Official Journal)
- https://cio-mag.com/?p=57692
- https://www.labase-lextenso.fr/l-essentiel-droits-africains-des-affaires/2020-n2/togo-les-donnees-a-caractere-personnel-sont-dotees-d-un-cadre-juridique-DAA112w2
- https://dti.eui.eu/database/page/46
- https://www.vatcalc.com/togo/togo-vat-on-non-digital-digital-services/
- https://ecowas.int/member-states-experts-validate-the-revised-supplementary-act-a-sa-1-01-10-on-personal-data-protection-within-ecowas/
