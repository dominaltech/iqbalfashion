# Supabase Migration Audit & Category Schema Architecture: Iqbal Fashion
*Document Version: 1.0.0 — Exhaustive Audit & Proposed Execution Guide*

---

## 1. Executive Summary & Verdict

### Audit Verdict: **Run Clean Corrected Schema + New Additive Migrations**
The existing migrations in `iqbal-user/supabase/migrations/` (files `00_` through `16_`) represent historical evolutionary patches from Classic Collection. Some files are monolithic resets (`00_classic_collection_complete_setup.sql`, `05_complete_all_in_one_setup.sql`), while others alter columns or seed old Classic Collection test data and hardcoded storage URLs pointing to `mizbiarhnxzrpfuodqnj.supabase.co`.

Running the historical migrations as-is on a fresh empty Supabase project (`yimbuvqtlbqdfggthaqt.supabase.co`) would result in:
1. **Redundant creation & drops:** Tables and policies are repeatedly created and dropped across migrations 00, 01, 02, 04, 05, 10, 12, 13, 16.
2. **Old brand hardcoding:** Classic Collection sample product data, old image links, and old email addresses.
3. **Execution order conflicts:** Several files assume tables exist without `CREATE TABLE IF NOT EXISTS`, and some constraint names conflict across files.

### Recommendation:
1. **Preserve Historical Files:** We do **NOT** modify or delete existing migration files in `supabase/migrations/`.
2. **Provide Clean Consolidated Deployment Pack in `supabase/migrations_iqbal_proposed/`:**
   - `01_iqbal_core_schema_and_permissions.sql`: Extensions, all base tables (`profiles`, `categories`, `products`, `product_variants`, `product_images`, `banners`, `coupons`, `orders`, `order_items`, `payments`, `admin_push_subscriptions`, `store_settings`, `size_presets`), schema grants, permissive RLS policies, and storage buckets (`product-images`, `banner-images`).
   - `02_iqbal_hierarchical_categories_and_links.sql`: Additive hierarchical fields on `categories` (`parent_id`, `thumb_image_url`, `banner_image_url`, `sort_order`, `show_on_home`, `updated_at`), foreign keys, product link fields (`category_id`, `subcategory_id`), indexes, and safe delete prevention function.
   - `03_iqbal_seed_initial_categories_and_banners.sql`: Seeds top-level **Readymade, Cloth Material, Kids**; sub-categories **Kids > Boys, Girls**; **Cloth Material > Linen, Cotton, Silk, Khadi**; **Readymade > Ethnic, Casual Wear**; initial hero banners, default event coupons, and store delivery settings.
   - `04_iqbal_realtime_and_push_triggers.sql`: Realtime publication configuration (`supabase_realtime`) and auto-confirm trigger for signups.

---

## 2. Inventory of Historical Migrations

| Migration File | Stated Purpose | Order Validity on Fresh DB | Status / Verdict |
|---|---|---|---|
| `00_classic_collection_complete_setup.sql` | Monolithic schema, RLS, storage buckets, and seed data | Valid standalone, but contains hardcoded Classic seeds | Superseded by consolidated Iqbal schema |
| `00_fix_permissions_only.sql` | Grants schema usage and table privileges to anon/authenticated | Valid | Incorporated into base schema |
| `00_wipe_and_reset.sql` | Drops all public tables and storage buckets | Destructive | Do not run on production |
| `01_init_schema.sql` | Early schema draft (profiles, categories, products, orders) | Partial | Superseded by 00 / 05 |
| `02_rls_and_triggers.sql` | Row Level Security policies and auth triggers | Partial | Superseded by permissive policies in 00 / 10 |
| `03_seed_data.sql` | Sample t-shirts, hoodies, baggy pants from Classic | Valid | Superseded by Iqbal fashion categories |
| `04_fix_rls_policies.sql` | Patch for permissions on products/orders | Redundant with 00 | Superseded |
| `05_complete_all_in_one_setup.sql` | Another monolithic setup script | Valid | Superseded |
| `06_admin_push_subscriptions.sql` | Creates `admin_push_subscriptions` table for Web Push | Valid | Incorporated into base schema |
| `07_storage_and_gallery_setup.sql` | Creates `product-images` bucket and `product_images` table | Valid | Incorporated into base schema |
| `08_store_settings.sql` | Creates `store_settings` table (delivery fee & free threshold) | Valid | Incorporated into base schema |
| `09_update_categories_hoodies_and_linen.sql` | Seeds hoodies and linen categories | Redundant | Superseded by Iqbal categories |
| `10_dynamic_categories_and_size_management.sql` | Adds `size_presets`, `is_in_stock` column, and category banner | Valid | Incorporated into base schema |
| `11_orders_crud_and_delete_policies.sql` | RLS delete policies for orders, items, payments | Valid | Incorporated into base schema |
| `12_dynamic_event_banners_and_coupons.sql` | Dynamic event banner columns on `coupons` (`show_home_banner`, `banner_tag`, `banner_message`) | Valid | Incorporated into base schema |
| `13_fix_hero_banners_and_storage.sql` | Fixes integer overflow on `banners.display_order` (changes to `BIGINT`) and bucket limit (25MB) | Valid | Incorporated into base schema |
| `14_auto_confirm_users_no_email_verification.sql` | Trigger on `auth.users` to auto-confirm new registrations without email OTP | Valid | Incorporated into `04_iqbal_realtime_and_push_triggers.sql` |
| `15_seed_cloth_material_products.sql` | Seeds 6 fabric categories & sample products with old project image URLs | Contains stale Classic Supabase URLs | Replaced with clean seed |
| `16_fix_store_settings_and_size_presets.sql` | Seeds fabric cut lengths (1.2M - 5.0M) and store settings | Valid | Incorporated into base schema |

