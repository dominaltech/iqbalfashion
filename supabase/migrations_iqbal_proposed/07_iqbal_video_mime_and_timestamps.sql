-- ==============================================================================
-- IQBAL FASHION — MIGRATION 07: VIDEO STORAGE MIME TYPES & TIMESTAMP CACHE SYNC
-- Safe, additive migration (Run this in Supabase SQL Editor after Migration 06)
-- ==============================================================================

-- 1. EXTEND STORAGE BUCKETS FOR VIDEO UPLOADS (MP4, WEBM, OGG, MOV) UP TO 50MB
UPDATE storage.buckets
SET 
  allowed_mime_types = ARRAY[
    'image/jpeg', 'image/png', 'image/webp', 'image/gif', 'image/svg+xml',
    'video/mp4', 'video/webm', 'video/ogg', 'video/quicktime'
  ],
  file_size_limit = 52428800 -- 50 MB
WHERE id IN ('banner-images', 'product-images');

-- Ensure storage policies permit video MIME types
DROP POLICY IF EXISTS "Public Video And Images Storage Access" ON storage.objects;
CREATE POLICY "Public Video And Images Storage Access"
ON storage.objects FOR ALL
TO public
USING (bucket_id IN ('banner-images', 'product-images'))
WITH CHECK (bucket_id IN ('banner-images', 'product-images'));

-- 2. ADD updated_at COLUMNS TO BANNERS & STORE_SETTINGS FOR MICRO-BYTE CACHE INVALIDATION
ALTER TABLE public.banners ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ DEFAULT NOW();
ALTER TABLE public.store_settings ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ DEFAULT NOW();
ALTER TABLE public.store_settings ADD COLUMN IF NOT EXISTS home_video_frame_mode TEXT DEFAULT 'auto';

-- Populate updated_at for existing rows
UPDATE public.banners SET updated_at = NOW() WHERE updated_at IS NULL;
UPDATE public.store_settings SET updated_at = NOW() WHERE updated_at IS NULL;

-- 3. AUTO-UPDATE TRIGGER FUNCTION FOR updated_at
CREATE OR REPLACE FUNCTION public.handle_updated_at_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger for banners
DROP TRIGGER IF EXISTS trigger_banners_updated_at ON public.banners;
CREATE TRIGGER trigger_banners_updated_at
  BEFORE UPDATE ON public.banners
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_updated_at_timestamp();

-- Trigger for store_settings
DROP TRIGGER IF EXISTS trigger_store_settings_updated_at ON public.store_settings;
CREATE TRIGGER trigger_store_settings_updated_at
  BEFORE UPDATE ON public.store_settings
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_updated_at_timestamp();

-- Trigger for products (if not already existing)
DROP TRIGGER IF EXISTS trigger_products_updated_at ON public.products;
CREATE TRIGGER trigger_products_updated_at
  BEFORE UPDATE ON public.products
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_updated_at_timestamp();

-- ==============================================================================
-- END OF MIGRATION 07
-- ==============================================================================
