// Tests the Netlify/payment recipes for real: genuine Stripe signatures, Lemon Squeezy/Paddle HMACs,
// and the login + limit checks. The Supabase database is replaced by a fake `fetch`, so no network is used.
// Run: cd tests && npm install && node webhooks.test.mjs
import { cpSync, mkdirSync, rmSync } from "node:fs";
import { createHmac } from "node:crypto";
import Stripe from "stripe";

let passed = 0, failed = 0;
const check = (name, ok, detail = "") => { ok ? passed++ : failed++; console.log(`${ok ? "✓" : "✗"} ${name}${ok ? "" : "  -> " + detail}`); };

// The recipes import "stripe" and "@supabase/supabase-js", so copy them next to our node_modules.
const tmp = new URL("./.tmp-recipes/", import.meta.url);
rmSync(tmp, { recursive: true, force: true });
mkdirSync(tmp, { recursive: true });
cpSync(new URL("../recipes/netlify/", import.meta.url), tmp, { recursive: true });
cpSync(new URL("../recipes/payments/mor-webhooks.mjs", import.meta.url), new URL("mor-webhooks.mjs", tmp));

Object.assign(process.env, {
  STRIPE_SECRET_KEY: "sk_test_fake", STRIPE_WEBHOOK_SECRET: "whsec_test_secret",
  SUPABASE_URL: "http://fake-supabase.local", SUPABASE_SERVICE_ROLE_KEY: "service-role-fake",
  STRIPE_PRICE_PRO_MONTHLY: "price_pro", STRIPE_PRICE_COINS_500: "price_coins", URL: "https://site.example",
  LEMONSQUEEZY_WEBHOOK_SECRET: "ls_secret", PADDLE_WEBHOOK_SECRET: "pdl_secret",
});

// Fake Supabase: records calls, rejects duplicate Stripe event ids like a unique constraint would.
const seenEvents = new Set();
const calls = [];
let quotaAllowed = true;
let captchaDown = false;
let creditsGiven = 0;
const seenWebhooks = new Set();
globalThis.fetch = async (url, init = {}) => {
  url = String(url); const method = init.method || "GET"; calls.push(`${method} ${url}`);
  const json = (status, body) => new Response(body === undefined ? null : JSON.stringify(body), { status, headers: { "content-type": "application/json" } });
  if (url.includes("/auth/v1/user")) {
    const auth = new Headers(init.headers).get("authorization") || "";
    return auth.endsWith("good-token") ? json(200, { id: "user-1", email: "u@x.com", aud: "authenticated" }) : json(401, { msg: "bad jwt" });
  }
  if (url.includes("/rest/v1/stripe_events") && method === "POST") {
    const id = JSON.parse(init.body).id ?? JSON.parse(init.body)[0]?.id;
    if (seenEvents.has(id)) return json(409, { code: "23505", message: "duplicate key value violates unique constraint" });
    seenEvents.add(id); return json(201);
  }
  if (url.includes("/rest/v1/stripe_events") && method === "DELETE") return json(204);
  if (url.includes("/rest/v1/profiles") && method === "PATCH") return json(204);
  if (url.includes("/rest/v1/rpc/add_credits_once")) {
    const { p_event, p_amount } = JSON.parse(init.body);
    if (seenEvents.has(p_event)) return json(200, false);
    seenEvents.add(p_event); creditsGiven += p_amount; return json(200, true);
  }
  if (url.includes("/rest/v1/webhook_events") && method === "POST") {
    const id = JSON.parse(init.body).id;
    if (seenWebhooks.has(id)) return json(409, { code: "23505", message: "duplicate key" });
    seenWebhooks.add(id); return json(201);
  }
  if (url.includes("/rest/v1/rpc/use_ai_quota")) return json(200, quotaAllowed);
  if (url.includes("challenges.cloudflare.com/turnstile/v0/siteverify")) {
    if (captchaDown) throw new Error("network down");
    const token = new URLSearchParams(String(init.body)).get("response");
    return json(200, { success: token === "good-captcha" });
  }
  return json(500, { message: "unexpected call " + url });
};

const stripe = new Stripe("sk_test_fake");
const sign = (payload, secret = "whsec_test_secret") => stripe.webhooks.generateTestHeaderString({ payload, secret });
const post = (path, body, headers = {}) => new Request(`https://site.example${path}`, { method: "POST", body, headers });

