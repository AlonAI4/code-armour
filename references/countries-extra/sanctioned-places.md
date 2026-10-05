# Users in sanctioned places (researched 2026-10-05, by Claude Opus 5.5 with web search)
For a small dev based in the UK/EU/US, or anywhere using Stripe, GitHub, Cloudflare or US clouds.
Severity: HIGH for paid sales to comprehensively sanctioned places (strict liability in the US; your payment provider will close your account). Low for a free, public website.
Marks: [V-reg] regulator/official text, [V-sec] law firm/news/company docs, [K] memory. Not legal advice.

## Who is "comprehensively" sanctioned (as of Oct 2026)
- [V-sec] US: Iran, North Korea, Cuba, and Crimea + so-called DNR/LNR (EO 14065) [K: occupied Zaporizhzhia/Kherson are covered by EU/UK rules; US coverage unclear].
- [V-sec] Syria is NO LONGER comprehensively sanctioned: EO 14312 (30 Jun 2025) ended the US program; Caesar Act repealed by NDAA 2026 (18 Dec 2025); State Sponsor of Terrorism designation rescinded 24 Aug 2026. Assad-linked people, Captagon traffickers etc. stay on the SDN list (Willkie, Curtis, search snippets).
- [V-sec] EU lifted most economic Syria sanctions (effective ~29 May 2025); UK eased via 2025 amendment regs (25 Apr 2025). Both keep arms / repression-tech / listed-person rules (HSF Kramer).
- [V-sec] Russia and Belarus: sector + list-based, not a full embargo (see below).
- [K] EU/UK have no full embargo on Iran or Cuba; North Korea is near-total under UN/EU/UK. EU Blocking Statute (Reg. 2271/96) tells EU firms NOT to comply with US Cuba sanctions, which conflicts with Stripe/US-tool policies.

## What's banned (US persons, US companies, and anyone using US services)
- [K] Selling goods or services (incl. subscriptions, in-app purchases, SaaS) to people located in Iran, North Korea, Cuba, Crimea/DNR/LNR without a licence.
- [V-sec] Exceptions for internet communications: Iran GL D-2 (2022) allows software/services incident to internet communications (no longer must be "personal"); Cuba 31 CFR 515.578 allows personal-communications services; Russia GL 25 for telecom/internet (Baker McKenzie, Gibson Dunn). [K] Free messaging, social and browser apps usually fit; paid games/stores and business tools usually don't.
- [V-sec] North Korea: no comparable general licence; treat as total block.
- [V-sec] Free open-source code: OFAC appears to treat published open source as "informational material" (exempt); published software is "not subject to the EAR" (EAR 734.7). But two-way collaboration (support, code review, accepting patches from sanctioned persons/SDNs) may be a "service" (Linux Foundation). Rules are "not 100% well defined".
- [K] Paid AI APIs: providers (OpenAI, Anthropic, Google) forbid use from sanctioned places; routing a sanctioned user's prompts through your key = you providing their service there. Block these users from AI features.
- [K] Hiring/contracting: don't pay contractors in these places; watch for North Korean IT workers using fake identities (FBI/OFAC advisories).

## Russia / Belarus (partial)
- [V-sec] US (from 12 Sep 2024): no IT consultancy/design services, and no IT support/cloud services for enterprise-management or design/manufacturing software, to anyone in Russia. Telecom/internet carve-outs exist (Miller & Chevalier, Hogan Lovells).
- [V-sec] EU: enterprise-management software (ERP/CRM/BI) and design software banned to Russian government/companies (Reg. 833/2014 Art. 5n); 19th package (23 Oct 2025) bans AI services (model access, fine-tuning, inference) and HPC to the Russian government and Russian-established entities.
- [K] Consumer apps/games for Russian individuals are generally not banned, but payments are hard (Visa/Mastercard/Stripe don't work with Russian cards) and listed banks/people are off-limits. Belarus mirrors Russia in EU/UK rules.

## Platform policies
- [V-sec] Stripe: no dealings with persons located in, resident in, or citizens of Cuba, Iran, North Korea, Syria, Crimea, Donetsk, Luhansk. Syria still listed in the found copy (may lag the US change). Breaking this can freeze your account.
- [V-sec] GitHub: North Korea fully blocked; Crimea/DNR/LNR get free public repos + Pages only; Iran allowed (OFAC licence); Cuba generally available; Russia/Belarus: no Enterprise Server or Copilot (GitHub docs).
- [V-sec] Google: Cloud unavailable in Crimea, Cuba, Iran, North Korea, Syria (forum). From 30 Sep 2026 Android developer verification effectively blocks devs from embargoed countries distributing outside their country.
- [V-sec] Apple: App Store returned to Syria (Sep 2025) after BIS "Syria Peace and Prosperity" licence exception (2 Sep 2025). Apple Developer forum shows Syria-related rejections even after easing.
- [V-sec] Cloudflare: complies with US/UK/EU sanctions; notes US general licences permit internet activity in these regions.

## Geo-blocking expectations
- [K] No law says a free public site must geo-block. But for paid features and accounts, regulators expect "reasonable" screening: block checkout by IP + billing country, refuse sanctioned-region cards (Stripe Radar does much of this), and don't knowingly serve users you know are there (e.g. stated address). VPN users you can't detect are not usually held against you if your controls are reasonable.

## What a small dev realistically must do
1. Keep your free site/game/open-source repo public. That's generally fine.
2. Paid stuff: block checkout from Iran, North Korea, Cuba, Crimea/DNR/LNR (+ Syria until your payment provider updates its list). Use Stripe Radar / MoR country blocks.
3. AI features with paid APIs: geo-block those regions (and Russian businesses for EU devs).
4. Don't sell business software/IT services to Russian companies; consumer apps OK but payments won't work.
5. Never hire or pay anyone you can't verify; check names against OFAC SDN / UK / EU lists if money is involved.
6. If in doubt, don't take the money. Ask a sanctions lawyer before any deal involving these places.

## Unverified
- US treatment of occupied Zaporizhzhia/Kherson; exact current Stripe/Google lists after the Syria change; EU 20th package digital measures; UK Russia IT-services ban details.

## Sources
- https://complianceconcourse.willkie.com/articles/united-states-amends-tri-seal-advisory-to-reflect-caesar-act-repeal/
- https://www.curtis.com/our-firm/news/u-s-repeals-the-caesar-act-in-latest-move-to-ease-syria-sanctions
- https://ofac.treasury.gov/sanctions-programs-and-country-information/syria-related-sanctions (not fetched)
- https://www.hsfkramer.com/notes/fsrandcorpcrime/2025-posts/recent-developments-on-sanctions-on-syria-in-the-uk-eu-and-us
- https://sanctionsnews.bakermckenzie.com/ofac-issues-updated-iran-general-license-related-to-certain-services-software-and-hardware-for-communications-over-the-internet-and-new-related-faqs/
- https://www.linuxfoundation.org/blog/navigating-global-regulations-and-open-source-us-ofac-sanctions
- https://millerchevalier.com/publication/trade-compliance-flash-ofac-announces-prohibitions-provision-certain-it-and-software
- https://www.steptoe.com/en/news-publications/international-compliance-blog/eu-council-adopts-19th-sanctions-package-against-russia.html
- https://stripe.com/us/restricted-businesses/
- https://docs.github.com/en/site-policy/other-site-policies/github-and-trade-controls
- https://www.newarab.com/news/apple-products-app-store-return-syria-amid-sanctions-lift ; https://developer.apple.com/forums/thread/791726
- https://www.revera.legal/?p=8162 ; https://blog.cloudflare.com/the-challenges-of-sanctioning-the-internet
