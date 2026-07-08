-- =========================================================================
-- Migration 03 — Profile age, Cart & Order History Logging
-- Iqbal Fashion Solapur
-- =========================================================================

-- 1. ADD AGE COLUMN TO PROFILES
alter table public.profiles
  add column if not exists age integer;

comment on column public.profiles.age is 'Optional age of the customer.';

-- 2. CREATE CART HISTORY TABLE (Text Format)
create table if not exists public.cart_history (
    id uuid default gen_random_uuid() primary key,
    user_id uuid references public.profiles(id) on delete cascade not null,
    cart_text text not null,
    updated_at timestamptz default now()
);

-- Enable RLS
alter table public.cart_history enable row level security;

-- Policies for Cart History
drop policy if exists "Users can manage their own cart history" on public.cart_history;
create policy "Users can manage their own cart history"
    on public.cart_history for all
    using ( auth.uid() = user_id )
    with check ( auth.uid() = user_id );

-- 3. CREATE ORDER HISTORY TABLE (Text Format)
create table if not exists public.order_history (
    id uuid default gen_random_uuid() primary key,
    user_id uuid references public.profiles(id) on delete cascade not null,
    order_id uuid,
    order_text text not null,
    total_amount numeric not null,
    created_at timestamptz default now()
);

-- Enable RLS
alter table public.order_history enable row level security;

-- Policies for Order History
drop policy if exists "Users can view their own order history" on public.order_history;
create policy "Users can view their own order history"
    on public.order_history for select
    using ( auth.uid() = user_id );

drop policy if exists "Users can insert their own order history" on public.order_history;
create policy "Users can insert their own order history"
    on public.order_history for insert
    with check ( auth.uid() = user_id );

-- 4. PERMIT ANONYMOUS INSERTS FOR LOCAL TESTING/DEVELOPMENT MODE
-- (For production, restrict this or ensure RLS matches your auth setup)
drop policy if exists "Allow anon manage cart history" on public.cart_history;
create policy "Allow anon manage cart history"
    on public.cart_history for all
    using ( true )
    with check ( true );

drop policy if exists "Allow anon manage order history" on public.order_history;
create policy "Allow anon manage order history"
    on public.order_history for all
    using ( true )
    with check ( true );
