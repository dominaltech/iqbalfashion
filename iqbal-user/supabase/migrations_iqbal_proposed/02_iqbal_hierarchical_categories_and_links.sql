-- ==============================================================================
-- 02_iqbal_hierarchical_categories_and_links.sql
-- IQBAL FASHION — HIERARCHICAL CATEGORY SYSTEM, PRODUCT LINKS & DELETE SAFETY
-- Additive & Idempotent
-- ==============================================================================

-- 1. Extend categories table with hierarchy and image fields
DO $$
BEGIN
    -- parent_id: self-referencing foreign key for infinite / 2-level hierarchy
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_schema = 'public' AND table_name = 'categories' AND column_name = 'parent_id'
    ) THEN
        ALTER TABLE public.categories ADD COLUMN parent_id UUID REFERENCES public.categories(id) ON DELETE RESTRICT;
    END IF;

    -- thumb_image_url: dedicated small menu image thumbnail
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_schema = 'public' AND table_name = 'categories' AND column_name = 'thumb_image_url'
    ) THEN
        ALTER TABLE public.categories ADD COLUMN thumb_image_url TEXT;
    END IF;

    -- banner_image_url: dedicated category page banner
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

    -- show_on_home: boolean toggle for homepage "Shop by Category" section
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_schema = 'public' AND table_name = 'categories' AND column_name = 'show_on_home'
    ) THEN
        ALTER TABLE public.categories ADD COLUMN show_on_home BOOLEAN DEFAULT TRUE;
    END IF;

    -- updated_at
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_schema = 'public' AND table_name = 'categories' AND column_name = 'updated_at'
    ) THEN
        ALTER TABLE public.categories ADD COLUMN updated_at TIMESTAMPTZ DEFAULT NOW();
    END IF;
END $$;

-- Synchronize existing banner_url and image_url to new fields if not already populated
UPDATE public.categories 
SET thumb_image_url = COALESCE(thumb_image_url, image_url),
    banner_image_url = COALESCE(banner_image_url, banner_url),
    sort_order = COALESCE(sort_order, display_order)
WHERE thumb_image_url IS NULL OR banner_image_url IS NULL;

-- 2. Extend products table with subcategory_id
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_schema = 'public' AND table_name = 'products' AND column_name = 'subcategory_id'
    ) THEN
        ALTER TABLE public.products ADD COLUMN subcategory_id UUID REFERENCES public.categories(id) ON DELETE SET NULL;
    END IF;
END $$;

-- 3. Indexes for high-performance category lookups and filtering
CREATE INDEX IF NOT EXISTS idx_categories_parent_id ON public.categories(parent_id);
CREATE INDEX IF NOT EXISTS idx_categories_slug ON public.categories(slug);
CREATE INDEX IF NOT EXISTS idx_categories_sort_order ON public.categories(sort_order);
CREATE INDEX IF NOT EXISTS idx_categories_is_active ON public.categories(is_active);
CREATE INDEX IF NOT EXISTS idx_products_category_id ON public.products(category_id);
CREATE INDEX IF NOT EXISTS idx_products_subcategory_id ON public.products(subcategory_id);
CREATE INDEX IF NOT EXISTS idx_products_status ON public.products(status);

-- 4. Delete Safety RPC: Check before category deletion
CREATE OR REPLACE FUNCTION public.check_category_can_delete(p_cat_id UUID)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_product_count INT;
    v_child_count INT;
BEGIN
    SELECT COUNT(*) INTO v_product_count 
    FROM public.products 
    WHERE category_id = p_cat_id OR subcategory_id = p_cat_id;

    SELECT COUNT(*) INTO v_child_count 
    FROM public.categories 
    WHERE parent_id = p_cat_id;

    IF v_child_count > 0 THEN
        RETURN jsonb_build_object(
            'can_delete', FALSE,
            'reason', format('Cannot delete: This category contains %s active sub-categories. Please delete or reassign them first.', v_child_count),
            'child_count', v_child_count,
            'product_count', v_product_count
        );
    END IF;

    IF v_product_count > 0 THEN
        RETURN jsonb_build_object(
            'can_delete', FALSE,
            'reason', format('Cannot delete: This category is currently linked to %s products. Please reassign the products first.', v_product_count),
            'child_count', 0,
            'product_count', v_product_count
        );
    END IF;

    RETURN jsonb_build_object('can_delete', TRUE, 'child_count', 0, 'product_count', 0);
END;
$$;

GRANT EXECUTE ON FUNCTION public.check_category_can_delete(UUID) TO postgres, anon, authenticated, service_role;
