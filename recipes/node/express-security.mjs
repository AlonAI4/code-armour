// Code Armour recipe: the safety basics for an Express server (Node).
// npm i express helmet express-rate-limit cors stripe
import express from "express";
import helmet from "helmet";
import rateLimit from "express-rate-limit";
import cors from "cors";
import Stripe from "stripe";

const app = express();
const stripe = new Stripe(process.env.STRIPE_SECRET_KEY);
app.set("trust proxy", 1);           // behind a host's proxy, so rate limits see real IPs
app.disable("x-powered-by");

// Security headers (HSTS, CSP, nosniff, frame blocking...). Tune the CSP to your real domains.
app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      "default-src": ["'self'"],
      "script-src": ["'self'", "https://js.stripe.com"],
      "connect-src": ["'self'", "https://api.stripe.com"],
      "frame-src": ["https://js.stripe.com", "https://checkout.stripe.com"],
      "frame-ancestors": ["'none'"],
    },
  },
}));
app.use((req, res, next) => { res.set("Permissions-Policy", "camera=(), microphone=(), geolocation=()"); next(); });

// Only your own site may call the API from a browser.
app.use(cors({ origin: process.env.SITE_URL }));

// Stripe webhook BEFORE express.json(): the signature check needs the raw body.
app.post("/api/stripe-webhook", express.raw({ type: "application/json" }), (req, res) => {
  let event;
  try {
    event = stripe.webhooks.constructEvent(req.body, req.headers["stripe-signature"], process.env.STRIPE_WEBHOOK_SECRET);
  } catch {
    return res.status(400).send("Bad signature");
  }
  // Record event.id (unique) so retries don't grant twice, then grant. See recipes/netlify/stripe-webhook.mjs.
  res.send("ok");
});

app.use(express.json({ limit: "100kb" }));   // no giant request bodies

// Rate limit the API: 60 requests a minute per IP. Use tighter limits on login, signup and AI routes.
app.use("/api/", rateLimit({ windowMs: 60_000, limit: 60, standardHeaders: "draft-7", legacyHeaders: false }));

// Login check. Replace verifyToken with your auth provider's server-side verification
// (Supabase auth.getUser, Firebase verifyIdToken, Clerk, Auth0 JWKS...). Never just decode the token.
async function requireUser(req, res, next) {
  const token = req.headers.authorization?.replace("Bearer ", "");
  const user = token && (await verifyToken(token).catch(() => null));
  if (!user) return res.status(401).json({ error: "Please log in" });
  req.user = user;
  next();
}
async function verifyToken(token) { throw new Error("verifyToken not set up yet"); }

// Example private route: the id in the URL must belong to the caller (stops IDOR).
app.get("/api/orders/:id", requireUser, async (req, res) => {
  // const order = await db.order.findFirst({ where: { id: req.params.id, userId: req.user.id } });
  // if (!order) return res.status(404).end();     // same answer for "not yours" and "doesn't exist"
  res.json({});
});

// Last: never send stack traces or database errors to users.
app.use((err, req, res, next) => {
  console.error(err);
  res.status(500).json({ error: "Something went wrong" });
});

app.listen(process.env.PORT || 3000);
