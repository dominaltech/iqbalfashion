-- Supabase Database Schema Migration
-- Iqbal Fashion Solapur

-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- =========================================================================
-- 1. STORAGE BUCKETS AUTOMATION
-- =========================================================================

-- Insert buckets for products and homepage assets
insert into storage.buckets (id, name, public)
values 
  ('products', 'products', true),
  ('homepage', 'homepage', true)
on conflict (id) do nothing;

-- Set up Row Level Security policies for Storage
-- Note: Supabase enables RLS on storage.objects by default.
create policy "Public Access to Products Bucket"
  on storage.objects for select
  using ( bucket_id = 'products' );

create policy "Public Access to Homepage Bucket"
  on storage.objects for select
  using ( bucket_id = 'homepage' );

create policy "Authenticated Uploads to Products Bucket"
  on storage.objects for insert
  with check ( bucket_id = 'products' and auth.role() = 'authenticated' );

create policy "Authenticated Uploads to Homepage Bucket"
  on storage.objects for insert
  with check ( bucket_id = 'homepage' and auth.role() = 'authenticated' );

create policy "Authenticated Updates to Products Bucket"
  on storage.objects for update
  using ( bucket_id = 'products' and auth.role() = 'authenticated' );

create policy "Authenticated Updates to Homepage Bucket"
  on storage.objects for update
  using ( bucket_id = 'homepage' and auth.role() = 'authenticated' );

create policy "Authenticated Deletes from Products Bucket"
  on storage.objects for delete
  using ( bucket_id = 'products' and auth.role() = 'authenticated' );

create policy "Authenticated Deletes from Homepage Bucket"
  on storage.objects for delete
  using ( bucket_id = 'homepage' and auth.role() = 'authenticated' );


-- =========================================================================
-- 2. PROFILES TABLE (Linked with Supabase Auth)
-- =========================================================================
create table public.profiles (
    id uuid references auth.users on delete cascade primary key,
    name text,
    email text,
    avatar_url text,
    phone text,
    address text,
    is_admin boolean default false,
    updated_at timestamptz default now()
);

-- Enable RLS for Profiles
alter table public.profiles enable row level security;

-- Profiles Policies
create policy "Public profiles are viewable by everyone."
    on public.profiles for select
    using ( true );

create policy "Users can update their own profile."
    on public.profiles for update
    using ( auth.uid() = id );

-- Trigger function to automatically create a profile when a new user signs up
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, name, email, avatar_url, updated_at)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'full_name', new.raw_user_meta_data->>'name', ''),
    new.email,
    coalesce(new.raw_user_meta_data->>'avatar_url', ''),
    now()
  )
  on conflict (id) do update
  set name = excluded.name,
      avatar_url = excluded.avatar_url,
      updated_at = now();
  return new;
end;
$$ language plpgsql security definer;

-- Bind Trigger to auth.users
create or replace trigger on_auth_user_created
    after insert on auth.users
    for each row execute procedure public.handle_new_user();


-- =========================================================================
-- 3. PRODUCTS TABLE
-- =========================================================================
create table public.products (
    id uuid default gen_random_uuid() primary key,
    created_at timestamptz default now(),
    title text not null,
    description text,
    price numeric not null,
    category text not null, -- 'mens', 'kids', 'cloth-piece'
    subcategory text not null, -- 'traditional', 'jeans', 'boys', 'girls', 'linen', 'cotton', 'silk', 'wool', etc.
    images text[] default '{}',
    material text,
    sizes text[] default '{}',
    stock integer default 100
);

-- Enable RLS for Products
alter table public.products enable row level security;

-- Products Policies
create policy "Products are viewable by everyone."
    on public.products for select
    using ( true );

create policy "Authenticated users can insert products."
    on public.products for insert
    with check ( auth.role() = 'authenticated' );

create policy "Authenticated users can update products."
    on public.products for update
    using ( auth.role() = 'authenticated' );

create policy "Authenticated users can delete products."
    on public.products for delete
    using ( auth.role() = 'authenticated' );


-- =========================================================================
-- 4. HOMEPAGE ASSETS TABLE
-- =========================================================================
create table public.homepage_assets (
    id uuid default gen_random_uuid() primary key,
    created_at timestamptz default now(),
    type text not null, -- 'slide', 'reel', 'brand-video'
    title text,
    subtitle_or_desc text,
    file_url text not null,
    link_url text
);

-- Enable RLS for Homepage Assets
alter table public.homepage_assets enable row level security;

-- Policies for Homepage Assets
create policy "Homepage assets are viewable by everyone."
    on public.homepage_assets for select
    using ( true );

create policy "Authenticated users can insert homepage assets."
    on public.homepage_assets for insert
    with check ( auth.role() = 'authenticated' );

create policy "Authenticated users can update homepage assets."
    on public.homepage_assets for update
    using ( auth.role() = 'authenticated' );

create policy "Authenticated users can delete homepage assets."
    on public.homepage_assets for delete
    using ( auth.role() = 'authenticated' );


-- =========================================================================
-- 5. ORDERS TABLE
-- =========================================================================
create table public.orders (
    id uuid default gen_random_uuid() primary key,
    created_at timestamptz default now(),
    user_id uuid references public.profiles(id) on delete cascade not null,
    items jsonb not null,
    total_amount numeric not null,
    status text default 'pending',
    shipping_name text,
    shipping_email text,
    shipping_address text not null,
    shipping_phone text not null
);

-- Enable RLS for Orders
alter table public.orders enable row level security;

-- Orders Policies
create policy "Users can view their own orders."
    on public.orders for select
    using ( auth.uid() = user_id );

create policy "Users can insert their own orders."
    on public.orders for insert
    with check ( auth.uid() = user_id );

create policy "Admins can view all orders."
    on public.orders for select
    using ( 
        exists (
            select 1 from public.profiles 
            where profiles.id = auth.uid() and profiles.is_admin = true
        )
    );

create policy "Admins can update all orders."
    on public.orders for update
    using ( 
        exists (
            select 1 from public.profiles 
            where profiles.id = auth.uid() and profiles.is_admin = true
        )
    );
