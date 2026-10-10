-- ==============================================================================
-- 03_iqbal_seed_initial_categories_and_banners.sql
-- IQBAL FASHION — SEED INITIAL CATEGORIES, HERO BANNERS, COUPONS & SETTINGS
-- Additive & Idempotent
-- ==============================================================================

-- 1. SEED TOP-LEVEL CATEGORIES
INSERT INTO public.categories (id, parent_id, name, slug, description, image_url, banner_url, thumb_image_url, banner_image_url, display_order, sort_order, show_on_home, is_active)
VALUES
  (
    'd1000000-0000-0000-0000-000000000001',
    NULL,
    'Readymade',
    'readymade',
    'Premium handcrafted readymade menswear, bespoke suits, ethnic ensembles and modern casuals.',
    'images/hero1.jpg',
    'images/banner1.jpg',
    'images/hero1.jpg',
    'images/banner1.jpg',
    1,
    1,
    TRUE,
    TRUE
  ),
  (
    'd1000000-0000-0000-0000-000000000002',
    NULL,
    'Cloth Material',
    'cloth-material',
    'Exquisite unstitched fabrics: pure linen, combed cotton, handloom khadi, royal silk & bespoke suiting.',
    'images/hero2.jpg',
    'images/banner2.jpg',
    'images/hero2.jpg',
    'images/banner2.jpg',
    2,
    2,
    TRUE,
    TRUE
  ),
  (
    'd1000000-0000-0000-0000-000000000003',
    NULL,
    'Kids',
    'kids',
    'Festive and casual bespoke tailoring collections for boys and girls.',
    'images/hero3.jpg',
    'images/banner3.jpg',
    'images/hero3.jpg',
    'images/banner3.jpg',
    3,
    3,
    TRUE,
    TRUE
  )
ON CONFLICT (slug) DO UPDATE SET
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  parent_id = EXCLUDED.parent_id,
  show_on_home = EXCLUDED.show_on_home;

-- 2. SEED SUB-CATEGORIES

-- 2.1 Readymade Sub-categories
INSERT INTO public.categories (parent_id, name, slug, description, image_url, banner_url, thumb_image_url, banner_image_url, display_order, sort_order, show_on_home, is_active)
VALUES
  (
    'd1000000-0000-0000-0000-000000000001',
    'Ethnic',
    'ethnic',
    'Traditional festive kurtas, sherwanis, bandhgalas and bespoke ethnic wear.',
    'images/hero1.jpg',
    'images/banner1.jpg',
    'images/hero1.jpg',
    'images/banner1.jpg',
    11,
    11,
    TRUE,
    TRUE
  ),
  (
    'd1000000-0000-0000-0000-000000000001',
    'Casual Wear',
    'casual-wear',
    'Contemporary tailored casual shirts, lightweight blazers, and luxury essentials.',
    'images/hero3.jpg',
    'images/banner3.jpg',
    'images/hero3.jpg',
    'images/banner3.jpg',
    12,
    12,
    TRUE,
    TRUE
  )
ON CONFLICT (slug) DO UPDATE SET
  parent_id = EXCLUDED.parent_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description;

-- 2.2 Cloth Material Sub-categories
INSERT INTO public.categories (parent_id, name, slug, description, image_url, banner_url, thumb_image_url, banner_image_url, display_order, sort_order, show_on_home, is_active)
VALUES
  (
    'd1000000-0000-0000-0000-000000000002',
    'Linen',
    'linen',
    'Pure 60 LEA & 80 LEA European & Irish breathable linen fabrics for bespoke shirts and jackets.',
    'images/prod1.jpg',
    'images/banner2.jpg',
    'images/prod1.jpg',
    'images/banner2.jpg',
    21,
    21,
    TRUE,
    TRUE
  ),
  (
    'd1000000-0000-0000-0000-000000000002',
    'Cotton',
    'cotton',
    '100% Giza and long-staple combed cotton fabrics with silky luster and comfort.',
    'images/hero3.jpg',
    'images/banner3.jpg',
    'images/hero3.jpg',
    'images/banner3.jpg',
    22,
    22,
    TRUE,
    TRUE
  ),
  (
    'd1000000-0000-0000-0000-000000000002',
    'Silk',
    'silk',
    'Royal handloom mulberry and raw silk materials for celebratory traditional attire.',
    'images/prod3.jpg',
    'images/banner1.jpg',
    'images/prod3.jpg',
    'images/banner1.jpg',
    23,
    23,
    TRUE,
    TRUE
  ),
  (
    'd1000000-0000-0000-0000-000000000002',
    'Khadi',
    'khadi',
    'Authentic handspun organic handloom khadi fabric with natural texture and drape.',
    'images/prod2.jpg',
    'images/banner2.jpg',
    'images/prod2.jpg',
    'images/banner2.jpg',
    24,
    24,
    TRUE,
    TRUE
  )
