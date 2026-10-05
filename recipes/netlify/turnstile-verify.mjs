// Code Armour recipe: CHECK the CAPTCHA on the server (security.md 15.10). Showing the Turnstile widget does
// nothing on its own: bots just skip it. Your form handler must send the token to Cloudflare and refuse if it fails.
// Env: TURNSTILE_SECRET_KEY (Cloudflare dashboard > Turnstile). Works the same for hCaptcha with its siteverify URL.

export async function captchaOk(token, ip) {
  if (!token || typeof token !== "string" || token.length > 2048) return false;
  const body = new URLSearchParams({ secret: process.env.TURNSTILE_SECRET_KEY, response: token });
  if (ip) body.set("remoteip", ip);
  try {
    const r = await fetch("https://challenges.cloudflare.com/turnstile/v0/siteverify", { method: "POST", body, signal: AbortSignal.timeout(8000) });
    const j = await r.json();
    return j.success === true;                    // anything else (error, timeout, bad token) = refuse
  } catch {
    return false;                                 // fail CLOSED: if Cloudflare can't be reached, don't let bots in
  }
}

// Example form handler (Netlify Functions):
export default async (req) => {
  if (req.method !== "POST") return new Response("POST only", { status: 405 });
  const form = await req.formData().catch(() => null);
  if (!form) return new Response("Bad form", { status: 400 });
  const ok = await captchaOk(form.get("cf-turnstile-response"), req.headers.get("x-nf-client-connection-ip"));
  if (!ok) return new Response("Please complete the check", { status: 403 });
  // ...now handle the sign-up / contact message / vote
  return new Response("ok");
};