// ---------- Stripe webhook ----------
console.log("\n# netlify/stripe-webhook.mjs");
const webhook = (await import(new URL("stripe-webhook.mjs", tmp))).default;
const event = JSON.stringify({ id: "evt_1", type: "checkout.session.completed",
  data: { object: { payment_status: "paid", client_reference_id: "user-1", metadata: { product: "pro_monthly" } } } });

let r = await webhook(post("/api/stripe-webhook", event));
check("no signature -> 400", r.status === 400, r.status);
r = await webhook(post("/api/stripe-webhook", event, { "stripe-signature": sign(event, "whsec_attacker") }));
check("signed with the wrong secret -> 400", r.status === 400, r.status);
const tampered = event.replace("pro_monthly", "coins_500");
r = await webhook(post("/api/stripe-webhook", tampered, { "stripe-signature": sign(event) }));
check("body changed after signing -> 400", r.status === 400, r.status);
calls.length = 0;
r = await webhook(post("/api/stripe-webhook", event, { "stripe-signature": sign(event) }));
check("real signed event -> 200 and pro granted", r.status === 200 && calls.some((c) => c.startsWith("PATCH") && c.includes("profiles")), `${r.status} ${calls}`);
const coinsEvent = JSON.stringify({ id: "evt_coins", type: "checkout.session.completed",
  data: { object: { payment_status: "paid", client_reference_id: "user-1", customer: "cus_1", metadata: { product: "coins_500" } } } });
const r1 = await webhook(post("/api/stripe-webhook", coinsEvent, { "stripe-signature": sign(coinsEvent) }));
const r2 = await webhook(post("/api/stripe-webhook", coinsEvent, { "stripe-signature": sign(coinsEvent) }));
check("same coins event sent twice -> 200 both times, credits added once", r1.status === 200 && r2.status === 200 && creditsGiven === 500, `${r1.status} ${r2.status} credits=${creditsGiven}`);
const unpaid = JSON.stringify({ id: "evt_unpaid", type: "checkout.session.completed",
  data: { object: { payment_status: "unpaid", client_reference_id: "user-1", metadata: { product: "coins_500" } } } });
await webhook(post("/api/stripe-webhook", unpaid, { "stripe-signature": sign(unpaid) }));
check("unpaid checkout grants nothing", creditsGiven === 500, creditsGiven);
calls.length = 0;
const cancel = JSON.stringify({ id: "evt_cancel", type: "customer.subscription.deleted", data: { object: { customer: "cus_1" } } });
r = await webhook(post("/api/stripe-webhook", cancel, { "stripe-signature": sign(cancel) }));
check("cancelled subscription removes pro (red-team find)", r.status === 200 && calls.some((c) => c.startsWith("PATCH") && c.includes("stripe_customer_id=eq.cus_1")), `${r.status} ${calls}`);
r = await webhook(new Request("https://site.example/api/stripe-webhook", { method: "GET" }));
check("GET -> 405", r.status === 405, r.status);

// ---------- Checkout ----------
console.log("\n# netlify/create-checkout.mjs");
const checkout = (await import(new URL("create-checkout.mjs", tmp))).default;
r = await checkout(post("/api/create-checkout", JSON.stringify({ product: "pro_monthly" })));
check("not logged in -> 401", r.status === 401, r.status);
r = await checkout(post("/api/create-checkout", JSON.stringify({ product: "pro_monthly" }), { authorization: "Bearer stolen-or-fake" }));
check("fake token -> 401", r.status === 401, r.status);
r = await checkout(post("/api/create-checkout", JSON.stringify({ product: "free_stuff", price: 1 }), { authorization: "Bearer good-token" }));
check("unknown product / own price -> 400", r.status === 400, r.status);

