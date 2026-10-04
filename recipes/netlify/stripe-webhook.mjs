// Code Armour recipe: a Stripe webhook that can't be faked and never grants a purchase twice.
// File: netlify/functions/stripe-webhook.mjs   Needs: _auth.mjs, recipes/supabase/stripe-events.sql
// In Stripe: Developers > Webhooks > add https://your-site/api/stripe-webhook, copy its signing secret
// (whsec_...) into the Netlify env var STRIPE_WEBHOOK_SECRET.
import Stripe from "stripe";
import { admin } from "./_auth.mjs";

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY);

export default async (req) => {
  if (req.method !== "POST") return new Response("POST only", { status: 405 });

  // 1. Check the signature on the RAW body. If the AI "fixes" an error here by removing this
  //    check, anyone can send a fake "payment succeeded" and get things for free.
  const body = await req.text();
  let event;
  try {
    event = stripe.webhooks.constructEvent(body, req.headers.get("stripe-signature"), process.env.STRIPE_WEBHOOK_SECRET);
  } catch {
    return new Response("Bad signature", { status: 400 });
  }

  // 2. Stripe retries events. Record the event id first; if it's already there, we're done.
  const { error: dupe } = await admin.from("stripe_events").insert({ id: event.id });
  if (dupe) {
    if (dupe.code === "23505") return new Response("Already handled");   // unique violation = seen before
    return new Response("Try again", { status: 500 });                  // Stripe will retry
  }

  try {
    if (event.type === "checkout.session.completed") {
      const s = event.data.object;
      if (s.payment_status === "paid" && s.client_reference_id) {
        await grant(s.client_reference_id, s.metadata?.product);
      }
    }
    if (event.type === "customer.subscription.deleted") {
      // e.g. turn is_pro off for this customer (look them up by s.customer).
    }
  } catch (e) {
    // Undo the "handled" mark so Stripe's retry can try again.
    await admin.from("stripe_events").delete().eq("id", event.id);
    return new Response("Failed", { status: 500 });
  }
  return new Response("ok");
};

// Change privileged columns ONLY here (server, service_role). protect-privileged-columns.sql blocks the browser.
async function grant(userId, product) {
  if (product === "pro_monthly") {
    const { error } = await admin.from("profiles").update({ is_pro: true }).eq("id", userId);
    if (error) throw error;
  }
  if (product === "coins_500") {
    const { error } = await admin.rpc("add_credits", { p_user: userId, p_amount: 500 });   // write this as a server-only function
    if (error) throw error;
  }
}

export const config = { path: "/api/stripe-webhook" };

// TEST IT: curl -i -X POST https://your-site/api/stripe-webhook -d '{"type":"checkout.session.completed"}'  -> 400
//          stripe trigger checkout.session.completed (Stripe CLI, test mode)                                 -> 200, granted once
