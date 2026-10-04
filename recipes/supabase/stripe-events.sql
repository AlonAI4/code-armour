-- Code Armour recipe: remember which Stripe events were already handled (Stripe retries events,
-- so without this a purchase can be granted twice). Used by recipes/netlify/stripe-webhook.mjs
-- and recipes/payments/mor-webhooks.mjs.
create table if not exists public.stripe_events (
  id          text primary key,          -- Stripe event id, e.g. evt_...
  received_at timestamptz not null default now()
);
alter table public.stripe_events enable row level security;  -- no policies: server-only

-- Adds credits exactly once per Stripe event, in one step (record the event + add credits together),
-- so a retried or replayed event can never pay out twice. Server-only.
-- >>> CHANGE: public.profiles / credits to your table and column.
create or replace function public.add_credits_once(p_event text, p_user uuid, p_amount integer)
returns boolean
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.stripe_events (id) values (p_event) on conflict (id) do nothing;
  if not found then return false; end if;      -- seen before: do nothing
  update public.profiles set credits = credits + p_amount where id = p_user;
  return true;
end;
$$;
revoke execute on function public.add_credits_once(text, uuid, integer) from public, anon, authenticated;

-- Same idea for other webhook providers (Lemon Squeezy, Paddle): one row per event id.
create table if not exists public.webhook_events (
  id          text primary key,
  received_at timestamptz not null default now()
);
alter table public.webhook_events enable row level security;  -- no policies: server-only
