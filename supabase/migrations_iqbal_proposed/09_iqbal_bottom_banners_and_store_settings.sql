-- ==============================================================================
-- IQBAL FASHION — MIGRATION 09: HOMEPAGE DUAL BOTTOM PROMO BANNERS
-- Safe, additive migration (Run this in Supabase SQL Editor after Migration 08)
-- ==============================================================================

-- 1. ADD DUAL BOTTOM BANNER CONFIGURATION TO store_settings
ALTER TABLE public.store_settings 
  ADD COLUMN IF NOT EXISTS bottom_banner_1_image TEXT DEFAULT 'images/hero2.jpg',
  ADD COLUMN IF NOT EXISTS bottom_banner_1_title TEXT DEFAULT 'BESPOKE ROYAL WEDDING & ETHNIC WEAR',
  ADD COLUMN IF NOT EXISTS bottom_banner_1_subtitle TEXT DEFAULT 'Handcrafted sherwanis, kurtas & bespoke regal styling for the gentleman.',
  ADD COLUMN IF NOT EXISTS bottom_banner_1_badge TEXT DEFAULT 'WEDDING SPECIAL',
  ADD COLUMN IF NOT EXISTS bottom_banner_1_link TEXT DEFAULT 'ethnic.html',
  ADD COLUMN IF NOT EXISTS bottom_banner_2_image TEXT DEFAULT 'images/hero1.jpg',
  ADD COLUMN IF NOT EXISTS bottom_banner_2_title TEXT DEFAULT 'LUXURY ITALIAN & ENGLISH SUITING FABRICS',
  ADD COLUMN IF NOT EXISTS bottom_banner_2_subtitle TEXT DEFAULT 'Master tailor cut lengths in pure wool, linen, cashmeres & fine twill.',
  ADD COLUMN IF NOT EXISTS bottom_banner_2_badge TEXT DEFAULT 'FINE TEXTILES',
  ADD COLUMN IF NOT EXISTS bottom_banner_2_link TEXT DEFAULT 'suiting.html';

-- 2. SEED DEFAULT ENTRIES IN banners TABLE WITH section = 'bottom'
DELETE FROM public.banners WHERE section = 'bottom';

INSERT INTO public.banners (section, title, subtitle, image_url, link_url, badge_text, display_order, is_active)
VALUES 
  ('bottom', 'BESPOKE ROYAL WEDDING & ETHNIC WEAR', 'Handcrafted sherwanis, kurtas & bespoke regal styling for the gentleman.', 'images/hero2.jpg', 'ethnic.html', 'WEDDING SPECIAL', 1, true),
  ('bottom', 'LUXURY ITALIAN & ENGLISH SUITING FABRICS', 'Master tailor cut lengths in pure wool, linen, cashmeres & fine twill.', 'images/hero1.jpg', 'suiting.html', 'FINE TEXTILES', 2, true);
