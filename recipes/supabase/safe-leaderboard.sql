-- Code Armour recipe: a public leaderboard that can't leak emails, ids or private profile data.
-- The board lives in its OWN table holding only safe columns. Everyone can read it;
-- only your server (Edge Function with the service_role key) can write to it.

create table if not exists public.leaderboard (
  id           bigint generated always as identity primary key,
  user_id      uuid not null references auth.users (id) on delete cascade,  -- never selected publicly
  display_name text not null,
  score        integer not null check (score >= 0),
  created_at   timestamptz not null default now()
);

alter table public.leaderboard enable row level security;

-- Opt-in: only players who chose to appear. Add show_on_leaderboard boolean default false to profiles,
-- and have the server only insert rows for players who opted in.

-- Hide user_id from the public: grant SELECT only on the safe columns.
revoke all on public.leaderboard from anon, authenticated;
grant select (id, display_name, score, created_at) on public.leaderboard to anon, authenticated;

create policy "anyone can read the board" on public.leaderboard
  for select to anon, authenticated
  using (true);   -- fine HERE: the table only holds public columns, and writes are server-only

-- No insert/update/delete policies on purpose: the browser can't write scores.
-- Scores go in through recipes/supabase/submit-score.ts.

create index if not exists leaderboard_score_idx on public.leaderboard (score desc);

-- Client query: supabase.from('leaderboard').select('display_name, score').order('score', { ascending: false }).limit(50)
-- TEST IT: supabase.from('leaderboard').insert({ display_name: 'x', score: 999999 }) must fail;
--          supabase.from('leaderboard').select('user_id') must fail (permission denied).
