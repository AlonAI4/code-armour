// Code Armour recipe: a Stripe webhook that can't be faked and never pays out twice.
// File: netlify/functions/stripe-webhook.mjs   Needs: _auth.mjs, recipes/supabase/stripe-events.sql
// In Stripe: Developers > Webhooks > add https://your-site/api/stripe-webhook, copy its signing secret
// (whsec_...) into the Netlify env var STRIPE_WEBHOOK_SECRET.
// profiles needs: is_pro, credits, stripe_customer_id. Protect all three (protect-privileged-columns.sql):
// only this server code may change them.
import Stripe from "stripe";
import { admin } from "./_auth.mjs";

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY);

export default async (req) => {
  if (req.method !== "POST") return new Response("POST only", { status: 405 });

  // 1. Check the signature on the RAW body. If an AI "fixes" an error here by removing this
  //    check, anyone can send a fake "payment succeeded" and get things for free.
  const body = await req.text();
  let event;
  try {
    event = stripe.webhooks.constructEvent(body, req.headers.get("stripe-signature"), process.env.STRIPE_WEBHOOK_SECRET);
  } catch {
    return new Response("Bad signature", { status: 400 });
  }

  // 2. Handle it. Stripe retries events, so EVERY action here must be safe to repeat:
  //    "set is_pro = true" is naturally safe; adding credits goes through add_credits_once (one payout per event id).
  try {
    if (event.type === "checkout.session.completed") {
      const s = event.data.object;
      if (s.payment_status === "paid" && s.client_reference_id) {
        await grant(event.id, s.client_reference_id, s.metadata?.product, s.customer);
      }
    }
    if (event.type === "customer.subscription.deleted") {
      // Subscription ended (cancelled or unpaid): take "pro" away.
      const { error } = await admin.from("profiles").update({ is_pro: false }).eq("stripe_customer_id", event.data.object.customer);
      if (error) throw error;
    }
  } catch (e) {
    console.error(e);
    return new Response("Failed", { status: 500 });   // Stripe will retry; that's safe because grants are repeatable
  }
  return new Response("ok");
};

async function grant(eventId, userId, product, customerId) {
  if (product === "pro_monthly") {
    const { error } = await admin.from("profiles").update({ is_pro: true, stripe_customer_id: customerId }).eq("id", userId);
    if (error) throw error;
  }
  if (product === "coins_500") {
    const { error } = await admin.rpc("add_credits_once", { p_event: eventId, p_user: userId, p_amount: 500 });
    if (error) throw error;
  }
}

export const config = { path: "/api/stripe-webhook" };

// TEST IT: curl -i -X POST https://your-site/api/stripe-webhook -d '{"type":"checkout.session.completed"}'  -> 400
//          stripe trigger checkout.session.completed (Stripe CLI, test mode)                                 -> 200
//          send the same event twice -> credits added once
