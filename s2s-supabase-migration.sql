-- S2S: run once in the Supabase SQL editor.

-- 1) Feedback from the new "Rate this app" screen
create table if not exists public.app_feedback (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  rating int not null check (rating between 1 and 5),
  text text default '',
  created_at timestamptz not null default now()
);
alter table public.app_feedback enable row level security;
drop policy if exists "insert own feedback" on public.app_feedback;
create policy "insert own feedback" on public.app_feedback
  for insert to authenticated with check (user_id = auth.uid());

-- 2) Server-side due-date reminders (works while nobody has the app open).
--    Uses the same de-dupe key as the client: due:<listing>:<due ms>:<soon|overdue>:<user>
create or replace function public.send_due_reminders() returns void
language plpgsql security definer set search_path = public as $$
declare
  l record; uid uuid; phase text; k text; emoji text; due_txt text;
begin
  for l in
    select id, title, kind, seller_id, rented_to, due_date
    from listings
    where status = 'rented' and due_date is not null and rented_to is not null
      and due_date <= now() + interval '24 hours'
  loop
    phase  := case when l.due_date < now() then 'overdue' else 'soon' end;
    emoji  := case l.kind when 'notes' then '📗' when 'pyq' then '📝' else '📘' end;
    due_txt := to_char(l.due_date at time zone 'Asia/Kolkata', 'FMDD Mon');
    foreach uid in array array[l.seller_id, l.rented_to] loop
      k := format('due:%s:%s:%s:%s', l.id, floor(extract(epoch from l.due_date) * 1000)::bigint, phase, uid);
      if not exists (select 1 from notifications n where n.user_id = uid and n.action->>'key' = k) then
        insert into notifications (user_id, icon, title, text, action)
        values (
          uid,
          case when phase = 'overdue' then '⚠️' else '⏰' end,
          case when phase = 'overdue' then 'Return overdue' else 'Return due soon' end,
          format('%s %s — %s %s', emoji, l.title, case when phase = 'overdue' then 'was due' else 'due' end, due_txt),
          case when uid = l.seller_id
               then jsonb_build_object('view','myitems','key',k)
               else jsonb_build_object('view','requests','tab','sent','key',k) end
        );
      end if;
    end loop;
  end loop;
end $$;

-- Needs the pg_cron extension (Database → Extensions). Runs hourly.
create extension if not exists pg_cron;
select cron.unschedule('s2s-due-reminders') where exists (select 1 from cron.job where jobname = 's2s-due-reminders');
select cron.schedule('s2s-due-reminders', '0 * * * *', $$select public.send_due_reminders()$$);