// ---------- AI endpoint ----------
console.log("\n# netlify/ai-endpoint.mjs");
const ai = (await import(new URL("ai-endpoint.mjs", tmp))).default;
r = await ai(post("/api/ai", JSON.stringify({ message: "hi" })));
check("not logged in -> 401", r.status === 401, r.status);
r = await ai(post("/api/ai", JSON.stringify({ message: "x".repeat(5000) }), { authorization: "Bearer good-token" }));
check("giant prompt -> 400", r.status === 400, r.status);
r = await ai(post("/api/ai", "not json", { authorization: "Bearer good-token" }));
check("broken body -> 400 (not a crash)", r.status === 400, r.status);
quotaAllowed = false;
r = await ai(post("/api/ai", JSON.stringify({ message: "hi" }), { authorization: "Bearer good-token" }));
check("over the daily limit -> 429", r.status === 429, r.status);

// ---------- Lemon Squeezy / Paddle ----------
console.log("\n# payments/mor-webhooks.mjs");
const mor = await import(new URL("mor-webhooks.mjs", tmp));
const body = JSON.stringify({ meta: { event_name: "order_created" }, data: { id: "ord_1" } });
const lsSig = createHmac("sha256", "ls_secret").update(body).digest("hex");
r = await mor.default(post("/api/ls", body, { "x-signature": lsSig }));
check("Lemon Squeezy: real signature -> 200", r.status === 200, r.status);
r = await mor.default(post("/api/ls", body, { "x-signature": lsSig }));
check("Lemon Squeezy: replayed event -> not handled twice (red-team find)", (await r.text()) === "Already handled", r.status);
r = await mor.default(post("/api/ls", body, { "x-signature": "0".repeat(64) }));
check("Lemon Squeezy: fake signature -> 401", r.status === 401, r.status);
r = await mor.default(post("/api/ls", body));
check("Lemon Squeezy: no signature -> 401", r.status === 401, r.status);
const ts = Math.floor(Date.now() / 1000);
const h1 = createHmac("sha256", "pdl_secret").update(`${ts}:${body}`).digest("hex");
check("Paddle: real signature accepted", mor.verifyPaddle(body, post("/", body, { "paddle-signature": `ts=${ts};h1=${h1}` })) === true);
check("Paddle: wrong signature rejected", mor.verifyPaddle(body, post("/", body, { "paddle-signature": `ts=${ts};h1=${"a".repeat(64)}` })) === false);
const old = ts - 3600, oldH = createHmac("sha256", "pdl_secret").update(`${old}:${body}`).digest("hex");
check("Paddle: 1-hour-old (replayed) event rejected", mor.verifyPaddle(body, post("/", body, { "paddle-signature": `ts=${old};h1=${oldH}` })) === false);
check("Paddle: missing header rejected", mor.verifyPaddle(body, post("/", body)) === false);

// ---------- CAPTCHA + cron ----------
console.log("\n# netlify/turnstile-verify.mjs + cron-auth.mjs");
process.env.TURNSTILE_SECRET_KEY = "ts_secret"; process.env.CRON_SECRET = "a-long-random-cron-secret-123";
const turnstile = await import(new URL("turnstile-verify.mjs", tmp));
const form = (tok) => { const f = new FormData(); if (tok) f.set("cf-turnstile-response", tok); f.set("email", "a@b.c"); return new Request("https://site.example/api/signup", { method: "POST", body: f }); };
check("no CAPTCHA token -> 403", (await turnstile.default(form())).status === 403);
check("fake CAPTCHA token -> 403", (await turnstile.default(form("bot-token"))).status === 403);
check("real CAPTCHA token -> 200", (await turnstile.default(form("good-captcha"))).status === 200);
captchaDown = true;
check("Cloudflare unreachable -> refused (fails closed)", (await turnstile.default(form("good-captcha"))).status === 403);
captchaDown = false;
const cron = await import(new URL("cron-auth.mjs", tmp));
const creq = (h) => new Request("https://site.example/api/cron", { headers: h });
check("cron with no secret -> 401", (await cron.default(creq({}))).status === 401);
check("cron with a wrong secret -> 401", (await cron.default(creq({ authorization: "Bearer guess" }))).status === 401);
check("cron with the right secret -> 200", (await cron.default(creq({ authorization: "Bearer a-long-random-cron-secret-123" }))).status === 200);
process.env.CRON_SECRET = "";
check("cron secret not configured -> everyone refused (fails closed)", (await cron.default(creq({ authorization: "Bearer " }))).status === 401);

rmSync(tmp, { recursive: true, force: true });
console.log(`\n${passed} passed, ${failed} failed`);
process.exit(failed ? 1 : 0);
