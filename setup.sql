-- Таблица для хранения всех данных пользователя
create table if not exists user_data (
  user_id uuid references auth.users(id) on delete cascade primary key,
  tasks jsonb not null default '[]',
  energy jsonb not null default '{}',
  brain_dump text not null default '',
  updated_at timestamptz default now()
);

-- RLS: каждый видит только свои данные
alter table user_data enable row level security;

create policy "Own data only"
  on user_data for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);
