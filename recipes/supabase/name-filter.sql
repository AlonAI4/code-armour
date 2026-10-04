-- Code Armour recipe: block bad display names IN THE DATABASE, so it can't be skipped from the browser.
-- Blocks: swearing/slurs (your list), emails, phone numbers, links, @handles; enforces length.
-- Handles look-alike letters (Cyrillic/Greek), fullwidth text, invisible characters, number swaps
-- and "me at gmail dot com". Honest limit: no filter is perfect. Keep a report button and remove what slips through.
-- Known limit: random characters standing in for letters (e.g. "b8dw0rd") still get through.
-- An EMPTY banned_words list means the swear filter is OFF.

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
  -- 1. NFKC turns fullwidth/stylised characters into normal ones (ｂａｄ -> bad, ０７７ -> 077, ＠ -> @).
  norm text := replace(replace(normalize(coalesce(n, ''), NFKC), '。', '.'), '｡', '.');
  flat text;
begin
  -- 2. Invisible characters (zero-width spaces, direction tricks, soft hyphens) are never OK in a name.
  if norm ~ '[\u00AD\u200B-\u200F\u202A-\u202E\u2060-\u2064\uFEFF]' then return 'Names can''t contain invisible characters'; end if;
  if char_length(btrim(norm)) < 3 or char_length(norm) > 20 then return 'Names must be 3 to 20 characters'; end if;
  if norm ~* '[a-z0-9._%+-]+@[a-z0-9-]+[.,]' or norm ~* '\y(at)\y.*\y(dot)\y' then return 'No email addresses in names'; end if;
  if norm ~ '([0-9][^0-9a-zA-Z]{0,2}){7,}' then return 'No phone numbers in names'; end if;
  if norm ~* '(https?://|www\.|\.[a-z]{2,24}\y)' then return 'No links in names'; end if;
  if norm ~ '(^|\s)@[A-Za-z0-9_.]{2,}' then return 'No social media handles in names'; end if;
  -- 3. For the word check: swap look-alike Cyrillic/Greek letters for Latin ones, drop everything else,
  --    then undo number/symbol swaps (b4dw0rd -> badword).
  flat := translate(norm, 'аеорсхуікјѕԁһԛԝАВЕКМНОРСТХІЈЅαεοτυνικρχΑΒΕΖΗΙΚΜΝΟΡΤΥΧ', 'aeopcxyikjsdhqwabekmhopctxijsaeotuvikpxabezhikmnoptyx');
  flat := regexp_replace(lower(flat), '[^a-z0-9@$]', '', 'g');
  flat := translate(flat, '0123456789@$', 'oizeasgtbgas');
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
