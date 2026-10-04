-- Code Armour fixes for Blob Jumper (adapted from the recipes). Read each block before applying.
-- Apply to a DEV project / branch first, never straight to production.

-- ---------- 0. Tidy up: data we don't need, and deletes that actually work ----------
alter table public.profiles drop column if exists email;       -- already in auth.users; don't copy it into a table
alter table public.profiles drop column if exists birth_year;  -- we only ask age once in the browser; we don't store it
alter table public.profiles add column if not exists show_on_leaderboard boolean not null default false;
alter table public.profiles alter column display_name set default 'Player';

-- Deleting an auth user must cascade (profiles/scores pointed at auth.users WITHOUT cascade -> delete failed)
alter table public.profiles drop constraint if exists profiles_id_fkey;
alter table public.profiles add constraint profiles_id_fkey foreign key (id) references auth.users (id) on delete cascade;
alter table public.scores drop constraint if exists scores_user_id_fkey;
alter table public.scores add constraint scores_user_id_fkey foreign key (user_id) references auth.users (id) on delete cascade;

-- ---------- 1. RLS everywhere ----------
alter table public.scores enable row level security;      -- was turned OFF
drop policy if exists "profiles readable" on public.profiles;   -- was using (true): everyone could read every profile
drop policy if exists "profiles editable" on public.profiles;
create policy "read own profile" on public.profiles for select to authenticated
  using ((select auth.uid()) = id);
create policy "update own profile" on public.profiles for update to authenticated
  using ((select auth.uid()) = id) with check ((select auth.uid()) = id);
-- scores: players may read their own; nobody writes from the browser (submit-score Edge Function does).
create policy "read own scores" on public.scores for select to authenticated
  using ((select auth.uid()) = user_id);
revoke insert, update, delete on public.scores from anon, authenticated;
revoke all on public.scores from anon;
revoke insert, delete on public.profiles from anon, authenticated;

-- ---------- 2. Nobody can edit privileged columns (is_admin, coins, best_score) ----------
revoke update on public.profiles from authenticated, anon;
grant update (display_name, show_on_leaderboard) on public.profiles to authenticated;

create or replace function public.protect_privileged_columns()
returns trigger language plpgsql set search_path = '' as $$
begin
  if current_user in ('authenticated', 'anon') then
    if tg_op = 'INSERT' then
      new.is_admin := false; new.coins := 0; new.best_score := 0;
    elsif new.is_admin   is distinct from old.is_admin
       or new.coins      is distinct from old.coins
       or new.best_score is distinct from old.best_score then
      raise exception 'Only the server can change is_admin, coins or best_score';
    end if;
  end if;
  return new;
end; $$;
drop trigger if exists protect_privileged_columns on public.profiles;
create trigger protect_privileged_columns before insert or update on public.profiles
  for each row execute function public.protect_privileged_columns();

-- ---------- 3. add_coins was SECURITY DEFINER and callable by ANYONE -> free coins for anyone ----------
revoke execute on function public.add_coins(uuid, int) from public, anon, authenticated;
grant execute on function public.add_coins(uuid, int) to service_role;
create or replace function public.add_coins(uid uuid, n int) returns void
  language sql security definer set search_path = '' as
  $$ update public.profiles set coins = coins + n where id = uid and n > 0 $$;
revoke execute on function public.add_coins(uuid, int) from public, anon, authenticated;

-- ---------- 4. Names: checked in the database ----------
create table if not exists public.banned_words (word text primary key);
alter table public.banned_words enable row level security;
-- TODO(owner): fill with a maintained word list for your languages (lowercase). Empty = no swear filter!

create or replace function public.name_problem(n text) returns text
language plpgsql stable security definer set search_path = '' as $$
declare
  flat text := translate(lower(regexp_replace(coalesce(n,''), '[^a-zA-Z0-9@$]', '', 'g')), '013457@$', 'oieastas');
begin
  if n is null or char_length(btrim(n)) < 3 or char_length(n) > 20 then return 'Names must be 3 to 20 characters'; end if;
  if n ~* '[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}' then return 'No email addresses in names'; end if;
  if n ~ '([0-9][^0-9a-zA-Z]{0,2}){7,}' then return 'No phone numbers in names'; end if;
  if n ~* '(https?://|www\.|\.(com|net|org|io|gg|xyz|co|uk|me|tv|app|dev)\y)' then return 'No links in names'; end if;
  if n ~ '(^|\s)@[A-Za-z0-9_.]{2,}' then return 'No social media handles in names'; end if;
  if n ~ '[<>&"]' then return 'Letters, numbers and spaces only please'; end if;
  if exists (select 1 from public.banned_words b where flat like '%' || b.word || '%') then
    return 'Please choose a different name';
  end if;
  return null;
end; $$;
revoke execute on function public.name_problem(text) from public, anon;
grant execute on function public.name_problem(text) to authenticated;

