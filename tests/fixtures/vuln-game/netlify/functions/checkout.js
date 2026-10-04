import Stripe from "stripe";
const stripe = new Stripe(process.env.STRIPE_SECRET_KEY);
export const handler = async (event) => {
  const { amount, price } = JSON.parse(event.body);
  const session = await stripe.checkout.sessions.create({
    mode: "payment",
    line_items: [{ price_data: { currency: "gbp", unit_amount: price, product_data: { name: `${amount} coins` } }, quantity: 1 }],
    success_url: "https://blobjumper.netlify.app/success?coins=" + amount,
    cancel_url: "https://blobjumper.netlify.app/",
  });
  return { statusCode: 200, body: JSON.stringify({ url: session.url }) };
};
