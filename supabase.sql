-- 1. Cria a tabela caso não exista
create table if not exists public.app_state (
  user_id uuid primary key references auth.users(id) on delete cascade,
  progresso jsonb not null default '{}'::jsonb,
  meus jsonb not null default '{"juris":[],"questoes":[],"simulados":[],"excluidos":[]}'::jsonb,
  updated_at timestamptz not null default now()
);

-- 2. Garante o novo padrão na coluna para novos usuários
alter table public.app_state 
  alter column meus set default '{"juris":[],"questoes":[],"simulados":[],"excluidos":[]}'::jsonb;

-- 3. Atualiza os registros já existentes no banco para conterem a chave "simulados" caso esteja ausente
update public.app_state
set meus = jsonb_set(
  case 
    when meus ? 'simulados' then meus 
    else meus || '{"simulados":[]}'::jsonb 
  end,
  '{excluidos}',
  coalesce(meus->'excluidos', '[]'::jsonb)
)
where not (meus ? 'simulados') or not (meus ? 'excluidos');

-- 4. Habilita e configura as políticas de RLS
alter table public.app_state enable row level security;

drop policy if exists "users_select_own_state" on public.app_state;
drop policy if exists "users_insert_own_state" on public.app_state;
drop policy if exists "users_update_own_state" on public.app_state;

create policy "users_select_own_state" on public.app_state 
  for select to authenticated 
  using ((select auth.uid()) = user_id);

create policy "users_insert_own_state" on public.app_state 
  for insert to authenticated 
  with check ((select auth.uid()) = user_id);

create policy "users_update_own_state" on public.app_state 
  for update to authenticated 
  using ((select auth.uid()) = user_id) 
  with check ((select auth.uid()) = user_id);

grant select, insert, update on public.app_state to authenticated;