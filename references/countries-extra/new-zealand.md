# New Zealand (researched 2026-10-05, by Claude Opus 5.5 with web search)
Severity: Med for a small foreign-run app with a few users here. The Privacy Act reaches overseas businesses; regulator is active but mostly guides small players.
Note: ird.govt.nz page returned 404 (moved). Marks: [V-reg] regulator/law text today, [V-sec] law firm/news today, [K] memory.

## Privacy
- [K] Privacy Act 2020, 13 Information Privacy Principles (IPPs). Applies to overseas agencies "carrying on business in New Zealand", even without a local office or profit (s.4). No small-business exemption.
- [V-reg] New IPP3A in force May 2026 (Privacy Amendment Act 2025): if you collect personal info about someone from a third party (not from them), you must take reasonable steps to tell them: that it was collected, purpose, recipients, your name and address, any law authorising it, their access/correction rights. (privacy.org.nz)
- [V-sec] IPP3A does not apply when the third party is only your service provider (processor). (IAPP, Bell Gully)
- [V-reg] Breach notice: tell the Privacy Commissioner (NotifyUs) and affected people "as soon as practicable" when a breach has caused or is likely to cause serious harm. No fixed hour count. (privacy.org.nz)
- [K] Consent is not the main model; collect only what you need (IPP1), tell people at collection (IPP3), keep it safe (IPP5). Cross-border disclosure (IPP12) needs comparable safeguards or informed authorisation.
- [K] Children: no fixed age; OPC expects extra care and parental involvement for young children.

## Kids and games
- [V-sec] Online Safety Bill (announced 24 Aug 2026): under-16s barred from "high-risk" social media (Instagram, TikTok, Snapchat, Facebook); reasonable age verification; fines up to 10% of global revenue. Coalition partner NZ First opposes; needs Labour support. Not law. (The Spinoff, Sumsub)
- [K] No loot-box law; Gambling Act 2003 only if prizes have real-money value.

## Selling
- [V-sec] GST on remote services: 15%; offshore suppliers of digital services (games, apps, software, streaming) to NZ consumers register once NZ supplies exceed NZ$60,000 in 12 months; simplified returns. B2C only. (PwC tax summaries, Avalara)
- [K] Consumer Guarantees Act covers digital content (since 2014): must be of acceptable quality and fit for purpose; refunds for faults. Fair Trading Act bans misleading claims and unfair contract terms. No cooling-off for online digital purchases in general.
- [K] Stripe supports NZ merchants; payments from NZ work everywhere.

## AI, content and platforms
- [K] No AI law. Government chose light-touch, existing-law approach (AI Strategy, July 2025). OPC guidance: Privacy Act fully applies to AI tools; tell users.
- [K] Harmful Digital Communications Act 2015: safe-harbour for hosts who pass on/remove complaints within 48 hours.

## What a small foreign dev realistically must do
- Privacy policy that covers the IPPs; collect the minimum; delete/correct on request.
- If you pull user data from elsewhere (e.g. imports, scraped profiles, referrals), notify those people (IPP3A).
- Breach plan: notify OPC + users promptly for serious-harm breaches.
- Stay under NZ$60k or use a Merchant of Record.
- Have a complaint/takedown path for user content (48h to act for HDCA safe harbour).

## Upcoming
- [V-sec] Online Safety Bill (under-16 social media ban): introduced Aug 2026, uncertain support; no in-force date.
- [V-reg] IPP3A already in force from May 2026 (listed for awareness).

## Unverified
- Exact s.4 overseas-agency wording; children guidance; HDCA 48-hour detail; GST page on IRD (404).
- NZ AI Strategy details.

## Sources
- https://www.privacy.org.nz/privacy-principles/3a/
- https://www.privacy.org.nz/responsibilities/privacy-breaches/
- https://www.bellgully.com/insights/preparing-for-ipp-3a-new-requirements-effective-1-may-2026/
- https://iapp.org/news/a/nz-privacy-amendment-act-broadens-privacy-notification-obligation-to-meet-global-practice
- https://thespinoff.co.nz/politics/24-08-2026/new-zealands-proposed-social-media-ban-for-under-16s-explained
- https://sumsub.com/media/news/new-zealand-under-16-social-media-ban/
- https://taxsummaries.pwc.com/new-zealand/corporate/other-taxes
- https://www.avalara.com/us/en/vatlive/country-guides/oceania/new-zealand/new-zealand-gst-rates-and-compliance.html
