// Code Armour recipe: Stripe webhook for Next.js App Router.
// File: app/api/stripe-webhook/route.ts
import "server-only";
import Stripe from "stripe";

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!);

export async function POST(req: Request) {
  const body = await req.text();   // raw body: needed for the signature check
  let event: Stripe.Event;
  try {
    event = stripe.webhooks.constructEvent(body, req.headers.get("stripe-signature")!, process.env.STRIPE_WEBHOOK_SECRET!);
  } catch {
    return new Response("Bad signature", { status: 400 });
  }

  // 1. Record event.id in a table with a unique constraint; if it's already there, return 200 and stop.
  // 2. Grant only here, never on the success page:
  if (event.type === "checkout.session.completed") {
    const session = event.data.object as Stripe.Checkout.Session;
    if (session.payment_status === "paid" && session.client_reference_id) {
      // await grantPurchase(session.client_reference_id, session.metadata?.product);
    }
  }
  return new Response("ok");
}

// Server Actions: each one is a public endpoint. Start every action with
//   const session = await auth(); if (!session) throw new Error("Not logged in");
// and check the user owns whatever id they pass in.