---

## 3. Code vs Schema Verification (JavaScript API Usages)

Every table, column, RPC, and bucket accessed by the JavaScript codebase has been verified against the proposed schema:

| Table in Code | Columns Accessed in JS | Verified in Schema |
|---|---|---|
| `public.categories` | `id`, `parent_id`, `name`, `slug`, `description`, `image_url`, `banner_url`, `thumb_image_url`, `banner_image_url`, `display_order`, `sort_order`, `show_on_home`, `is_active`, `created_at`, `updated_at` |  Yes (Fully backward-compatible aliases) |
| `public.products` | `id`, `category_id`, `subcategory_id`, `name`, `slug`, `description`, `details`, `price`, `mrp`, `main_image`, `is_featured`, `is_new_arrival`, `status`, `created_at`, `updated_at` |  Yes |
| `public.product_variants` | `id`, `product_id`, `size`, `color`, `sku`, `stock_quantity`, `is_in_stock`, `price_override`, `created_at` |  Yes |
| `public.product_images` | `id`, `product_id`, `image_url`, `display_order`, `created_at` |  Yes |
| `public.banners` | `id`, `category_id`, `section`, `title`, `subtitle`, `image_url`, `mobile_image_url`, `link_url`, `badge_text`, `display_order`, `is_active`, `created_at` |  Yes |
| `public.coupons` | `id`, `code`, `title`, `discount_type`, `discount_value`, `min_order_value`, `max_discount`, `is_active`, `show_home_banner`, `show_product_banner`, `banner_tag`, `banner_message`, `created_at`, `updated_at` |  Yes |
| `public.orders` | `id`, `order_number`, `user_id`, `customer_name`, `customer_email`, `customer_phone`, `shipping_address`, `subtotal`, `discount_amount`, `shipping_fee`, `total_amount`, `payment_status`, `order_status`, `cashfree_order_id`, `tracking_number`, `courier_name`, `created_at`, `updated_at` |  Yes |
| `public.order_items` | `id`, `order_id`, `product_id`, `product_name`, `variant_size`, `variant_color`, `unit_price`, `quantity`, `total_price`, `image_url`, `created_at` |  Yes |
| `public.payments` | `id`, `order_id`, `cashfree_order_id`, `cashfree_payment_id`, `payment_mode`, `payment_status`, `payment_amount`, `raw_payload`, `created_at` |  Yes |
| `public.admin_push_subscriptions` | `id`, `user_agent`, `endpoint`, `keys`, `created_at`, `updated_at` |  Yes |
| `public.store_settings` | `id`, `delivery_fee`, `free_shipping_above`, `created_at`, `updated_at` |  Yes |
| `public.size_presets` | `id`, `type`, `size_label`, `display_order`, `is_active`, `created_at`, `updated_at` |  Yes |
| `public.profiles` | `id`, `full_name`, `phone`, `address`, `pincode`, `role`, `default_address`, `created_at`, `updated_at` |  Yes |

### Storage Buckets Accessed:
- `product-images`: Public read, 25MB file size limit, allowed MIME types for images.
- `banner-images`: Public read, 25MB file size limit, allowed MIME types for images.

---

## 4. Realtime Publications
The following tables are added to `supabase_realtime`:
- `categories` (instant storefront menu, category tiles & pill updates upon admin change)
- `banners` (instant hero slider update upon admin save)
- `coupons` (instant event banner & discount update)
- `products` (instant catalog update)
- `orders` (instant admin badge and order feed update)

---

## 5. Table Renaming Assessment
**Do any table names contain "classic"?**
No. All table names are generic: `categories`, `products`, `banners`, `coupons`, `orders`, `order_items`, `payments`, `admin_push_subscriptions`, `store_settings`, `size_presets`, `profiles`.
**Verdict:** Keep existing table names as-is. This guarantees 100% stability with zero breaking changes to client queries and serverless API handlers.

---

## 6. Full Combined Run Order for Supabase SQL Editor

When running on the fresh Supabase project (`https://yimbuvqtlbqdfggthaqt.supabase.co`), run these proposed files in order:

1. **`supabase/migrations_iqbal_proposed/01_iqbal_core_schema_and_permissions.sql`**
   - Enables `uuid-ossp` and `pgcrypto`.
   - Grants full permissions to `anon`, `authenticated`, and `service_role`.
   - Creates all 13 core tables with proper types and primary keys.
   - Configures storage buckets (`product-images`, `banner-images`) and permissive RLS policies.
2. **`supabase/migrations_iqbal_proposed/02_iqbal_hierarchical_categories_and_links.sql`**
   - Adds `parent_id`, `thumb_image_url`, `banner_image_url`, `sort_order`, `show_on_home` to `categories`.
   - Adds `subcategory_id` and indexes to `products`.
   - Adds delete safety RPC / trigger preventing accidental deletion of categories containing active products.
3. **`supabase/migrations_iqbal_proposed/03_iqbal_seed_initial_categories_and_banners.sql`**
   - Seeds top-level: Readymade, Cloth Material, Kids.
   - Seeds sub-categories: Readymade > Ethnic, Casual Wear; Cloth Material > Linen, Cotton, Silk, Khadi; Kids > Boys, Girls.
   - Seeds initial banners and store settings (₹60 delivery, free above ₹999).
4. **`supabase/migrations_iqbal_proposed/04_iqbal_realtime_and_push_triggers.sql`**
   - Adds tables to `supabase_realtime` publication.
   - Installs auto-confirm user trigger for friction-free customer signup.
