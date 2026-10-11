-- ==============================================================================
-- IQBAL FASHION — MIGRATION 10: HOMEPAGE VIDEO SHOWCASE & FRAME MODE
-- Safe, additive migration (Run this in Supabase SQL Editor after Migration 09)
-- ==============================================================================

-- 1. Ensure store_settings columns for video showcase & framing
ALTER TABLE public.store_settings 
  ADD COLUMN IF NOT EXISTS home_video_url TEXT,
  ADD COLUMN IF NOT EXISTS home_video_title TEXT DEFAULT 'THE BESPOKE EXPERIENCE',
  ADD COLUMN IF NOT EXISTS home_video_subtitle TEXT DEFAULT 'Master craftsmanship, hand-finished suiting & shirting tailored to your exact measurements.',
  ADD COLUMN IF NOT EXISTS home_video_frame_mode TEXT DEFAULT 'auto';

-- 2. Ensure banners table supports video_url and section
ALTER TABLE public.banners
  ADD COLUMN IF NOT EXISTS video_url TEXT;

-- 3. Sync store_settings to active video URL
UPDATE public.store_settings
SET 
  home_video_url = 'https://yimbuvqtlbqdfggthaqt.supabase.co/storage/v1/object/public/banner-images/videos/1791709271196_hd1krx_1000239021_mp4.mp4',
  home_video_title = 'THE BESPOKE EXPERIENCE',
  home_video_subtitle = 'Master craftsmanship, hand-finished suiting & shirting tailored to your exact measurements.',
  home_video_frame_mode = 'auto',
  updated_at = NOW()
WHERE id IS NOT NULL;

-- 4. Sync banners table section = 'video' entry
UPDATE public.banners
SET 
  video_url = 'https://yimbuvqtlbqdfggthaqt.supabase.co/storage/v1/object/public/banner-images/videos/1791709271196_hd1krx_1000239021_mp4.mp4',
  title = 'THE BESPOKE EXPERIENCE',
  subtitle = 'Master craftsmanship, hand-finished suiting & shirting tailored to your exact measurements.',
  badge_text = 'ROYAL HERITAGE BESPOKE',
  section = 'video',
  is_active = true,
  updated_at = NOW()
WHERE section = 'video';
