create table if not exists public.app_state (
  user_id uuid primary key references auth.users(id) on delete cascade,
  progresso jsonb not null default '{}'::jsonb,
  meus jsonb not null default '{"juris":[],"questoes":[]}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.app_state enable row level security;

drop policy if exists "users_select_own_state" on public.app_state;
drop policy if exists "users_insert_own_state" on public.app_state;
drop policy if exists "users_update_own_state" on public.app_state;

create policy "users_select_own_state" on public.app_state for select to authenticated using ((select auth.uid()) = user_id);
create policy "users_insert_own_state" on public.app_state for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "users_update_own_state" on public.app_state for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);

grant select, insert, update on public.app_state to authenticated;
