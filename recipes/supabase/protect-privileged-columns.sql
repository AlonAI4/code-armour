-- Code Armour recipe: nobody can make themselves admin, or give themselves credits / pro / score.
-- "Update own row" policies allow changing EVERY column in that row, so we lock the dangerous ones.
--
-- >>> CHANGE BEFORE RUNNING (every name must exist in YOUR table, or this errors):
--   table:              public.profiles
--   safe columns:       display_name, avatar_url          (users may edit these)  -> Layer 1 grant list
--   privileged columns: is_admin, credits, is_pro         (server only)           -> Layer 2 trigger
--   e.g. a game might use coins, best_score, level instead of credits, is_pro.
--
-- Two layers (use both):

-- Layer 1: column grants. Logged-in users may only update the harmless columns you list.
revoke update on public.profiles from authenticated, anon;
grant update (display_name, avatar_url) on public.profiles to authenticated;   -- list your safe columns
-- Same for creating a profile, or a player could create theirs with coins = 999999.
-- (Best: let new-user-profile.sql create profiles on the server, then users never insert at all.)
revoke insert on public.profiles from authenticated, anon;
grant insert (id, display_name, avatar_url) on public.profiles to authenticated;

-- Layer 2 (backup, in case a grant is ever widened by mistake): a trigger that rejects any change to privileged columns unless it comes from your server
-- (the service_role key used in Edge Functions / Netlify Functions / Stripe webhook).
create or replace function public.protect_privileged_columns()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if current_user in ('authenticated', 'anon') then
    if tg_op = 'INSERT' then
      -- new rows always start with no powers
      new.is_admin := false;
      new.credits  := 0;
      new.is_pro   := false;
    elsif new.is_admin is distinct from old.is_admin
       or new.credits  is distinct from old.credits
       or new.is_pro   is distinct from old.is_pro then
      raise exception 'Only the server can change is_admin, credits or is_pro';
    end if;
  end if;
  return new;
end;
$$;

drop trigger if exists protect_privileged_columns on public.profiles;
create trigger protect_privileged_columns
  before insert or update on public.profiles
  for each row execute function public.protect_privileged_columns();

-- Change is_admin / credits / is_pro / plan only from server code using the service_role key.
-- Never decide "is admin?" from user_metadata (users can edit it). Use this column or app_metadata.

-- TEST IT: signed in as a normal user, run
--   supabase.from('profiles').update({ is_admin: true }).eq('id', myId)
-- It must return an error.
