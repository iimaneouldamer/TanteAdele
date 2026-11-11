-- Planning Tante Adèle : à coller une seule fois dans Supabase (SQL Editor), puis cliquer sur Run.

create table if not exists public.docs (
  id text primary key,
  data jsonb not null,
  updated_at timestamptz not null default now()
);

alter table public.docs enable row level security;

-- Seules les personnes connectées (comptes créés par vous) peuvent lire et modifier.
drop policy if exists "equipe connectee" on public.docs;
create policy "equipe connectee" on public.docs
  for all to authenticated using (true) with check (true);

grant select, insert, update, delete on public.docs to authenticated;

-- Vos données déjà saisies (équipe et horaires du 7 novembre). Les 5 personnes sont placées aux Halles :
-- vous pourrez les déplacer vers Corgnac ou Landouge depuis l'onglet Équipe.
insert into public.docs (id, data) values
  ('config', '{"defaults": {"m": ["09:00", "12:00"], "a": ["13:30", "17:30"], "s": ["08:00", "16:00"]}, "employees": [{"id": "exy1pz9nu5k", "name": "Imane", "shop": "halles"}, {"id": "ecmeb4onxmb", "name": "Erdu", "shop": "halles"}, {"id": "eaex7r8o2jx", "name": "Sihem", "shop": "halles"}, {"id": "eauqfsho9sv", "name": "Bouahry", "shop": "halles"}, {"id": "eea96g9ohju", "name": "Melissa", "shop": "halles"}]}'::jsonb),
  ('m-2026-11', '{"shifts": {"ecmeb4onxmb": {"2026-11-07": {"a": ["13:30", "17:30"], "m": ["09:00", "12:00"]}}, "exy1pz9nu5k": {"2026-11-07": {"s": ["07:00", "14:20"]}}}}'::jsonb)
on conflict (id) do nothing;
