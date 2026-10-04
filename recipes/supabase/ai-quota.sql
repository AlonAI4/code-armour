-- Code Armour recipe: a per-user daily limit for AI calls (stops one user or bot running up your bill).
-- Used by recipes/netlify/ai-endpoint.mjs. Only your server can call it.

create table if not exists public.ai_usage (
  user_id uuid not null references auth.users (id) on delete cascade,
  day     date not null default current_date,
  count   integer not null default 0,
  primary key (user_id, day)
);
alter table public.ai_usage enable row level security;   -- no policies: server-only

-- Adds 1 and says whether the user is still under the limit. Atomic, so parallel requests can't sneak past.
create or replace function public.use_ai_quota(p_user uuid, p_limit integer)
returns boolean
language plpgsql
security definer
set search_path = ''
as $$
declare n integer;
begin
  insert into public.ai_usage (user_id, day, count)
  values (p_user, current_date, 1)
  on conflict (user_id, day) do update set count = public.ai_usage.count + 1
  returning count into n;
  return n <= p_limit;
end;
$$;

-- Nobody but the server (service_role) may call it.
revoke execute on function public.use_ai_quota(uuid, integer) from public, anon, authenticated;
