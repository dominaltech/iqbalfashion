-- ==============================================================================
-- 11_iqbal_snitch_category_grid_and_menu_hierarchy.sql
-- IQBAL FASHION — 3-COLUMN CATEGORY GRID & HIERARCHICAL MENU DRAWER SYSTEM
-- Additive & Idempotent
-- ==============================================================================

-- 1. Ensure Categories Hierarchy and Display Columns
DO $$
BEGIN
    -- parent_id: Self-referencing UUID for multi-level hierarchical categories
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_schema = 'public' AND table_name = 'categories' AND column_name = 'parent_id'
    ) THEN
        ALTER TABLE public.categories ADD COLUMN parent_id UUID REFERENCES public.categories(id) ON DELETE RESTRICT;
    END IF;

    -- show_on_home: Toggle to include in homepage "Shop by Category" 3-column grid
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_schema = 'public' AND table_name = 'categories' AND column_name = 'show_on_home'
    ) THEN
        ALTER TABLE public.categories ADD COLUMN show_on_home BOOLEAN DEFAULT TRUE;
    END IF;

    -- thumb_image_url: dedicated thumbnail
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_schema = 'public' AND table_name = 'categories' AND column_name = 'thumb_image_url'
    ) THEN
        ALTER TABLE public.categories ADD COLUMN thumb_image_url TEXT;
    END IF;

    -- banner_image_url: category banner image
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_schema = 'public' AND table_name = 'categories' AND column_name = 'banner_image_url'
    ) THEN
        ALTER TABLE public.categories ADD COLUMN banner_image_url TEXT;
    END IF;

    -- sort_order: ordering integer
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_schema = 'public' AND table_name = 'categories' AND column_name = 'sort_order'
    ) THEN
        ALTER TABLE public.categories ADD COLUMN sort_order INT DEFAULT 0;
    END IF;
END $$;

-- 2. Ensure Banners Table Supports 'menu' Section for Drawer Carousel
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_schema = 'public' AND table_name = 'banners' AND column_name = 'section'
    ) THEN
        ALTER TABLE public.banners ADD COLUMN section VARCHAR(50) DEFAULT 'hero';
    END IF;
END $$;

-- 3. Indexes for fast category hierarchy and menu banner lookups
CREATE INDEX IF NOT EXISTS idx_categories_parent_id ON public.categories(parent_id);
CREATE INDEX IF NOT EXISTS idx_categories_show_home ON public.categories(show_on_home) WHERE is_active = TRUE;
CREATE INDEX IF NOT EXISTS idx_banners_section ON public.banners(section) WHERE is_active = TRUE;

-- 4. Seed initial Menu Campaign Banners (section = 'menu') if none exist
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM public.banners WHERE section = 'menu') THEN
        INSERT INTO public.banners (section, title, badge_text, link_url, image_url, display_order, is_active)
        VALUES 
        ('menu', 'NEW IN', 'NEW IN', 'shop.html?tag=new', 'https://yimbuvqtlbqdfggthaqt.supabase.co/storage/v1/object/public/banner-images/banners/1791712627815_5c80os_1000239058_webp.webp', 1, TRUE),
        ('menu', 'ROYAL BESPOKE', 'BESPOKE', 'suiting.html', 'https://yimbuvqtlbqdfggthaqt.supabase.co/storage/v1/object/public/banner-images/banners/1791712651276_rj9o6y_1000239059_webp.webp', 2, TRUE),
        ('menu', 'ETHNIC WEAR', 'ROYAL', 'ethnic.html', 'https://yimbuvqtlbqdfggthaqt.supabase.co/storage/v1/object/public/banner-images/banners/1791712643487_c96t8r_1000239036_webp.webp', 3, TRUE),
        ('menu', 'FINE FABRICS', 'TEXTILES', 'cloth-material.html', 'https://yimbuvqtlbqdfggthaqt.supabase.co/storage/v1/object/public/banner-images/bottom-banners/1791712858792_zdwhe7_1000239065_webp.webp', 4, TRUE);
    END IF;
END $$;

-- 5. RLS Policies Verification & Safe Permissions
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.banners ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public Full Categories" ON public.categories;
CREATE POLICY "Public Full Categories" ON public.categories FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Public Full Banners" ON public.banners;
CREATE POLICY "Public Full Banners" ON public.banners FOR ALL USING (true) WITH CHECK (true);
