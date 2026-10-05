# Kazakhstan (researched 2026-10-05, by Claude Opus 5.5 with web search)
General notes, not legal advice. See the disclaimer in README.md in this folder.
Severity: Med. Strict on paper (data localisation, AI labels, site blocking for unpaid VAT), but enforcement targets big platforms.
Note: adilet.zan.kz / kgd.gov.kz not fetched. Marks: [V-reg] regulator/official text, [V-sec] law firm/news/tax vendor, [K] memory.

## Privacy
- [V-sec] Law No. 94-V "On Personal Data and Their Protection" (2013). Biggest amendment package (Law 326-VIII) in force 25 Aug 2026: state register of processors, breach register, size classes (small up to 10,000 people; medium to 500,000; large above) (UpperSetup).
- [V-sec] Localisation: personal data of Kazakh citizens must be stored in a database / "digital object" located in Kazakhstan (Art. 12(2)); the source says this applies regardless of where the operator is based. Practical enforcement against small foreign apps: unclear.
- [V-sec] Breach notice to the regulator within ONE working day.
- [V-sec] Cross-border: OK to "adequate" countries (no official list) or with the person's consent, so get explicit consent.
- [V-sec] Max fine about KZT 8.65M (~EUR 16k) for large businesses.
- [K] Children: parent/legal-representative consent for minors (under 18); no lower digital age confirmed.

## Kids and games
- [V-sec] Proposed ban on social-media accounts for under-16s (messengers exempt), age verification planned (Jan 2026 reports). NOT confirmed as law.
- [K] Gambling is tightly licensed; never allow cash-out of loot-box items.

## Selling
- [V-sec] VAT rose from 12% to 16% on 1 Jan 2026 (new Tax Code). Foreign e-services to Kazakh individuals: 16%, no B2C threshold (KPMG, Kintsugi).
- [V-sec] Register within one month of the first payment from a Kazakh customer. Non-compliance or ignoring tax notices can lead to your site being BLOCKED in Kazakhstan.
- Practical: a Merchant of Record handles this; with plain Stripe you owe it from sale 1.

## AI, content and platforms
- [V-sec] Law "On Artificial Intelligence" No. 230-VIII, signed 17 Nov 2025, in force 18 Jan 2026.
- [V-sec] Synthetic content (images, video, audio, text imitating real people/events) may be published only if clearly labelled, visible AND machine-readable. Duty is on AI-system owners/operators and distributors, not end users.
- [V-sec] Banned: behavioural manipulation, exploiting vulnerabilities, emotion recognition without consent, social scoring.
- [V-sec] Digital Code Art. 43: disclose AI use, explain key factors, right to human review (procedures pending).
- [K] Online Platforms law (2023) requires big foreign platforms to name a local legal representative; threshold not confirmed.

## What a small foreign dev realistically must do
- Label AI-generated output visibly + in metadata (C2PA/EXIF tag) and say chats are AI.
- Get explicit consent for storing data abroad; know localisation is a risk if you grow.
- Breach plan with a 1-working-day authority notice.
- Use a Merchant of Record for sales (16% VAT, no threshold, blocking risk).

## Upcoming
- [V-sec] Under-16 social media ban: draft (2026). AI law by-laws still pending.

## Unverified
- How localisation is enforced on small foreign apps; children's consent age; Online Platforms law thresholds.
- Exact AI-label format rules.

## Sources
- https://uppersetup.com/en/blog/personal-data-and-localisation-in-kazakhstan-in-2026-law-no
- https://kpmg.com/us/en/taxnewsflash/news/2025/11/kazakhstan-new-vat-rules-foreign-internet-companies-2026.html
- https://trykintsugi.com/sales-tax-guides/europe/kazakhstan
- https://www.mondaq.com/new-technology/1735592/the-new-artificial-intelligence-law-of-the-republic-of-kazakhstan
- https://www.ismet.kz/en/news/ismet/v-kazahstane-vvodjat-objazatelnuju-markirovku-kontenta-sozdannogo-s-pomoshhju-ii
- https://kun.uz/en/news/2026/01/22/kazakhstan-weighs-social-media-ban-for-children-under-16
