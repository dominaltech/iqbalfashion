-- =========================================================================
-- Migration 02 — Homepage Media Slots & Admin Upload Support
-- Iqbal Fashion Solapur
-- Run this AFTER 01_schema.sql
-- =========================================================================


-- =========================================================================
-- 1. EXTEND homepage_assets WITH POSITION AND SLOT FIELDS
-- =========================================================================
-- The existing `type` column values from 01_schema.sql were generic.
-- We now add a `slot` column to precisely identify WHICH asset a row controls.
-- Valid slot values:
--   Slider images  : 'slide_1', 'slide_2', 'slide_3'
--   Menu cat images: 'menu_men', 'menu_kids', 'menu_cloth'
--   Brand video    : 'brand_video'
--   (Legacy)       : 'reel'

alter table public.homepage_assets
  add column if not exists slot text,
  add column if not exists display_order integer default 0,
  add column if not exists is_active boolean default true;

-- Add a comment explaining each slot value
comment on column public.homepage_assets.slot is
  'Identifies the exact UI slot this asset fills.
   Slider images  : slide_1 | slide_2 | slide_3
   Menu categories: menu_men | menu_kids | menu_cloth
   Brand video    : brand_video
   Instagram reels: reel (legacy)';

comment on column public.homepage_assets.type is
  'Broad asset type: slide | menu_category | brand_video | reel';


-- =========================================================================
-- 2. SEED DEFAULT PLACEHOLDER ROWS (one row per slot)
-- These rows act as "upsert targets" so the admin can update them
-- without creating duplicates. file_url starts empty — admin uploads fill it.
-- =========================================================================
insert into public.homepage_assets (type, slot, title, file_url, display_order, is_active)
values
  ('slide',          'slide_1',    'Hero Slide 1',       '', 1, true),
  ('slide',          'slide_2',    'Hero Slide 2',       '', 2, true),
  ('slide',          'slide_3',    'Hero Slide 3',       '', 3, true),
  ('menu_category',  'menu_men',   'Men',                '', 1, true),
  ('menu_category',  'menu_kids',  'Kids',               '', 2, true),
  ('menu_category',  'menu_cloth', 'Cloth Piece',        '', 3, true),
  ('brand_video',    'brand_video','Brand Video',        '', 1, true)
on conflict do nothing;


-- =========================================================================
-- 3. UNIQUE CONSTRAINT ON slot (ensures only 1 active row per slot and supports upsert)
-- =========================================================================
alter table public.homepage_assets
  drop constraint if exists homepage_assets_slot_key;

alter table public.homepage_assets
  add constraint homepage_assets_slot_key unique (slot);


-- =========================================================================
-- 4. CART TABLE (for in-browser cart persistence across sessions)
-- =========================================================================
create table if not exists public.cart_items (
    id          uuid default gen_random_uuid() primary key,
    created_at  timestamptz default now(),
    user_id     uuid references public.profiles(id) on delete cascade not null,
    product_id  uuid references public.products(id) on delete cascade not null,
    quantity    integer default 1 check (quantity > 0),
    size        text,
    unique (user_id, product_id, size)
);

alter table public.cart_items enable row level security;

drop policy if exists "Users can manage their own cart." on public.cart_items;
create policy "Users can manage their own cart."
    on public.cart_items for all
    using ( auth.uid() = user_id )
    with check ( auth.uid() = user_id );


-- =========================================================================
-- 5. ADMIN UPLOAD POLICY — Allow unauthenticated uploads for dev mode
-- (REMOVE in production — restrict to authenticated + is_admin only)
-- =========================================================================
-- Allows the admin panel to upload files to the 'homepage' bucket
-- even when operating without a logged-in Supabase Auth session.
-- Safe for private/local admin panels.
drop policy if exists "Allow anon uploads to homepage bucket" on storage.objects;
create policy "Allow anon uploads to homepage bucket"
  on storage.objects for insert
  with check ( bucket_id = 'homepage' );

drop policy if exists "Allow anon uploads to products bucket" on storage.objects;
create policy "Allow anon uploads to products bucket"
  on storage.objects for insert
  with check ( bucket_id = 'products' );

-- Allow anon to UPDATE (replace) existing storage objects
drop policy if exists "Allow anon update homepage bucket" on storage.objects;
create policy "Allow anon update homepage bucket"
  on storage.objects for update
  using ( bucket_id = 'homepage' );

-- Allow homepage_assets upsert by anon (for admin panel without login)
drop policy if exists "Allow anon upsert homepage_assets" on public.homepage_assets;
create policy "Allow anon upsert homepage_assets"
  on public.homepage_assets for all
  using ( true )
  with check ( true );

-- Allow products insert/update/delete by anon (for admin panel without login)
drop policy if exists "Allow anon manage products" on public.products;
create policy "Allow anon manage products"
  on public.products for all
  using ( true )
  with check ( true );


-- =========================================================================
-- 6. PRODUCT FEATURED FLAG (for homepage gallery section)
-- =========================================================================
alter table public.products
  add column if not exists is_featured boolean default false,
  add column if not exists featured_order integer default 0;

comment on column public.products.is_featured is
  'When true, product appears in the homepage featured gallery section.';


-- =========================================================================
-- DONE — Run this in the Supabase SQL Editor
-- =========================================================================
