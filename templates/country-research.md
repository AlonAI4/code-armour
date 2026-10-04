# Country research template

Use this when a user lives in, or has users in, a country not covered by `references/countries-*.md`. Also use it to refresh a country whose file is more than 6 months old. You need web search. Without it, say so, and fall back to the general rules in SKILL.md Step 2.

## How to research
1. **Prefer primary sources:** the regulator's own website (data protection authority, tax authority, consumer agency) and the official law text. Second best: a big law firm's explainer. Never use only a blog or a vendor selling compliance.
2. **Check dates.** Is it in force today, or only passed/proposed? Note any future dates for `references/upcoming.md`.
3. **Mark every line:** [V] = confirmed in a source today (give the URL); [K] = from memory, not confirmed. Anything you couldn't confirm goes under "Unverified".
4. Keep it to what matters for a **solo or teen dev with a small app.** Mention thresholds that make small projects exempt.

## Save as `references/countries-extra/<country>.md`
```markdown
# <Country> (researched <YYYY-MM-DD>, by <agent> with web search)
Severity: High / Med / Low for a small foreign-run app with a few users here.

## Privacy
- Law name, in force since, does it reach foreign developers?, small-business exemption?, consent rules,
  children's age for consent, breach notice deadline, data leaving the country / localisation.

## Kids and games
- Age limits, social media or game-time rules, loot boxes / gambling.

## Selling
- Consumer rights (refund / cooling-off), VAT/GST on digital sales by foreign sellers + threshold,
  seller info that must be shown (watch for home-address rules: use a Merchant of Record).

## AI, content and platforms
- AI labelling or AI laws, user-content / takedown duties, registration of online services.

## Accessibility and other
- Only if there's real enforcement.

## What a small foreign dev realistically must do
- 3 to 5 bullet points.

## Upcoming
- Dated future changes (also add them to references/upcoming.md).

## Unverified
- Anything not confirmed today.

## Sources
- URLs.
```

Then tell the user plainly what applies, which parts are unverified, and that it's AI research, not legal advice. Offer to contribute the file back to the Code Armour repo.
