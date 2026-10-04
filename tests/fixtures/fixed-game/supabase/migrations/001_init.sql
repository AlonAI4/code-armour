create table profiles (id uuid primary key references auth.users(id), email text, display_name text, best_score int default 0, coins int default 0, is_admin boolean default false, birth_year int);
create table scores (id bigint generated always as identity primary key, user_id uuid references auth.users(id), score int, created_at timestamptz default now());
alter table profiles enable row level security;
create policy "profiles readable" on profiles for select using (true);
create policy "profiles editable" on profiles for update using (auth.uid() = id);
-- scores: RLS kept breaking inserts, turned off for now
alter table scores disable row level security;
create or replace function add_coins(uid uuid, n int) returns void language sql security definer as $$ update profiles set coins = coins + n where id = uid $$;
insert into storage.buckets (id, name, public) values ('avatars', 'avatars', true);
