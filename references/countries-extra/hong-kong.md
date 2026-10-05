# Hong Kong (researched 2026-10-05, by Claude Opus 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Low for a small foreign-run app with a few users here. PDPO mostly reaches data users controlling data in or from Hong Kong; no sales tax.
Marks: [V-reg] regulator/law text today, [V-sec] law firm/news today, [K] memory.

## Privacy
- [V-reg] Personal Data (Privacy) Ordinance (Cap. 486, PDPO). Six Data Protection Principles: lawful and fair collection, accuracy and retention, use limited to the original purpose unless express voluntary consent, security, openness of policies, access and correction. Direct marketing needs explicit consent. (pcpd.org.hk)
- [V-reg] 2021 amendment made doxxing a crime; PCPD can issue cessation notices and prosecute. Relevant if your app hosts user posts. (pcpd.org.hk)
- [V-sec] Reach: PDPO applies to data users who control data in or from Hong Kong; generally no extraterritorial effect. A foreign app with no HK operation is mostly outside it. (Baker McKenzie, Linklaters)
- [V-sec] No mandatory breach notification as of 2026 (voluntary to PCPD is expected good practice). Reform proposals (mandatory notice, retention policy, admin fines, processor rules) are still under study; no bill. (UpperSetup, HFW)
- [K] Children: no statutory age; PCPD guidance expects parental consent for young children. Section 59 cross-border transfer restriction has never been brought into force.

## Kids and games
- [V-sec] Gambling Ordinance (Cap. 148) does not clearly cover loot boxes; Consumer Council has called for odds disclosure and more protection for minors. No loot-box law yet. (Boase Cohen & Collins, SCMP)
- [K] No age limits on social media or games in law.

## Selling
- [K] No VAT/GST/sales tax in Hong Kong: nothing to register for digital sales.
- [K] No general statutory cooling-off for online sales; Trade Descriptions Ordinance bans misleading pricing and unfair practices (bait, aggressive sales).
- [K] Stripe supports HK merchants; payments into HK work.

## AI, content and platforms
- [V-sec] No AI law. Government regulates AI through existing law (privacy, copyright, consumer) plus guidance. Digital Policy Office's Generative AI Technical and Application Guideline (Apr 2025, updated Dec 2025). (law.asia, Mayer Brown Jul 2026)
- [V-sec] PCPD's AI Model Personal Data Protection Framework (11 June 2024): governance, risk assessment, human oversight, telling users. Guidance, not binding. (HFW)
- [K] National Security Law and Safeguarding National Security Ordinance (2024) can reach online content; keep moderation for user posts.

## What a small foreign dev should consider
- Follow the six DPPs (privacy notice at collection, use only for stated purpose, secure it, let users see/fix data). Easy if you already do GDPR-lite.
- Don't use personal data for marketing without explicit opt-in.
- Moderate user content; remove doxxing posts fast.
- Nothing to do for sales tax.

## Upcoming
- [V-sec] PDPO reform (mandatory breach notice within ~5 business days proposed, admin fines): no bill or date yet.

## Unverified
- PCPD children's guidance details; s.59 status; consumer cooling-off rules for digital goods.

## Sources
- https://www.pcpd.org.hk/english/data_privacy_law/ordinance_at_a_Glance/ordinance.html
- https://resourcehub.bakermckenzie.com/en/resources/global-data-and-cyber-handbook/asia-pacific/hong-kong/topics/territorial-scope
- https://uppersetup.com/en/blog/pdpo-cap-486-in-2026-the-reform-that-never-came-and
- https://www.hfw.com/insights/a-new-era-for-data-protection-in-hong-kong-legislative-updates-for-a-digital-age/
- https://law.asia/hong-kong-ai-governance-framework/
- https://www.mayerbrown.com/zh-hans/insights/publications/2026/07/ai-regulation-in-singapore-and-hong-kong-a-mid-year-checkpoint
- https://www.boasecohencollins.com/zh-hant/%E7%B6%B2%E8%AA%8C/gambling-ordinance-not-fully-effective
