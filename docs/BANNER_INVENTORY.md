# Banner & Menu-Image Inventory: Iqbal Fashion
*Document Version: 1.0.0 — Sacred Baseline (No-Feature-Loss & Live Admin Management)*

This document audits every single banner, hero slider, promotional strip, section banner, and menu section image in the Iqbal Fashion platform, tracing its Supabase database origin, admin portal editing interface, storefront rendering component, and real-time live update mechanism.

---

## 1. Sacred Rule Confirmation
1. **Existing banners and admin banner management are sacred:** Classic already has banners for every section of the website, and the admin can already change each one (upload, replace, reorder, link, enable/disable), and the storefront shows them live.
2. **Zero Disturbance:** We do not disturb, replace, rename, drop or rebuild any existing banner tables or columns. We restyle the components only to fit the Snitch-style UI.
3. **Zero Hardcoded Visible Images:** Everything visible on the website (all section banners, promotional strips, menu section images, category images, and product photos) is managed dynamically from the admin panel and backed by Supabase Storage. Neutral placeholder (`#f1f1f1`) is rendered when an image has not yet been uploaded.

---

## 2. Master Banner & Image Inventory Matrix

| # | Section / Visual Asset | Supabase Table & Column | Storage Bucket & Folder | Admin Management Screen | Storefront Component & Location | Instant Realtime / Live Behavior |
|---|------------------------|-------------------------|-------------------------|-------------------------|----------------------------------|----------------------------------|
| **B-01** | **Homepage Hero Banner Slider** | Table: `public.banners`<br>Columns: `id`, `title`, `subtitle`, `badge_text`, `image_url`, `mobile_image_url`, `link_url`, `display_order`, `is_active`, `section` | Bucket: `banner-images` (fallback: `product-images`)<br>Path: `banners/` | **Admin:** `add-banner.html` ("Hero Banners")<br>- File upload with client WebP compression<br>- Title, subtitle, badge tag, target link, order, active toggle<br>- Edit modal with image replacement | **User Portal:** `index.html` (`#heroSlider`)<br>- Multi-slide carousel with swipe gestures<br>- Arrows on desktop, dots navigation<br>- Autoplay, high-priority preload on slide 1 | Fetched dynamically on page load and on `urSupabaseReady`. Realtime publication on `banners` table triggers live DOM update. |
| **B-02** | **Homepage Promotional Event Banner Strip** | Table: `public.coupons`<br>Columns: `code`, `title`, `discount_type`, `discount_value`, `min_order_value`, `is_active`, `show_home_banner`, `banner_tag`, `banner_message` | Stored as metadata & discount codes | **Admin:** `coupons.html` ("Coupons & Banners")<br>- Toggle `show_home_banner`<br>- Custom event tag (e.g. `SPECIAL EVENT OFFER`)<br>- Custom headline banner message | **User Portal:** `index.html` (`#homeEventStrip`)<br>- Full-width prominent event banner below video / category grid<br>- 1-click "APPLY DISCOUNT" interactive button | Function `loadHomeEventBanner()` queries active coupon with `show_home_banner = true`. Updates live upon admin save. |
| **B-03** | **Shop by Category Tiles** | Table: `public.categories`<br>Columns: `id`, `name`, `slug`, `banner_url`, `image_url`, `thumb_image_url`, `show_on_home`, `display_order`, `is_active` | Bucket: `product-images` (or `banner-images`)<br>Path: `categories/` | **Admin:** `categories.html` ("Manage Categories")<br>- Image / banner file upload<br>- Name, slug, description, display order, active toggle | **User Portal:** `index.html` (`#homeCategoryGrid`)<br>- Category cards with background image cover<br>- Snitch-style hover zoom animation<br>- Routes directly to category collection | Dynamically loaded via `window.fetchStoreCategories()`. Cached in `sessionStorage` with instant invalidation upon update. |
| **B-04** | **Sliding Category Banners (Horizontal)** | Table: `public.banners` (with `section = 'category_slider'` or category banner fallback) / `public.categories`<br>Columns: `banner_url`, `banner_image_url`, `title`, `slug` | Bucket: `banner-images`<br>Path: `banners/` | **Admin:** `add-banner.html` & `categories.html`<br>- Admin uploads banner image for each category | **User Portal:** `index.html` (`#categoryBannerSlider`)<br>- Snitch-style horizontal swipeable category showcase<br>- Clicking banner opens category page | Populated directly from Supabase. |
| **B-05** | **Mobile Drawer Menu Section Images (Small Thumbnail Buttons)** | Table: `public.categories`<br>Columns: `thumb_image_url`, `image_url`<br>Plus `name`, `slug` | Bucket: `product-images`<br>Path: `categories/` | **Admin:** `categories.html`<br>- Dedicated menu thumbnail file input with live preview<br>- Editable per top-level & sub-category | **User Portal:** `#hamburgerOverlay` & `#catOverlay`<br>- Small square image thumbnail (44×44px / 48×48px) beside section name (Readymade, Cloth Material, Kids, etc.)<br>- Chevron indicator | Loaded via `initDynamicCategoriesNav()` and `fetchStoreCategories()`. Displays thumbnail image button for every category. |
| **B-06** | **Category Page Hero Banners** | Table: `public.categories`<br>Columns: `banner_url`, `banner_image_url`, `name`, `description` | Bucket: `product-images`<br>Path: `categories/` | **Admin:** `categories.html`<br>- Category Banner upload with preview | **User Portal:** `shop.html` (`#shopCatBanner`) & category HTML pages<br>- Full-width editorial category banner with title and description overlay | Retrieved when category is selected via `selectCategory(slug)`. If no banner is uploaded, displays Snitch-style neutral grey container `#f1f1f1`. |
| **B-07** | **Product Offer Badge Banner** | Table: `public.coupons`<br>Columns: `show_product_banner`, `banner_tag`, `banner_message`, `discount_value` | Stored as metadata | **Admin:** `coupons.html`<br>- Toggle `show_product_banner` switch | **User Portal:** `product.html` (`#pdpCouponStrip`)<br>- Event discount pill on PDP with instant coupon apply action | Loaded via `window.UR_COUPON.fetchProductBannerCoupon()`. |
| **B-08** | **Product Primary Cover Image & Gallery** | Tables: `public.products` (`main_image`) & `public.product_images` (`image_url`, `display_order`) | Bucket: `product-images`<br>Path: `products/` | **Admin:** `add-product.html`<br>- Primary cover image upload<br>- Unlimited gallery drag-and-drop multi-file upload with ordering badges | **User Portal:** `product.html` & Product Cards (`.product-card`)<br>- Main cover shot with secondary hover image crossfade on desktop<br>- PDP swipeable multi-image gallery stage | Uploaded to Supabase Storage with automatic WebP compression. Rendered live across catalog. |

