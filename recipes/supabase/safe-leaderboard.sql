-- Code Armour recipe: a public leaderboard that can't leak emails, ids or private profile data.
-- One row per player (their best score). Everyone can read it; only your server writes to it.
-- >>> CHANGE: public.profiles / display_name to match your app. Needs a profiles table (see new-user-profile.sql).

-- Players choose to appear (opt-in, private by default: important for kids).
alter table public.profiles add column if not exists show_on_leaderboard boolean not null default false;
grant update (show_on_leaderboard) on public.profiles to authenticated;

create table if not exists public.leaderboard (
  user_id      uuid primary key references auth.users (id) on delete cascade,  -- never readable publicly
  display_name text not null,
  score        integer not null check (score >= 0),
  updated_at   timestamptz not null default now()
);
alter table public.leaderboard enable row level security;

-- Hide user_id: the public may only read the safe columns.
revoke all on public.leaderboard from anon, authenticated;
grant select (display_name, score, updated_at) on public.leaderboard to anon, authenticated;

create policy "anyone can read the board" on public.leaderboard
  for select to anon, authenticated
  using (true);   -- fine HERE: only public columns are readable, and nobody but the server can write

-- The only way in: called by your server (submit-score.ts) with the service_role key.
-- Keeps each player's BEST score, and only for players who opted in.
create or replace function public.record_score(p_user uuid, p_score integer)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare p record;
begin
  select display_name, show_on_leaderboard into p from public.profiles where id = p_user;
  if not found or not p.show_on_leaderboard then return; end if;
  insert into public.leaderboard (user_id, display_name, score) values (p_user, p.display_name, p_score)
  on conflict (user_id) do update
    set score = greatest(public.leaderboard.score, excluded.score),
        display_name = excluded.display_name,
        updated_at = now();
end;
$$;
revoke execute on function public.record_score(uuid, integer) from public, anon, authenticated;

-- Keep the board in sync: renaming updates it, opting out removes you from it.
create or replace function public.sync_leaderboard()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if not new.show_on_leaderboard then
    delete from public.leaderboard where user_id = new.id;
  else
    update public.leaderboard set display_name = new.display_name where user_id = new.id;
  end if;
  return new;
end;
$$;
drop trigger if exists sync_leaderboard on public.profiles;
create trigger sync_leaderboard
  after update of display_name, show_on_leaderboard on public.profiles
  for each row execute function public.sync_leaderboard();

create index if not exists leaderboard_score_idx on public.leaderboard (score desc);

-- Client: supabase.from('leaderboard').select('display_name, score').order('score', { ascending: false }).limit(50)
-- TEST IT: inserting into leaderboard or selecting user_id as a player must fail; a lower score must not
-- replace a higher one; opting out must remove you; renaming must update the board.
