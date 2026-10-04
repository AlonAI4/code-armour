// Code Armour recipe: start a Stripe Checkout where the SERVER decides the price.
// File: netlify/functions/create-checkout.mjs   Needs: _auth.mjs
// The browser only says WHICH product. Never accept a price, amount or discount from the browser.
import Stripe from "stripe";
import { getUser } from "./_auth.mjs";

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY);   // server env var only

// The only things that can be bought. Price IDs come from your Stripe dashboard.
const PRODUCTS = {
  pro_monthly: { price: process.env.STRIPE_PRICE_PRO_MONTHLY, mode: "subscription" },
  coins_500:   { price: process.env.STRIPE_PRICE_COINS_500,   mode: "payment" },
};

export default async (req) => {
  if (req.method !== "POST") return new Response("POST only", { status: 405 });
  const user = await getUser(req);
  if (!user) return new Response("Please log in", { status: 401 });

  const { product } = await req.json().catch(() => ({}));
  const item = PRODUCTS[product];
  if (!item) return new Response("Unknown product", { status: 400 });

  const site = process.env.URL;   // Netlify sets this to your site's main URL
  const session = await stripe.checkout.sessions.create({
    mode: item.mode,
    line_items: [{ price: item.price, quantity: 1 }],
    client_reference_id: user.id,              // lets the webhook know who paid
    customer_email: user.email,
    metadata: { product },
    success_url: `${site}/thanks?session_id={CHECKOUT_SESSION_ID}`,   // show a thank-you page ONLY:
    cancel_url: `${site}/pricing`,                                    // the webhook grants the purchase
    // EU/UK digital goods: get consent to instant delivery so the 14-day refund right can end. See legal.md section 4.
    consent_collection: { terms_of_service: "required" },
  });
  return Response.json({ url: session.url });
};

export const config = { path: "/api/create-checkout" };
// consent_collection.terms_of_service needs a Terms URL set in your Stripe dashboard (Settings > Public details).
// Selling abroad? A Merchant of Record (Paddle, Lemon Squeezy) handles VAT/GST for you. See legal.md section 5.
