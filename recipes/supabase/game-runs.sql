-- Code Armour recipe: server-issued game sessions, used by submit-score.ts to reject impossible scores.
create table if not exists public.game_runs (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null references auth.users (id) on delete cascade,
  started_at timestamptz not null default now(),
  finished   boolean not null default false
);
alter table public.game_runs enable row level security;
-- Players may START a run for themselves; only the server finishes it.
create policy "start own run" on public.game_runs
  for insert to authenticated
  with check ((select auth.uid()) = user_id and finished = false);
revoke update, delete on public.game_runs from anon, authenticated;
-- The started_at default is set by the database; block clients from choosing it:
revoke insert on public.game_runs from anon, authenticated;
grant insert (user_id) on public.game_runs to authenticated;
-- Client: const { data } = await supabase.from('game_runs').insert({ user_id: me }).select('id').single()
-- (select needs a read policy:)
create policy "read own runs" on public.game_runs
  for select to authenticated
  using ((select auth.uid()) = user_id);