create or replace function public.check_display_name() returns trigger
language plpgsql set search_path = '' as $$
declare msg text;
begin
  if tg_op = 'INSERT' or new.display_name is distinct from old.display_name then
    msg := public.name_problem(new.display_name);
    if msg is not null then raise exception '%', msg; end if;
  end if;
  return new;
end; $$;
drop trigger if exists check_display_name on public.profiles;
create trigger check_display_name before insert or update on public.profiles
  for each row execute function public.check_display_name();

-- ---------- 5. Profile is created when someone signs up (there was no trigger, so profiles never existed) ----------
create or replace function public.handle_new_user() returns trigger
language plpgsql security definer set search_path = '' as $$
declare wanted text := new.raw_user_meta_data ->> 'display_name';
begin
  if wanted is null or public.name_problem(wanted) is not null then
    wanted := 'Player' || substr(replace(new.id::text, '-', ''), 1, 6);   -- bad name -> safe default, signup still works
  end if;
  insert into public.profiles (id, display_name) values (new.id, wanted);
  return new;
end; $$;
revoke execute on function public.handle_new_user() from public, anon, authenticated;
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users
  for each row execute function public.handle_new_user();

-- ---------- 6. Safe public leaderboard: its own table, safe columns only, one row per player ----------
create table if not exists public.leaderboard (
  user_id      uuid primary key references auth.users (id) on delete cascade,  -- never selectable
  display_name text not null,
  score        integer not null check (score >= 0),
  updated_at   timestamptz not null default now()
);
alter table public.leaderboard enable row level security;
revoke all on public.leaderboard from anon, authenticated;
grant select (display_name, score, updated_at) on public.leaderboard to anon, authenticated;
create policy "anyone can read the board" on public.leaderboard for select to anon, authenticated using (true);
create index if not exists leaderboard_score_idx on public.leaderboard (score desc);

-- keep the board in step with the profile: opting out or renaming updates it
create or replace function public.sync_leaderboard() returns trigger
language plpgsql security definer set search_path = '' as $$
begin
  if new.show_on_leaderboard is not true then
    delete from public.leaderboard where user_id = new.id;
  elsif new.display_name is distinct from old.display_name then
    update public.leaderboard set display_name = new.display_name where user_id = new.id;
  end if;
  return new;
end; $$;
revoke execute on function public.sync_leaderboard() from public, anon, authenticated;
drop trigger if exists sync_leaderboard on public.profiles;
create trigger sync_leaderboard after update on public.profiles
  for each row execute function public.sync_leaderboard();

-- ---------- 7. Game runs (server clock) + atomic score submit used by the Edge Function ----------
create table if not exists public.game_runs (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null references auth.users (id) on delete cascade,
  started_at timestamptz not null default now(),
  finished   boolean not null default false
);
alter table public.game_runs enable row level security;
create policy "start own run" on public.game_runs for insert to authenticated
  with check ((select auth.uid()) = user_id and finished = false);
create policy "read own runs" on public.game_runs for select to authenticated
  using ((select auth.uid()) = user_id);
revoke all on public.game_runs from anon, authenticated;
grant select on public.game_runs to authenticated;
grant insert (user_id) on public.game_runs to authenticated;

-- ---------- 8. Stripe: each event handled once; AI quota ----------
create table if not exists public.stripe_events (id text primary key, received_at timestamptz not null default now());
alter table public.stripe_events enable row level security;
revoke all on public.stripe_events from anon, authenticated;

create table if not exists public.ai_usage (
  user_id uuid not null references auth.users (id) on delete cascade,
  day date not null default current_date, count integer not null default 0, primary key (user_id, day));
alter table public.ai_usage enable row level security;
revoke all on public.ai_usage from anon, authenticated;
create or replace function public.use_ai_quota(p_user uuid, p_limit integer) returns boolean
language plpgsql security definer set search_path = '' as $$
declare n integer;
begin
  insert into public.ai_usage (user_id, day, count) values (p_user, current_date, 1)
  on conflict (user_id, day) do update set count = public.ai_usage.count + 1
  returning count into n;
  return n <= p_limit;
end; $$;
revoke execute on function public.use_ai_quota(uuid, integer) from public, anon, authenticated;
grant execute on function public.use_ai_quota(uuid, integer) to service_role;

-- ---------- 9. Storage: avatars were PUBLIC with no limits ----------
update storage.buckets set public = false, file_size_limit = 1048576,
  allowed_mime_types = array['image/png','image/jpeg','image/webp'] where id = 'avatars';
create policy "avatars: own folder read" on storage.objects for select to authenticated
  using (bucket_id = 'avatars' and (storage.foldername(name))[1] = (select auth.uid())::text);
create policy "avatars: own folder write" on storage.objects for insert to authenticated
  with check (bucket_id = 'avatars' and (storage.foldername(name))[1] = (select auth.uid())::text);
create policy "avatars: own folder delete" on storage.objects for delete to authenticated
  using (bucket_id = 'avatars' and (storage.foldername(name))[1] = (select auth.uid())::text);
