-- Code Armour recipe: spend coins/credits safely (security.md 15.22, double-spend races).
-- "Read balance, check, then write" in two steps lets 20 requests sent at once spend the same coins 20 times.
-- Here the check and the change happen in ONE statement, so it can't overspend, go negative, or be raced.
-- >>> CHANGE: public.profiles / coins to your table and column. Call it only from your server (service_role).

create or replace function public.spend_coins(p_user uuid, p_amount integer)
returns integer            -- the new balance, or null if they couldn't afford it
language plpgsql
security definer
set search_path = ''
as $$
declare new_balance integer;
begin
  if p_amount is null or p_amount <= 0 then raise exception 'amount must be positive'; end if;
  update public.profiles
     set coins = coins - p_amount
   where id = p_user and coins >= p_amount        -- the check is part of the update itself
  returning coins into new_balance;
  return new_balance;                             -- null = not enough coins (nothing changed)
end;
$$;
revoke execute on function public.spend_coins(uuid, integer) from public, anon, authenticated;

-- One-time coupons / free trials / daily rewards: a unique row per (user, thing) makes "claim twice" impossible,
-- even with parallel requests.
create table if not exists public.claims (
  user_id    uuid not null references auth.users (id) on delete cascade,
  thing      text not null,                 -- e.g. 'coupon:WELCOME10', 'daily:2026-10-05', 'trial'
  claimed_at timestamptz not null default now(),
  primary key (user_id, thing)
);
alter table public.claims enable row level security;   -- no policies: server-only

create or replace function public.claim_once(p_user uuid, p_thing text)
returns boolean            -- true the first time, false ever after
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.claims (user_id, thing) values (p_user, p_thing) on conflict do nothing;
  return found;
end;
$$;
revoke execute on function public.claim_once(uuid, text) from public, anon, authenticated;

-- TEST IT (Step 5): seq 20 | xargs -P20 -I{} curl ... to your spend endpoint with 100 coins and a price of 10:
-- exactly 10 succeed and the balance ends at 0, never below.
