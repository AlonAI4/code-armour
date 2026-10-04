-- Code Armour: Supabase security audit. Read-only: safe to run anywhere.
-- Run in the SQL Editor, the Supabase MCP execute_sql tool, or `supabase db` tooling.
-- Every query should return 0 rows, or rows you can explain.

-- 1. Tables with RLS turned OFF (anyone with the public key can read/write them)
select 'RLS OFF' as problem, schemaname || '.' || tablename as object
from pg_tables where schemaname = 'public' and not rowsecurity

union all
-- 2. Tables with RLS on but NO policies (locked for everyone: fine if only the server uses it)
select 'RLS on, no policies (server-only?)', t.schemaname || '.' || t.tablename
from pg_tables t
where t.schemaname = 'public' and t.rowsecurity
  and not exists (select 1 from pg_policies p where p.schemaname = t.schemaname and p.tablename = t.tablename)

union all
-- 3. Policies that let EVERYONE through: using (true)
select 'policy allows everyone: ' || cmd || ' ' || policyname, schemaname || '.' || tablename
from pg_policies
where schemaname = 'public' and (qual = 'true' or with_check = 'true')

union all
-- 4. Write policies for anonymous (logged-out) users
select 'anon can ' || cmd || ': ' || policyname, schemaname || '.' || tablename
from pg_policies
where schemaname = 'public' and 'anon' = any(roles) and cmd in ('INSERT','UPDATE','DELETE','ALL')

union all
-- 5. UPDATE policies with no WITH CHECK (user could move a row to someone else)
select 'UPDATE without WITH CHECK: ' || policyname, schemaname || '.' || tablename
from pg_policies
where schemaname = 'public' and cmd in ('UPDATE','ALL') and with_check is null and qual is not null and qual <> 'false'

union all
-- 6. Policies trusting user_metadata (users can edit it themselves!)
select 'policy trusts user_metadata: ' || policyname, schemaname || '.' || tablename
from pg_policies
where schemaname = 'public' and (coalesce(qual,'') || coalesce(with_check,'')) ilike '%user_metadata%'

union all
-- 7. Views that skip RLS (no security_invoker)
select 'view skips RLS (set security_invoker = on)', n.nspname || '.' || c.relname
from pg_class c join pg_namespace n on n.oid = c.relnamespace
where n.nspname = 'public' and c.relkind in ('v','m')
  and not coalesce(array_to_string(c.reloptions, ',') ~* 'security_invoker=(on|true)', false)

union all
-- 8. Functions anyone (anon) can call over /rest/v1/rpc
select case when p.prosecdef then 'SECURITY DEFINER function callable by anon' else 'function callable by anon' end,
       n.nspname || '.' || p.proname || '(' || pg_get_function_identity_arguments(p.oid) || ')'
from pg_proc p join pg_namespace n on n.oid = p.pronamespace
where n.nspname = 'public' and has_function_privilege('anon', p.oid, 'execute')

union all
-- 9. Public storage buckets (every file readable by URL)
select 'public storage bucket', id from storage.buckets where public

union all
-- 10. Storage buckets with no size limit or type limit
select 'bucket has no file_size_limit / allowed_mime_types', id
from storage.buckets where file_size_limit is null or allowed_mime_types is null

order by 1;
