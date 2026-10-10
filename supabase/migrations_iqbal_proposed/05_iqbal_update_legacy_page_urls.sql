-- ==============================================================================
-- 05_iqbal_update_legacy_page_urls.sql
-- IQBAL FASHION — ADDITIVE MIGRATION TO UPDATE STORED PAGE URLS & LINK REFERENCES
-- Idempotent & Safe with Rollback Instructions
-- ==============================================================================
--
-- ROLLBACK INSTRUCTIONS:
-- If you ever need to revert these URLs back to the Classic Collection streetwear names:
--   UPDATE public.banners SET link_url = REPLACE(link_url, 'readymade.html', 'baggy.html') WHERE link_url LIKE '%readymade.html%';
--   UPDATE public.banners SET link_url = REPLACE(link_url, 'ethnic.html', 'hoodies.html') WHERE link_url LIKE '%ethnic.html%';
--   UPDATE public.banners SET link_url = REPLACE(link_url, 'casual-wear.html', 'oversize.html') WHERE link_url LIKE '%casual-wear.html%';
--   UPDATE public.banners SET link_url = REPLACE(link_url, 'cloth-material.html', 'pants.html') WHERE link_url LIKE '%cloth-material.html%';
--   UPDATE public.banners SET link_url = REPLACE(link_url, 'kids.html', 'plan-tshirt.html') WHERE link_url LIKE '%kids.html%';
--   UPDATE public.banners SET link_url = REPLACE(link_url, 'boys.html', 'printing-tshirt.html') WHERE link_url LIKE '%boys.html%';
--   UPDATE public.banners SET link_url = REPLACE(link_url, 'girls.html', 'women.html') WHERE link_url LIKE '%girls.html%';
-- ==============================================================================

DO $$
BEGIN
  -- 1. Update Banners Link URLs
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'banners') THEN
    UPDATE public.banners
    SET link_url = REPLACE(link_url, 'baggy.html', 'readymade.html')
    WHERE link_url LIKE '%baggy.html%';

    UPDATE public.banners
    SET link_url = REPLACE(link_url, 'hoodies.html', 'ethnic.html')
    WHERE link_url LIKE '%hoodies.html%';

    UPDATE public.banners
    SET link_url = REPLACE(link_url, 'oversize.html', 'casual-wear.html')
    WHERE link_url LIKE '%oversize.html%';

    UPDATE public.banners
    SET link_url = REPLACE(link_url, 'pants.html', 'cloth-material.html')
    WHERE link_url LIKE '%pants.html%';

    UPDATE public.banners
    SET link_url = REPLACE(link_url, 'plan-tshirt.html', 'kids.html')
    WHERE link_url LIKE '%plan-tshirt.html%';

    UPDATE public.banners
    SET link_url = REPLACE(link_url, 'printing-tshirt.html', 'boys.html')
    WHERE link_url LIKE '%printing-tshirt.html%';

    UPDATE public.banners
    SET link_url = REPLACE(link_url, 'women.html', 'girls.html')
    WHERE link_url LIKE '%women.html%';
  END IF;

  -- 2. Update Categories (if banner_url, image_url or description contains legacy routes)
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'categories') THEN
    UPDATE public.categories
    SET slug = 'readymade', name = 'Readymade'
    WHERE slug = 'baggy' AND NOT EXISTS (SELECT 1 FROM public.categories WHERE slug = 'readymade');

    UPDATE public.categories
    SET slug = 'ethnic', name = 'Ethnic'
    WHERE slug = 'hoodies' AND NOT EXISTS (SELECT 1 FROM public.categories WHERE slug = 'ethnic');

    UPDATE public.categories
    SET slug = 'casual-wear', name = 'Casual Wear'
    WHERE slug IN ('oversize', 'oversized') AND NOT EXISTS (SELECT 1 FROM public.categories WHERE slug = 'casual-wear');

    UPDATE public.categories
    SET slug = 'cloth-material', name = 'Cloth Material'
    WHERE slug IN ('pants', 'linen-pants') AND NOT EXISTS (SELECT 1 FROM public.categories WHERE slug = 'cloth-material');

    UPDATE public.categories
    SET slug = 'kids', name = 'Kids'
    WHERE slug IN ('plan-tshirt', 'plain-t-shirts') AND NOT EXISTS (SELECT 1 FROM public.categories WHERE slug = 'kids');

    UPDATE public.categories
    SET slug = 'boys', name = 'Boys'
    WHERE slug IN ('printing-tshirt', 'printed-t-shirts') AND NOT EXISTS (SELECT 1 FROM public.categories WHERE slug = 'boys');

    UPDATE public.categories
    SET slug = 'girls', name = 'Girls'
    WHERE slug = 'women' AND NOT EXISTS (SELECT 1 FROM public.categories WHERE slug = 'girls');
  END IF;

  -- 3. Update Notifications Deep Link URLs (if table exists)
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'notifications') THEN
    UPDATE public.notifications SET url = REPLACE(url, 'baggy.html', 'readymade.html') WHERE url LIKE '%baggy.html%';
    UPDATE public.notifications SET url = REPLACE(url, 'hoodies.html', 'ethnic.html') WHERE url LIKE '%hoodies.html%';
    UPDATE public.notifications SET url = REPLACE(url, 'oversize.html', 'casual-wear.html') WHERE url LIKE '%oversize.html%';
    UPDATE public.notifications SET url = REPLACE(url, 'pants.html', 'cloth-material.html') WHERE url LIKE '%pants.html%';
    UPDATE public.notifications SET url = REPLACE(url, 'plan-tshirt.html', 'kids.html') WHERE url LIKE '%plan-tshirt.html%';
    UPDATE public.notifications SET url = REPLACE(url, 'printing-tshirt.html', 'boys.html') WHERE url LIKE '%printing-tshirt.html%';
    UPDATE public.notifications SET url = REPLACE(url, 'women.html', 'girls.html') WHERE url LIKE '%women.html%';
  END IF;

  RAISE NOTICE 'Legacy page URLs updated to Iqbal Fashion sections successfully.';
END $$;
