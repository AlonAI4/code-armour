-- Code Armour recipe: remember which Stripe events were already handled (Stripe retries events,
-- so without this a purchase can be granted twice). Used by recipes/netlify/stripe-webhook.mjs.
create table if not exists public.stripe_events (
  id          text primary key,          -- Stripe event id, e.g. evt_...
  received_at timestamptz not null default now()
);
alter table public.stripe_events enable row level security;  -- no policies: server-only
