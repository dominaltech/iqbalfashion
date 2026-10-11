-- ==============================================================================
-- IQBAL FASHION — MIGRATION 08: READYMADE & CLOTH MATERIAL SIZE PRESETS
-- Safe, additive migration (Run this in Supabase SQL Editor after Migration 07)
-- ==============================================================================

-- 1. EXTEND TYPE CONSTRAINT ON size_presets TO SUPPORT READYMADE & CLOTH MATERIAL
ALTER TABLE public.size_presets DROP CONSTRAINT IF EXISTS size_presets_type_check;
ALTER TABLE public.size_presets ADD CONSTRAINT size_presets_type_check 
  CHECK (type IN ('readymade', 'cloth_material', 'standard', 'suit', 'custom', 'alpha', 'numeric'));

-- 2. ENSURE product_variants HAS is_in_stock AND stock_quantity
ALTER TABLE public.product_variants ADD COLUMN IF NOT EXISTS is_in_stock BOOLEAN DEFAULT TRUE;
ALTER TABLE public.product_variants ADD COLUMN IF NOT EXISTS stock_quantity INT DEFAULT 25;

-- 3. SEED READYMADE APPAREL PRESET SIZES (NUMERIC & ALPHA)
-- Pre-filled garment sizes: 32, 34, 35, 36, 38, 40, 42, 44, 46 and S, M, L, XL, XXL, 3XL
INSERT INTO public.size_presets (type, size_label, display_order, is_active)
VALUES
  ('numeric', '32', 1, true),
  ('numeric', '34', 2, true),
  ('numeric', '35', 3, true),
  ('numeric', '36', 4, true),
  ('numeric', '38', 5, true),
  ('numeric', '40', 6, true),
  ('numeric', '42', 7, true),
  ('numeric', '44', 8, true),
  ('numeric', '46', 9, true),
  ('alpha', 'XS', 10, true),
  ('alpha', 'S', 11, true),
  ('alpha', 'M', 12, true),
  ('alpha', 'L', 13, true),
  ('alpha', 'XL', 14, true),
  ('alpha', 'XXL', 15, true),
  ('alpha', '3XL', 16, true)
ON CONFLICT (type, size_label) DO UPDATE SET is_active = true, updated_at = NOW();

-- 4. SEED CLOTH MATERIAL PRESET SIZES (PER PIECE & METER CUTS)
INSERT INTO public.size_presets (type, size_label, display_order, is_active)
VALUES
  ('standard', 'Per Piece', 0, true),
  ('standard', '1.2M', 1, true),
  ('standard', '1.4M', 2, true),
  ('standard', '1.6M', 3, true),
  ('standard', '1.8M', 4, true),
  ('standard', '2.0M', 5, true),
  ('standard', '2.25M', 6, true),
  ('standard', '2.5M', 7, true),
  ('suit', '2.8M', 8, true),
  ('suit', '3.0M', 9, true),
  ('suit', '3.25M', 10, true),
  ('suit', '3.5M', 11, true),
  ('suit', '4.0M', 12, true),
  ('suit', '5.0M', 13, true)
ON CONFLICT (type, size_label) DO UPDATE SET is_active = true, updated_at = NOW();

-- 5. ENSURE RLS POLICIES FOR size_presets AND product_variants
DROP POLICY IF EXISTS "Public Full Size Presets" ON public.size_presets;
CREATE POLICY "Public Full Size Presets" ON public.size_presets FOR ALL TO public USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Public Full Product Variants" ON public.product_variants;
CREATE POLICY "Public Full Product Variants" ON public.product_variants FOR ALL TO public USING (true) WITH CHECK (true);
