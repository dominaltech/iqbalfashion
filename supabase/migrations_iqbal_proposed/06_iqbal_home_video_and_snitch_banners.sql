-- ==============================================================================
-- IQBAL FASHION — MIGRATION 06: HOME VIDEO SHOWCASE & SNITCH HERO BANNERS
-- Manageable dynamically from Admin Panel via Supabase
-- ==============================================================================

-- 1. Extend banners table to support dedicated mobile banner images, video URLs, and sections
ALTER TABLE public.banners ADD COLUMN IF NOT EXISTS mobile_image_url TEXT;
ALTER TABLE public.banners ADD COLUMN IF NOT EXISTS video_url TEXT;
ALTER TABLE public.banners ADD COLUMN IF NOT EXISTS section TEXT DEFAULT 'hero';

-- 2. Extend store_settings table to support global homepage background video showcase
ALTER TABLE public.store_settings ADD COLUMN IF NOT EXISTS home_video_url TEXT DEFAULT 'https://assets.mixkit.co/videos/preview/mixkit-tailor-working-on-a-suit-jacket-41394-large.mp4';
ALTER TABLE public.store_settings ADD COLUMN IF NOT EXISTS home_video_title TEXT DEFAULT 'THE BESPOKE EXPERIENCE';
ALTER TABLE public.store_settings ADD COLUMN IF NOT EXISTS home_video_subtitle TEXT DEFAULT 'Master craftsmanship, hand-finished suiting & shirting tailored to your exact measurements.';

-- 3. Populate default settings if table has rows, or insert default row
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM public.store_settings LIMIT 1) THEN
    UPDATE public.store_settings
    SET 
      home_video_url = COALESCE(home_video_url, 'https://assets.mixkit.co/videos/preview/mixkit-tailor-working-on-a-suit-jacket-41394-large.mp4'),
      home_video_title = COALESCE(home_video_title, 'THE BESPOKE EXPERIENCE'),
      home_video_subtitle = COALESCE(home_video_subtitle, 'Master craftsmanship, hand-finished suiting & shirting tailored to your exact measurements.');
  ELSE
    INSERT INTO public.store_settings (delivery_fee, free_shipping_above, home_video_url, home_video_title, home_video_subtitle)
    VALUES (
      60.00,
      999.00,
      'https://assets.mixkit.co/videos/preview/mixkit-tailor-working-on-a-suit-jacket-41394-large.mp4',
      'THE BESPOKE EXPERIENCE',
      'Master craftsmanship, hand-finished suiting & shirting tailored to your exact measurements.'
    );
  END IF;
END $$;

-- 4. Seed or update high-fashion Snitch-style Hero Banners for desktop & mobile
INSERT INTO public.banners (title, subtitle, image_url, mobile_image_url, link_url, badge_text, display_order, is_active, section)
VALUES
  (
    'ROYAL BESPOKE SUITING',
    'EXCELLENCE IN BESPOKE TAILORING & FINE CLOTH MATERIALS',
    'images/hero1.jpg',
    'images/hero1.jpg',
    'cloth-material.html',
    'NEW SEASON 2026',
    1,
    TRUE,
    'hero'
  ),
  (
    'PURE LINEN & COTTON SHIRTING',
    'BREATHABLE LUXURY WEAVES CRAFTED FOR SUMMER ELEGANCE',
    'images/hero2.jpg',
    'images/hero2.jpg',
    'shirting.html',
    'EXCLUSIVE FABRIC',
    2,
    TRUE,
    'hero'
  ),
  (
    'FESTIVE ETHNIC READYMADE',
    'HAND-STITCHED KURTAS, BANDHGALAS & SHERWANIS',
    'images/hero3.jpg',
    'images/hero3.jpg',
    'ethnic.html',
    'ROYAL COLLECTION',
    3,
    TRUE,
    'hero'
  )
ON CONFLICT DO NOTHING;

-- 5. Seed background video showcase banner entry
INSERT INTO public.banners (title, subtitle, image_url, video_url, link_url, badge_text, display_order, is_active, section)
VALUES
  (
    'THE BESPOKE EXPERIENCE',
    'Master craftsmanship, hand-finished suiting & shirting tailored to your exact measurements.',
    'images/hero1.jpg',
    'https://assets.mixkit.co/videos/preview/mixkit-tailor-working-on-a-suit-jacket-41394-large.mp4',
    'suiting.html',
    'CRAFTED FOR ROYALTY',
    10,
    TRUE,
    'video'
  )
ON CONFLICT DO NOTHING;