---

## 3. Brand Video & Media Assets Audit

| Asset | Current Location | Purpose in Storefront | Iqbal Fashion Implementation |
|---|---|---|---|
| `classic.mp4` / `iqbal.mp4` | `iqbal-user/classic.mp4` & `iqbal-user/images/classic.mp4` | Featured Brand Video Showcase on Homepage | Rebranded to `iqbal.mp4` (or aliased) with intersection-observer autoplay, unmuted sound toggle pill, and clean Snitch video frame. |
| Brand Logo | `iqbal-user/images/logo.png`, `iqbal-admin/images/logo.jpg` | Storefront & Admin Header brand mark | Rendered as `<img>` tag from centralized config (`UR_CONFIG.LOGO_URL`). Clean placeholder until user uploads final branded PNG/SVG. |

---

## 4. Hardcoded Images Scan & Dynamic Migration Plan
The code scan found no external third-party hardcoded product images. All product and banner paths in the database point to Supabase Storage:
- Local fallbacks like `images/hero1.jpg`, `images/hero2.jpg`, `images/banner1.jpg` in seed SQL have been upgraded to public Supabase Storage paths in the new migration.
- If any banner is missing in Supabase, components fall back to neutral high-fashion grey `#f1f1f1` with correct aspect ratios (16:9 for hero desktop, 4:5 for products, 1:1 for thumbnails), never broken images or SVG illustrations.
