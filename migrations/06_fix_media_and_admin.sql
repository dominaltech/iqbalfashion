-- =========================================================================
-- Migration 06 — Fix Homepage Assets & Storage RLS for Guest Uploads
-- =========================================================================

-- 1. ADD MISSING SLOT COLUMN TO HOMEPAGE ASSETS
ALTER TABLE public.homepage_assets 
  ADD COLUMN IF NOT EXISTS slot text UNIQUE;

-- 2. UPDATE STORAGE BUCKETS RLS POLICIES FOR ANONYMOUS ADMIN PANEL
-- Drop the existing authenticated-only policies
DROP POLICY IF EXISTS "Authenticated Uploads to Products Bucket" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated Uploads to Homepage Bucket" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated Updates to Products Bucket" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated Updates to Homepage Bucket" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated Deletes from Products Bucket" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated Deletes from Homepage Bucket" ON storage.objects;

-- Create policies allowing public uploads for the admin panel (since we removed Auth)
CREATE POLICY "Public Uploads to Products Bucket"
  ON storage.objects FOR INSERT
  WITH CHECK ( bucket_id = 'products' );

CREATE POLICY "Public Uploads to Homepage Bucket"
  ON storage.objects FOR INSERT
  WITH CHECK ( bucket_id = 'homepage' );

CREATE POLICY "Public Updates to Products Bucket"
  ON storage.objects FOR UPDATE
  USING ( bucket_id = 'products' );

CREATE POLICY "Public Updates to Homepage Bucket"
  ON storage.objects FOR UPDATE
  USING ( bucket_id = 'homepage' );

CREATE POLICY "Public Deletes from Products Bucket"
  ON storage.objects FOR DELETE
  USING ( bucket_id = 'products' );

CREATE POLICY "Public Deletes from Homepage Bucket"
  ON storage.objects FOR DELETE
  USING ( bucket_id = 'homepage' );

-- 3. ALLOW PUBLIC INSERTS/UPDATES TO HOMEPAGE ASSETS TABLE
DROP POLICY IF EXISTS "Authenticated users can insert homepage assets." ON public.homepage_assets;
DROP POLICY IF EXISTS "Authenticated users can update homepage assets." ON public.homepage_assets;
DROP POLICY IF EXISTS "Authenticated users can delete homepage assets." ON public.homepage_assets;

CREATE POLICY "Public insert homepage assets"
  ON public.homepage_assets FOR INSERT
  WITH CHECK ( true );

CREATE POLICY "Public update homepage assets"
  ON public.homepage_assets FOR UPDATE
  USING ( true );

CREATE POLICY "Public delete homepage assets"
  ON public.homepage_assets FOR DELETE
  USING ( true );

-- 4. ALLOW PUBLIC INSERTS/UPDATES TO PRODUCTS TABLE
DROP POLICY IF EXISTS "Authenticated users can insert products." ON public.products;
DROP POLICY IF EXISTS "Authenticated users can update products." ON public.products;
DROP POLICY IF EXISTS "Authenticated users can delete products." ON public.products;

CREATE POLICY "Public insert products"
  ON public.products FOR INSERT
  WITH CHECK ( true );

CREATE POLICY "Public update products"
  ON public.products FOR UPDATE
  USING ( true );

CREATE POLICY "Public delete products"
  ON public.products FOR DELETE
  USING ( true );
