-- Code Armour recipe: block bad display names IN THE DATABASE, so it can't be skipped from the browser.
-- Blocks: swearing/slurs (your list), emails, phone numbers, links, @handles; enforces length.
-- Honest limit: no filter is perfect. Keep a report button and remove what slips through.

create table if not exists public.banned_words (word text primary key);
alter table public.banned_words enable row level security;   -- no policies: nobody can read or edit the list from the app
-- Fill it (lowercase, no spaces): insert into public.banned_words (word) values ('exampleword'), ...;
-- Pick a maintained list for your languages. Short words cause false hits (the "Scunthorpe problem"), so test.

create or replace function public.name_problem(n text)
returns text
language plpgsql
stable
security definer           -- needed to read banned_words; safe: it only returns a message
set search_path = ''
as $$
declare
  flat text := translate(lower(regexp_replace(n, '[^a-zA-Z0-9@$]', '', 'g')), '013457@$', 'oieastas');
begin
  if n is null or char_length(btrim(n)) < 3 or char_length(n) > 20 then return 'Names must be 3 to 20 characters'; end if;
  if n ~* '[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}' then return 'No email addresses in names'; end if;
  if n ~ '([0-9][^0-9a-zA-Z]{0,2}){7,}' then return 'No phone numbers in names'; end if;
  if n ~* '(https?://|www\.|\.(com|net|org|io|gg|xyz|co|uk|me|tv|app|dev)\y)' then return 'No links in names'; end if;
  if n ~ '(^|\s)@[A-Za-z0-9_.]{2,}' then return 'No social media handles in names'; end if;
  if exists (select 1 from public.banned_words b where flat like '%' || b.word || '%') then
    return 'Please choose a different name';
  end if;
  return null;   -- null = name is fine
end;
$$;
revoke execute on function public.name_problem(text) from public, anon;
grant execute on function public.name_problem(text) to authenticated;  -- lets the app show the message before saving

create or replace function public.check_display_name()
returns trigger
language plpgsql
set search_path = ''
as $$
declare msg text;
begin
  if tg_op = 'INSERT' or new.display_name is distinct from old.display_name then
    msg := public.name_problem(new.display_name);
    if msg is not null then raise exception '%', msg; end if;
  end if;
  return new;
end;
$$;

drop trigger if exists check_display_name on public.profiles;
create trigger check_display_name
  before insert or update on public.profiles
  for each row execute function public.check_display_name();

-- TEST IT: update display_name to 'me@mail.com', 'call 07700900123', 'www.site.com', '@myhandle'
-- and a banned word with numbers swapped in (e.g. b4dw0rd). Each must be rejected.
