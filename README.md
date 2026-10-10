# Iqbal Fashion E-Commerce Platform

A bespoke men's fashion and fine cloth materials e-commerce platform crafted with Snitch-style luxury minimalism, featuring a customer storefront (`iqbal-user`) and operations management portal (`iqbal-admin`).

---

## 1. Architecture & Repository Structure

```
├── iqbal-user/              # Customer Storefront Portal (Vanilla HTML/CSS/JS + Supabase Client)
│   ├── api/                 # Vercel Serverless Functions (Cashfree order creation & webhooks, VAPID push)
│   ├── loader/              # Thread & Button startup micro-animation & preloader
│   ├── styles.css           # Snitch-style luxury design system (4:5 cards, mobile dock, light borders)
│   ├── config.js            # Frontend credentials & config
│   ├── vercel.json          # 301 permanent redirect map from legacy fit names + security headers
│   └── *.html               # Storefront pages (readymade, cloth-material, kids, etc.)
│
├── iqbal-admin/             # Store Operations & Admin Portal
│   ├── categories.html      # Hierarchical category tree manager with thumbnail uploads
│   ├── add-product.html     # Cascading Category > Subcategory selector with multi-image upload
│   ├── orders.html          # Order processing, status transitions, WhatsApp CRM & packing slips
│   ├── add-banner.html      # Hero sliders & promotional event banners
│   ├── coupons.html         # Discount coupons & promo strips
│   ├── config.js            # Admin credentials & config
│   └── vercel.json          # Admin SPA routing & security headers
│
├── supabase/
│   └── migrations_iqbal_proposed/
│       ├── 01_iqbal_core_schema_and_permissions.sql
│       ├── 02_iqbal_hierarchical_categories_and_links.sql
│       ├── 03_iqbal_seed_initial_categories_and_banners.sql
│       ├── 04_iqbal_realtime_and_push_triggers.sql
│       └── 05_iqbal_update_legacy_page_urls.sql
│
└── docs/                    # Architectural Plans & Inventories
    ├── FILE_RENAME_PLAN.md  # Legacy file rename mapping, 301 redirect map & verification table
    ├── FEATURE_INVENTORY.md # Zero feature loss baseline audit
    ├── BANNER_INVENTORY.md  # Complete audit of all banners, sliders, and menu thumbnails
    ├── ENV_VARIABLES.md     # Production environment variables specification
    ├── MIGRATION_AUDIT.md   # SQL schema evolution and execution roadmap
    └── IMPLEMENTATION_PLAN.md # Master task checklist and progress log
```

---

## 2. Supabase Database Setup

Log into your Supabase Dashboard at `https://yimbuvqtlbqdfggthaqt.supabase.co`, navigate to the **SQL Editor**, and run the migrations in `supabase/migrations_iqbal_proposed/` in sequential order:

1. **`01_iqbal_core_schema_and_permissions.sql`**: Base tables (`categories`, `products`, `orders`, `banners`, `coupons`, `push_subscriptions`), RLS policies, storage buckets (`product-images`, `category-images`, `banners`).
2. **`02_iqbal_hierarchical_categories_and_links.sql`**: Extends `categories` with `parent_id`, `thumb_image_url`, `banner_image_url`, `sort_order`, `show_on_home`, and product link fields.
3. **`03_iqbal_seed_initial_categories_and_banners.sql`**: Seeds top-level departments (Readymade, Cloth Material, Kids), sub-departments (Ethnic, Casual Wear, Cotton, Linen, Silk, Khadi, Suiting, Shirting, Boys, Girls), initial hero banners, and `IQBAL10` coupon.
4. **`04_iqbal_realtime_and_push_triggers.sql`**: Adds tables to `supabase_realtime` publication and auto-confirms user signups.
5. **`05_iqbal_update_legacy_page_urls.sql`**: Additive and idempotent migration to update any stored banner links, category slugs, and notification URLs from old streetwear names to Iqbal Fashion sections (with rollback notes).

---

## 3. Renamed Pages & 301 Redirect Mapping

All Classic Collection streetwear product line pages have been renamed to match Iqbal Fashion's business sections:

| Old URL / Route | New URL / Route | Business Section |
|---|---|---|
| `/baggy.html` | `/readymade.html` | Readymade (Top Department) |
| `/hoodies.html` | `/ethnic.html` | Readymade > Ethnic Wear |
| `/oversize.html` | `/casual-wear.html` | Readymade > Casual Wear |
| `/pants.html` | `/cloth-material.html` | Cloth Material (Top Department) |
| `/plan-tshirt.html` | `/kids.html` | Kids (Top Department) |
| `/printing-tshirt.html` | `/boys.html` | Kids > Boys |
| `/women.html` | `/girls.html` | Kids > Girls |

Permanent 301 redirects are configured in `iqbal-user/vercel.json` ensuring no bookmark or search engine link breaks.

---

## 4. Key Highlights & Features

- **Snitch-Style Luxury Aesthetic:** 1px clean light borders (`#eeeeee`), modern typography (Inter / Outfit / Playfair Display), 4:5 product card image ratios with wishlist heart button, hover image crossfade, and mobile bottom navigation dock with `env(safe-area-inset-bottom)`.
- **Code-Only Thread & Button Startup Loader:** Zero-flash CSS & SVG animation featuring a 4-hole sewing button, needle stitching an X (`stroke-dashoffset`), 360° spin, logo reveal, split curtain reveal, and Supabase hero image preloading with session gating.
- **Hierarchical Categories & Zero Hardcoding:** Managed entirely via `iqbal-admin/categories.html` with thumbnail uploads for drawer menu buttons, parent-child relationships, and home slider banners.
- **Enterprise Security:** Service secret keys are kept strictly on serverless backends and never committed to git repositories.

---

## 5. Deployment

### Customer Storefront (`iqbal-user`)
- Deploy `iqbal-user` root to Vercel as a standalone project.
- Set environment variables as documented in `docs/ENV_VARIABLES.md` (`CASHFREE_APP_ID`, `CASHFREE_SECRET_KEY`, `CASHFREE_ENV`, `SUPABASE_SERVICE_ROLE_KEY`, `VAPID_PRIVATE_KEY`, etc.).

### Operations Admin (`iqbal-admin`)
- Deploy `iqbal-admin` root to Vercel as a private administrative portal.