ON CONFLICT (slug) DO UPDATE SET
  parent_id = EXCLUDED.parent_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description;

-- 2.3 Kids Sub-categories
INSERT INTO public.categories (parent_id, name, slug, description, image_url, banner_url, thumb_image_url, banner_image_url, display_order, sort_order, show_on_home, is_active)
VALUES
  (
    'd1000000-0000-0000-0000-000000000003',
    'Boys',
    'boys',
    'Boys kurta-pajama sets, festive sherwanis, formal shirts, and tailored suits.',
    'images/prod4.jpg',
    'images/banner3.jpg',
    'images/prod4.jpg',
    'images/banner3.jpg',
    31,
    31,
    TRUE,
    TRUE
  ),
  (
    'd1000000-0000-0000-0000-000000000003',
    'Girls',
    'girls',
    'Girls traditional ethnic lehengas, festive wear, and tailored occasion wear.',
    'images/prod2.jpg',
    'images/banner1.jpg',
    'images/prod2.jpg',
    'images/banner1.jpg',
    32,
    32,
    TRUE,
    TRUE
  )
ON CONFLICT (slug) DO UPDATE SET
  parent_id = EXCLUDED.parent_id,
  name = EXCLUDED.name,
  description = EXCLUDED.description;

-- 3. SEED HERO BANNERS FOR IQBAL FASHION
INSERT INTO public.banners (title, subtitle, image_url, link_url, badge_text, display_order, is_active)
VALUES
  (
    'STATEMENT BESPOKE COLLECTION',
    'FINE SUITING, SHIRTING & CLOTH MATERIALS CRAFTED FOR ELEGANCE',
    'images/hero1.jpg',
    'cloth-material.html',
    'NEW ARRIVALS 2026',
    1,
    TRUE
  ),
  (
    'EXCLUSIVE HANDLOOM SILK & KHADI',
    'TRADITIONAL TEXTILES CRAFTED WITH LUXURY FINISH',
    'images/hero2.jpg',
    'silk.html',
    'ROYAL WEAVE',
    2,
    TRUE
  ),
  (
    'BESPOKE READYMADE ETHNIC WEAR',
    'HANDCRAFTED KURTAS, BANDHGALAS & MODERN CASUALS',
    'images/hero3.jpg',
    'readymade.html',
    'LIMITED EDITION',
    3,
    TRUE
  )
ON CONFLICT DO NOTHING;

-- 4. SEED PROMOTIONAL EVENT COUPON
INSERT INTO public.coupons (
  code, title, discount_type, discount_value, min_order_value, is_active, show_home_banner, show_product_banner, banner_tag, banner_message
)
VALUES (
  'IQBAL10',
  'Grand Inaugural Offer',
  'percentage',
  10.00,
  499.00,
  TRUE,
  TRUE,
  TRUE,
  '✨ INAUGURAL CELEBRATION OFFER',
  'FLAT 10% OFF ON ALL ORDERS — USE CODE IQBAL10'
)
ON CONFLICT (code) DO UPDATE SET
  title = EXCLUDED.title,
  discount_type = EXCLUDED.discount_type,
  discount_value = EXCLUDED.discount_value,
  show_home_banner = EXCLUDED.show_home_banner,
  banner_tag = EXCLUDED.banner_tag,
  banner_message = EXCLUDED.banner_message;

-- 5. SEED STORE SETTINGS
INSERT INTO public.store_settings (delivery_fee, free_shipping_above)
VALUES (60.00, 999.00)
ON CONFLICT DO NOTHING;

-- 6. SEED FABRIC CUT SIZES (METERS)
INSERT INTO public.size_presets (type, size_label, display_order, is_active)
VALUES
  ('standard', '1.2M', 1, TRUE),
  ('standard', '1.4M', 2, TRUE),
  ('standard', '1.6M', 3, TRUE),
  ('standard', '1.8M', 4, TRUE),
  ('standard', '2.0M', 5, TRUE),
  ('standard', '2.25M', 6, TRUE),
  ('standard', '2.5M', 7, TRUE),
  ('suit', '2.8M', 8, TRUE),
  ('suit', '3.0M', 9, TRUE),
  ('suit', '3.25M', 10, TRUE),
  ('suit', '3.5M', 11, TRUE),
  ('suit', '4.0M', 12, TRUE),
  ('suit', '5.0M', 13, TRUE)
ON CONFLICT (type, size_label) DO NOTHING;
