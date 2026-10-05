# Malaysia (researched 2026-10-05, by Claude Opus 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Low-Med for a small foreign-run app with a few users here. Most new laws hit Malaysian-established firms or platforms with 8M+ Malaysian users.
Note: pdp.gov.my loaded but had no amendment detail; no other regulator page was read. Marks: [V-reg] regulator/law text today, [V-sec] law firm/news today, [K] memory.

## Privacy
- [V-sec] Personal Data Protection Act 2010 (PDPA), amended by the PDPA (Amendment) Act 2024. Key changes (breach notice, DPO, portability) in force 1 June 2025. (ASEAN Briefing, Baker McKenzie)
- [K] Reach: PDPA applies to controllers established in Malaysia or using equipment in Malaysia (not just transit). A foreign app with no Malaysian presence is mostly outside it. Not confirmed today.
- [V-sec] Breach notice: Commissioner within 72 hours of becoming aware; affected users within 7 days if risk of significant harm; keep a breach register 2+ years. (China/ASEAN Briefing)
- [V-sec] DPO must be appointed, registered with the Commissioner, and a DPO email published. [K] Commissioner's guideline limits this to larger processing (e.g. 20,000+ data subjects or 10,000+ sensitive); not confirmed today.
- [V-sec] Cross-border: whitelist removed; Cross Border Personal Data Transfer Guideline (29 Apr 2025) allows transfers to "substantially similar" law countries (Transfer Impact Assessment, redo every 3 years) or with notified consent. (CMS, Skrine, Hogan Lovells)
- [K] Children: PDPA sets no age; Commissioner codes / practice treat under-18s as needing parental consent. Not confirmed.
- [K] Consent model: PDPA is consent-led (fewer lawful bases than GDPR); privacy notice must be in Malay and English.

## Kids and games
- [V-sec] Online Safety Act 2025 (ONSA) + 4 subsidiary instruments in force 1 Jan 2026. Applies to licensed ASPs/CASPs; class licence required for services with 8M+ Malaysian users. (Mayer Brown Jul 2026, Rahmat Lim)
- [V-sec] Under-16 social media rule: platforms in scope must stop under-16 accounts and verify age via MyKad / passport / MyDigital ID (eKYC). MCMC is running an age-assurance sandbox before setting standards. Applies to licensed big platforms, not small apps. (Mayer Brown, Tech Wire Asia)
- [K] No loot-box law; Common Gaming Houses Act / Betting Act would only bite if items can be cashed out.

## Selling
- [V-sec] Service Tax on Digital Services: foreign providers must register once Malaysian B2C digital sales exceed RM500,000 in 12 months; 8%; quarterly returns. Since 1 Jan 2020. (PwC tax booklet, Crowe)
- [V-sec] Consumer Protection (Electronic Trade Transactions) Regulations 2024 (P.U.(A) 449/2024) enforced from 24 June 2025: online suppliers must disclose name, registration, contact, price and terms; information in Malay (other languages allowed). (ChemLinked, BigSeller)
- [K] No general cooling-off for digital goods.
- [K] Stripe supports Malaysian merchants; foreign Stripe/Paddle/Lemon Squeezy accept Malaysian cards. A Merchant of Record handles the 8% if you ever cross the threshold.

## AI, content and platforms
- [V-sec] No AI law yet. AI Governance Bill: NAIO consultation paper 10 July 2026 (closed 31 July); tabling expected late 2026 or by Q1 2027. Full-lifecycle, horizontal. (NST, Malay Mail, w.media)
- [V-sec] ONSA takedown deadlines for licensed platforms: CSAM/financial fraud blocked within 24h; other harmful content 4h then removal within 12h; fines up to RM10M. (Mayer Brown)
- [K] Communications and Multimedia Act s.233 (offensive content) still applies to anyone posting; user chat needs report + remove.

## What a small foreign dev realistically must do
- Have a plain privacy policy (Malay version is a plus), a contact/DPO-style email, and a 72h breach plan; you are probably outside PDPA, but this is cheap insurance.
- Do not build "social media" for under-16s without parent consent; ONSA targets big platforms but the norm is set.
- Show seller name, contact, price and terms clearly on checkout.
- Stay under RM500k Malaysian sales or use a Merchant of Record.
- Label AI output as AI; moderation report button for chat.

## Upcoming
- [V-sec] AI Governance Bill: tabling expected Q4 2026 to Q1 2027. No in-force date.
- [V-sec] MCMC age-verification technical standards after the sandbox; no date.

## Unverified
- PDPA territorial reach for foreign apps; DPO thresholds; children's consent age.
- Whether ONSA's under-16 rule is fully enforced yet (sources mix "plans" and "in force").
- Exact Stripe merchant status.

## Sources
- https://www.aseanbriefing.com/news/malaysia-tightens-data-protection-from-june-2025/
- https://insightplus.bakermckenzie.com/bm/data-technology/malaysia-public-consultations-on-data-breach-notification-data-protection-officer-and-data-portability
- https://www.skrine.com/insights/alerts/april-2025/cross-border-personal-data-transfer-guidelines-lau
- https://www.mayerbrown.com/en/insights/publications/2026/07/short-deadlines-significant-penalties-malaysias-online-safety-act-in-focus
- https://www.rahmatlim.com/publication/articles/32341/online-safety-in-malaysia-what-you-should-know-about-the-online-safety-act-2025-and-its-subsidiary-legislation
- https://techwireasia.com/2025/11/malaysia-social-media-ban-under-16-2026/
- https://pwc.com/my/en/publications/mtb/service-tax.html
- https://www.crowe.com/my/services/tax/indirect-tax/service-tax-on-digital-services
- https://food.chemlinked.com/news/food-news/malaysia-promulgates-consumer-protection-electronic-trade-transaction-regulations-2024
- https://www.malaymail.com/news/malaysia/2026/02/24/malaysias-ai-governance-bill-still-taking-shape-anwar-says-law-to-cover-full-lifecycle/210222
- https://www.pdp.gov.my/ppdpv1/en/akta/pdp-act-2010-en/ (read, no detail)
