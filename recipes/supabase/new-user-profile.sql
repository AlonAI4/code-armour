-- Code Armour recipe: create a profile row automatically when someone signs up.
-- Without this, recipes that expect a profile (leaderboard, admin flag, delete account) break.
-- >>> CHANGE: public.profiles and its columns to match your app.
-- The starting name is a safe "Player1a2b3c". Don't copy a name from signup metadata here:
-- it hasn't been through the name filter, and a rejected name would make signup fail with a confusing error.
-- Let the user pick their real name afterwards (the name filter checks it then).

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer          -- runs as the owner, because the auth system (not the user) creates the row
set search_path = ''
as $$
begin
  insert into public.profiles (id, display_name)
  values (new.id, 'Player' || substr(replace(new.id::text, '-', ''), 1, 6))
  on conflict (id) do nothing;
  return new;
end;
$$;
revoke execute on function public.handle_new_user() from public, anon, authenticated;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- TEST IT: sign up a new user, then check public.profiles has a row for them with a "Player..." name.
