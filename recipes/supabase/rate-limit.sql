-- Code Armour recipe: a simple rate limiter inside the database (login attempts, sign-ups, contact forms,
-- "generate" buttons). Atomic, so parallel requests can't sneak past. Call it from your server.
--   select public.rate_limit_hit('login:' || ip, 60, 5)   -- true = allowed, false = too many (send 429)
create table if not exists public.rate_limits (
  key          text not null,
  window_start timestamptz not null,
  hits         integer not null default 0,
  primary key (key, window_start)
);
alter table public.rate_limits enable row level security;   -- no policies: server-only

create or replace function public.rate_limit_hit(p_key text, p_window_seconds integer, p_max integer)
returns boolean
language plpgsql
security definer
set search_path = ''
as $$
declare w timestamptz := to_timestamp(floor(extract(epoch from now()) / p_window_seconds) * p_window_seconds);
        n integer;
begin
  insert into public.rate_limits (key, window_start, hits) values (p_key, w, 1)
  on conflict (key, window_start) do update set hits = public.rate_limits.hits + 1
  returning hits into n;
  return n <= p_max;
end;
$$;
revoke execute on function public.rate_limit_hit(text, integer, integer) from public, anon, authenticated;
-- Housekeeping (e.g. a daily cron): delete from public.rate_limits where window_start < now() - interval '1 day';
