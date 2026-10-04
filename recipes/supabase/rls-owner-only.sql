-- Code Armour recipe: "each user can only see and change their own rows".
-- >>> CHANGE: `notes` and `user_id` to your table and owner column.
-- The owner column should be: user_id uuid references auth.users(id) on delete cascade
-- (so "delete my account" removes these rows too).
-- Plain words: RLS = Row Level Security, the database's own rules for who can touch each row.
-- These rules run on the server, so nobody can skip them from the browser.

alter table public.notes enable row level security;

-- The owner column fills itself in with the logged-in user's id.
alter table public.notes alter column user_id set default auth.uid();

create policy "read own" on public.notes
  for select to authenticated
  using ((select auth.uid()) = user_id);

create policy "insert own" on public.notes
  for insert to authenticated
  with check ((select auth.uid()) = user_id);

create policy "update own" on public.notes
  for update to authenticated
  using ((select auth.uid()) = user_id)        -- which rows you can pick
  with check ((select auth.uid()) = user_id);  -- and you can't hand them to someone else

create policy "delete own" on public.notes
  for delete to authenticated
  using ((select auth.uid()) = user_id);

-- Speeds up the policy check.
create index if not exists notes_user_id_idx on public.notes (user_id);

-- PROFILES: private by default. Same pattern, keyed on id (= auth.users.id):
--   alter table public.profiles enable row level security;
--   create policy "read own profile" on public.profiles for select to authenticated using ((select auth.uid()) = id);
--   create policy "update own profile" on public.profiles for update to authenticated
--     using ((select auth.uid()) = id) with check ((select auth.uid()) = id);
-- Anything public (leaderboards) comes from a separate safe table: see safe-leaderboard.sql.

-- TEST IT (Step 5): sign in as user B and run
--   supabase.from('notes').update({ title: 'hacked' }).eq('id', <user A's note id>)
-- It must change 0 rows. A logged-out select must return [].
