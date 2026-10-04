-- Code Armour recipe: nobody can make themselves admin, or give themselves credits / pro / score.
-- "Update own row" policies allow changing EVERY column in that row, so we lock the dangerous ones.
-- Two layers (use both):

-- Layer 1: column grants. Logged-in users may only update the harmless columns you list.
revoke update on public.profiles from authenticated, anon;
grant update (display_name, avatar_url) on public.profiles to authenticated;   -- list your safe columns

-- Layer 2: a trigger that rejects any change to privileged columns unless it comes from your server
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
