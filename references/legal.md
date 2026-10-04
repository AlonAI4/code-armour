# Legal: ways a vibe coder gets sued, fined or blocked (UK/EU/US focus)

Researched 2026-10-04. NOT legal advice. Laws differ by country and change often: every rule must be filtered by
where the builder lives, where users are, and what the project does. Key: S site, G game, A AI app, St store.
Severity = how likely enforcement or a lawsuit is for a small indie project, NOT whether the law applies. A "Low" law still applies. Re-verify anything marked unverified.

## 1. The builder's own age (check first if the builder is under 18)
- Stripe: a parent/guardian must own the account before it can charge or pay out; Connect Express/Custom holders 18+. (St/G/A, High blocker) https://support.stripe.com/questions/age-requirement-to-create-a-stripe-account
- Apple & Google developer accounts: 18+. A minor publishes under a parent, who is then the legal developer. Never lie about age. (G/A, High blocker)
- AI API accounts: usually 18+ (unverified exact floors). Parent holds the account. (Med)
- Minors' contracts are voidable (US common law; England Minors' Contracts Act 1987): suppliers and clients will want an adult or company signing. (Med)

## 2. Privacy & data protection
- GDPR / UK GDPR: applies if you target or monitor EU/UK users, wherever you live. No small-business exemption for core duties: lawful basis, privacy notice, user rights (delete/export), security, processor DPAs (Supabase/Netlify/Stripe have them). (all, High if accounts or emails) https://ico.org.uk/for-organisations/
- Breach notification: tell the regulator within 72h if a breach risks people; tell users if high risk. Most common cause: Supabase RLS off or service_role key in frontend. Have a one-page incident plan. (all, High)
- UK ICO data protection fee: £52/yr tier 1, most UK controllers must pay; unclear for under-18 hobbyists (usually parent/company is controller). (Low–Med)
- CCPA/CPRA (California): only if >$26.6M revenue, OR 100k+ CA consumers' data bought/sold/shared, OR 50%+ revenue from selling data. Small projects usually exempt. (Low)
- Texas TDPSA: SBA-defined small businesses are exempt from most of it, but even they must get consent before SELLING sensitive data (kids' data, precise location). Don't sell data. (Low–Med)
- COPPA (US under-13): applies if child-directed or you know a user is under 13. Verifiable parental consent before collecting personal info. 2025 amendments (compliance by 22 Apr 2026) add biometrics/voice and separate consent for ad sharing. ~$53k per violation. Age gate, no ad trackers on kids' pages. (G/A/S, High for games)
- UK Children's Code (Age Appropriate Design Code): services likely used by under-18s in UK: high-privacy defaults, geolocation off, no nudges, DPIA. (G, Med–High)
- GDPR Art. 8: a child's own consent counts from 13–16 by country (UK 13, DE/NL 16); below that, parent consents. (Med, unverified per country)
- Cookies (PECR/ePrivacy): the EU needs prior consent for all non-essential cookies/trackers, with "reject" as easy as "accept". UK (from 5 Feb 2026, Data (Use and Access) Act): first-party analytics, functionality and security cookies are exempt IF you explain them and offer an opt-out; GA4, ad pixels and session replay still need consent. UK PECR fines now up to £17.5M/4%. (all, Med)
- Germany: loading Google Fonts from Google's servers without consent → €100 court award (LG München 2022) and waves of demand letters. Self-host fonts. (Low–Med)

## 3. Email & marketing
- CAN-SPAM (US): honest headers, physical address, working unsubscribe, honour opt-outs within 10 business days. (Med)
- PECR/ePrivacy: marketing email needs opt-in (soft opt-in only for existing customers). Unticked box, keep consent logs. (Med)
- Fake reviews: banned in UK (DMCC Act, from 6 Apr 2025, CMA fines up to 10% turnover), FTC rule in US, EU UCPD. Never write/buy reviews or hide negatives. (Med)
- Influencer/affiliate disclosure: label as #ad (FTC Endorsement Guides, UK CAP Code). (Low–Med)

## 4. Selling: consumer law, subscriptions, payments
- 14-day withdrawal right (EU/UK): for digital content, get the buyer's express consent to instant delivery AND their acknowledgement that they lose the right. Without that consent, they can cancel and pay nothing for content already used. If you never told them about the right at all, it extends by up to 12 months (UK CCR 2013 reg 31). Checkbox + confirmation email. (St/G/A, Med)
- Auto-renewing subscriptions: FTC click-to-cancel rule vacated Jul 2025, but state auto-renewal laws (e.g. California) and ROSCA still apply. UK DMCC subscription rules expected Jan 2027 (date has slipped). Clear terms, explicit consent, easy cancel (Stripe customer portal), renewal reminders. (Med)
- Drip pricing/hidden fees banned in UK (DMCC). Show full price up front. (Low–Med)
- Chargebacks: Stripe closes accounts with high dispute rates (~0.75–1%, unverified). Clear descriptor, refund policy, receipts, Radar. (Med)
- PCI DSS: never let card data touch your server; Stripe Checkout/Elements keeps you at SAQ A. Never build your own card form. (Low if Stripe-hosted)
- Physical goods: EU General Product Safety Regulation (Dec 2024) labels, traceability, EU responsible person. (St physical, Med, unverified)

## 5. Tax
- EU VAT on digital services: non-EU sellers owe VAT from the first EU consumer sale; EU sellers past €10k/yr cross-border. UK: non-UK sellers owe UK VAT from first sale; UK sellers £90k threshold. Easiest fix: a merchant of record (Paddle, Lemon Squeezy, app stores) or Stripe Tax + OSS. (St/G/A, Med–High once selling abroad)
- US sales tax nexus: mostly $100k sales per state; digital goods taxable only in some states. (Low)
- Income tax: declare earnings (minors often via parent). UK £1,000 trading allowance; US self-employment tax over $400. (Med, unverified)

## 6. Accessibility
- European Accessibility Act (from 28 Jun 2025): e-commerce and some digital services to EU consumers, ~WCAG 2.1 AA. Microenterprises providing services (<10 staff AND ≤€2M) are exempt, which covers almost every solo dev. An accessibility statement is good practice and lowers ADA risk for US stores, not usually an EAA duty. (Low–Med)
- ADA Title III (US): no size exemption; 2,000+ web lawsuits in H1 2025, ~69% against online retailers. Alt text, contrast, keyboard nav, labelled forms, accessible checkout. Don't rely on "overlay" widgets. (St, Med)

## 7. Intellectual property
- Copyright in assets (sprites, music, fonts, images, code): most common indie takedown; US statutory damages up to $150k per work. Font files are copyrighted (OFL is fine). Keep a CREDITS/licences file with source + licence of every asset. (all, High)
- AI output: purely AI-generated work isn't copyrightable in the US (Thaler v. Perlmutter 2025), and outputs copying characters/styles can still infringe. Add human input; don't prompt for named IP. (Med)
- Open-source licences: MIT/Apache keep notices; GPL = release source if you distribute; AGPL = if you MODIFY it and offer it over a network, release your modified source. `npx license-checker`, NOTICES file. (Med)
- Trademarks/name clashes: names like "Pokémon"/"Minecraft" or confusingly similar to a registered mark → cease-and-desist, store removal, domain dispute. Search USPTO, UKIPO, EUIPO TMview and app stores before naming. (Med)
- DMCA safe harbour (US): if users upload content, register a designated agent ($6, renew every 3 yrs), notice-and-takedown, repeat-infringer policy. (UGC, Med)
- Likeness/deepfakes/voice cloning: right of publicity (US states, e.g. Tennessee ELVIS Act), UK passing off. Never use a real person's face or voice without permission. (A, High)

## 8. User-generated content & safety
- UK Online Safety Act: ANY user-to-user service (chat, forums, multiplayer chat, UGC) with UK links; no small-service exemption. Illegal-content risk assessment, children's access assessment, reporting tools. Fines up to £18M/10%. If you don't need chat/UGC, don't build it. Duties: a WRITTEN illegal-content risk assessment and a children's access assessment (keep the records), plus reporting and complaints tools. Exempt: comments or reviews only on your own content (OSA Sch. 1 para 4). (G/S with UGC, High)
- EU Digital Services Act: hosting services reaching the EU need a point of contact, clear terms, notice-and-action, reasons for removals; non-EU providers need an EU legal rep. Micro/small exempt from heavier duties. (Med)
- US TAKE IT DOWN Act (from 19 May 2026): UGC platforms must remove non-consensual intimate images incl. AI deepfakes within 48h on request. (UGC/image-gen, Med–High)
- Defamation from user posts: US Section 230 shields hosts; UK has no such shield once notified. Report button + fast takedown. (Med)

## 9. AI-specific
- EU AI Act Art. 50: tell users they're talking to an AI from 2 Aug 2026. Machine-readable marking of AI images/audio/video applies from 2 Aug 2026 for NEW systems; systems already on the market before then get until 2 Dec 2026 (AI Omnibus deal, 7 May 2026; confirm it was formally adopted). Label deepfakes. Fines up to €15M/3%. (A, Med)
- California SB 243 (from 1 Jan 2026): companion chatbots must disclose AI, have self-harm crisis protocols, break reminders for minors, no sexual content for minors; users can sue for $1,000 per violation. (A companion/character apps, High)
- AI provider usage policies: banned uses (sexual content involving minors, unsafeguarded medical/legal advice, impersonation) → key terminated. (A, Med)
- Health/finance/legal claims: FTC needs substantiation; personalised investment advice may be regulated (SEC/FCA). Disclaimers; don't present AI output as professional advice. (Med)

## 10. Games
- Loot boxes: illegal gambling in Belgium (2018); Netherlands narrowed in 2022 (unverified); app stores require odds disclosure. Sell items directly, disclose odds, or geo-block. (G, Med)
- Gambling/sweepstakes/skin betting: prize + chance + paying = illegal lottery. US sweepstakes need "no purchase necessary" + official rules. (G, High if real money/cashout)
- App store rules: their in-app purchase for digital goods, age ratings, privacy labels, in-app account deletion, Texas/Utah/Louisiana app-store age-verification laws (Texas in force after the 5th Circuit stayed the injunction, 28 May 2026; it puts duties on developers too, e.g. using the store's age signal and parental consent). Breaking them = removal. (G/A mobile, Med)

## 11. Business identity & paperwork
- Impressum (Germany/Austria): commercial sites must show name, address, contact (§5 DDG). Private sites exempt. (Low–Med)
- Terms of service: without them, no disclaimer, no right to ban users, no governing law. Generate, then match to real features. (Med)
- Scraping: behind logins can breach CFAA/contracts/EU database rights; scraped personal data needs a GDPR basis. Use official APIs, respect robots.txt. (Med)
- Sanctions/export controls: no selling to sanctioned countries/persons; Stripe screens payments but free downloads/crypto aren't screened. (Low)
- Personal liability: sole trader (or minor via parents) has no shield; a company/LLC separates personal assets once revenue is meaningful. (Med)

## 13. Added after legal review (2026-10-04)
- US wiretap/pixel lawsuits (California CIPA): Meta/TikTok pixels, session replay and third-party chat widgets without consent attract mass demand letters against small US-facing sites. Don't use them, or gate them behind consent. (all US-facing, High) [K]
- Truth in privacy/security claims: FTC Act §5 (US) and UK/EU GDPR transparency. Every promise in your privacy policy or marketing ("encrypted", "we never share") must match the code. False promises are the most common US enforcement hook for small apps. (all, High)
- EU/UK representative (GDPR Art. 27 / UK GDPR Art. 27): a builder outside the EU (or UK) who targets users there needs a representative, unless processing is occasional and low-risk. (all with EU/UK users, Med) [K]
- Kids paying in games: FTC v. Epic ($245M, 2022) for dark-pattern purchases and voice chat on by default. No tricky buttons, easy refunds, chat off by default. Contracts with children are voidable, so expect refunds and chargebacks. (G, Med) [K]
- AI apps sending personal data to the AI provider: say so in the privacy policy, turn off provider training/retention where possible, and respect the provider's minimum user age (e.g. OpenAI: 13+ with parental consent). (A, Med)
- GDPR Art. 8 (child consent ages) only applies when your legal basis is consent. Accounts run under "contract" are a different analysis; kids' codes and COPPA still apply. (Low)

## Couldn't verify
Stripe dispute threshold; California ARL details; Netherlands loot-box status; AI Act marking deferral; AI provider age floors; ELVIS Act scope; US state sales tax detail; GDPR Art. 8 ages per country; UK DMCC subscription date. ADA statistics come from vendor blogs.

## Top 5 for a teen solo dev
1. A parent owns the Stripe, app-store and AI API accounts.
2. Supabase RLS on, keys server-side.
3. Licence/credits file for every asset.
4. No chat/UGC unless ready for OSA/DSA/TAKE IT DOWN moderation.
5. Use a Merchant of Record (opened by a parent) so VAT isn't your problem.

## 12. Added from Alon's pre-launch list (2026-10-04)
- Kids default design (COPPA + UK Children's Code): a NEUTRAL age question before any account (e.g. "enter your birth year", not "are you over 13? yes/no" and no hint which answer unlocks more). Under 13 → guest only: no email, no public name, nothing stored that identifies them. Everyone: private by default, leaderboards and friends opt-in, no chat with strangers. (G, High)
- Privacy page in plain words: what is stored, why, how long, who it's shared with (list processors: Supabase, Netlify, Stripe...), how to delete, and a section for parents. (all, High)
- Working "delete my account" that removes EVERYTHING (auth user, profile, scores, uploads in storage); required by GDPR right to erasure and by Apple/Google for apps with accounts. Test it, then check the rows are really gone. (all, High)
- No trackers or ads (especially with kids); self-host fonts (see Germany/Google Fonts). (all, Med)
- Legal pages set: Terms, Privacy, and an accessibility statement (what level you aim for, known gaps, how to report a problem). The statement is good practice and lowers ADA lawsuit risk for US stores; the EAA usually does not apply to microenterprises. (all, Med)
- Always state: this is a checklist, not legal advice; laws differ by country and change.
