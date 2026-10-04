// Code Armour recipe: verify Lemon Squeezy and Paddle webhooks (Merchants of Record: they handle VAT/GST for you).
// Works in Netlify Functions, Vercel, Cloudflare Workers (nodejs_compat) or Node. Always use the RAW body text.
import { createHmac, timingSafeEqual } from "node:crypto";

function safeEqual(a, b) {
  const x = Buffer.from(a || "", "utf8"), y = Buffer.from(b || "", "utf8");
  return x.length === y.length && timingSafeEqual(x, y);
}

// Lemon Squeezy: header X-Signature = HMAC-SHA256(raw body, signing secret) in hex.
export function verifyLemonSqueezy(rawBody, req) {
  const expected = createHmac("sha256", process.env.LEMONSQUEEZY_WEBHOOK_SECRET).update(rawBody).digest("hex");
  return safeEqual(expected, req.headers.get("x-signature"));
}

// Paddle Billing: header Paddle-Signature = "ts=1700000000;h1=<hex>", signed text = `${ts}:${rawBody}`.
export function verifyPaddle(rawBody, req, maxAgeSeconds = 300) {
  const parts = Object.fromEntries((req.headers.get("paddle-signature") || "").split(";").map((p) => p.split("=")));
  if (!parts.ts || !parts.h1) return false;
  if (Math.abs(Date.now() / 1000 - Number(parts.ts)) > maxAgeSeconds) return false;   // stops replays of old events
  const expected = createHmac("sha256", process.env.PADDLE_WEBHOOK_SECRET).update(`${parts.ts}:${rawBody}`).digest("hex");
  return safeEqual(expected, parts.h1);
}

// Example (Netlify / any fetch-style handler):
export default async (req) => {
  const raw = await req.text();
  if (!verifyLemonSqueezy(raw, req)) return new Response("Bad signature", { status: 401 });
  const event = JSON.parse(raw);
  // Record a unique event id first (no double grants), then grant from event.data.
  return new Response("ok");
};
// Check both providers' current docs when you set this up; header names and formats can change.
