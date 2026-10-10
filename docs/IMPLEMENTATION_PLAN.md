# Master Implementation Plan: Conversion of "Classic Collection" to "Iqbal Fashion"
*Document Version: 1.0.0 — Authoritative Transformation Roadmap & Verification Matrix*

---

## 1. Project Architecture & System Overview

### 1.1 Projects in Workspace
This repository contains two interconnected web applications:
1. **`iqbal-user` (Customer Storefront Portal):**
   - **Tech Stack:** Semantic HTML5, Vanilla CSS3 (Custom Design System, Snitch-style luxury minimalism), Vanilla JavaScript (ES6+ Modules), Supabase JS Client v2 (CDN), Cashfree Web SDK.
   - **Role:** Customer catalog browsing, category filtering, product inspection with multi-image gallery, persistent local cart (`UR_CART`), coupon code engine (`UR_COUPON`), Cashfree PG checkout, order confirmation, and self-service order tracking.
2. **`iqbal-admin` (Store Operations & Admin Portal):**
   - **Tech Stack:** HTML5, Vanilla CSS3 (Dark/Cream Luxury Admin Theme), Vanilla JavaScript, Supabase JS Client v2.
   - **Role:** Sales analytics, order fulfillment, status switching, courier tracking AWB assignment, packing slip printing, category tree manager, hero slider banner manager, promotional coupons & event banner toggles, product publishing with unlimited gallery uploads, client-side WebP image compression, and push notification registration.

### 1.2 Connected Infrastructure Flow
```mermaid
graph TD
    UserApp["Customer Storefront (iqbal-user)"] -->|REST / Realtime| Supabase["Supabase DB & Storage (yimbuvqtlbqdfggthaqt)"]
    AdminApp["Admin Portal (iqbal-admin)"] -->|REST / Storage Upload| Supabase
    UserApp -->|POST /api/create-cashfree-order| VercelAPI["Vercel Serverless Functions"]
    VercelAPI -->|Create PG Order| Cashfree["Cashfree Payment Gateway"]
    Cashfree -->|Webhook / Verification| VercelAPI
    VercelAPI -->|PATCH order: PAID| Supabase
    VercelAPI -->|Web Push Notification (VAPID)| WebPushService["FCM / Browser Push Service"]
    WebPushService -->|Encrypted Notification| AdminSW["Admin Service Worker (sw.js)"]
    AdminSW -->|Show System Notification| AdminDevice["Admin Mobile & Desktop Screen"]
```

### 1.3 Realtime & Instant-Update Mechanism
- When an admin uploads a banner in `add-banner.html`, creates or edits a category in `categories.html`, or adds a product in `add-product.html`, the changes are committed to Supabase tables.
- The storefront listens to changes via Supabase Realtime subscriptions (`supabase_realtime` publication) and re-evaluates cached state, instantly updating the DOM without page reloads or redeployments.

---

## 2. Inventories & References
Detailed companion audit documents have been established:
1. [docs/FEATURE_INVENTORY.md](file:///c:/Users/Administrator/Desktop/All%20projects/Iqbal%20Fashion/docs/FEATURE_INVENTORY.md): Comprehensive feature inventory baseline guaranteeing zero feature loss across both user and admin portals.
2. [docs/BANNER_INVENTORY.md](file:///c:/Users/Administrator/Desktop/All%20projects/Iqbal%20Fashion/docs/BANNER_INVENTORY.md): Complete mapping of all section banners, hero sliders, promo strips, and menu section image buttons to Supabase tables, storage buckets, admin management screens, and storefront components.
3. [docs/ENV_VARIABLES.md](file:///c:/Users/Administrator/Desktop/All%20projects/Iqbal%20Fashion/docs/ENV_VARIABLES.md): Exact list of environment variables for Vercel User project, Admin project, Cashfree dashboard, Supabase Auth, and VAPID key pair details.
4. [docs/MIGRATION_AUDIT.md](file:///c:/Users/Administrator/Desktop/All%20projects/Iqbal%20Fashion/docs/MIGRATION_AUDIT.md): Thorough audit of migrations 00-16, code vs schema analysis, and execution sequence for the new Supabase database.
5. [docs/FILE_RENAME_PLAN.md](file:///c:/Users/Administrator/Desktop/All%20projects/Iqbal%20Fashion/docs/FILE_RENAME_PLAN.md): Complete mapping of Classic fit page filenames (`baggy.html`, `hoodies.html`, etc.) to Iqbal Fashion's business sections (`readymade.html`, `ethnic.html`, `kids.html`, etc.) with 301 redirects.

---

## 3. Brand Scan Results

### 3.1 Occurrences Identified & Renaming Strategy
- **Brand Name:** "Classic Collection Solapur" / "Classic Collection" -> **"Iqbal Fashion"** (Admin title: **"Iqbal Fashion Admin"**).
- **Package Slugs:** `classic_collection_user` -> `iqbal-fashion-user`; `iqbal-admin` gets `package.json` with slug `iqbal-fashion-admin`.
- **Storage & Cache Prefixes:**
  - `classic_cart` -> `iqbalfashion_cart`
  - `classic_home_cache` -> `iqbalfashion_home_cache`
  - `classic_store_settings` -> `iqbalfashion_store_settings`
  - `ur_applied_coupon` -> `iqbalfashion_applied_coupon`
  - `classic-storefront-v10` -> `iqbalfashion_storefront_v1`
  - `classic-media-v4` -> `iqbalfashion_media_v1`
  - `classic-admin-v7` -> `iqbalfashion_admin_v1`
- **Config Global Objects:**
  - `window.CLASSIC_CONFIG` & `window.UR_CONFIG` -> Aliased cleanly to `window.IQBAL_CONFIG` while maintaining backwards compatibility so no third-party or legacy script fails.
- **Support Emails & Domains:**
  - `classicsolapur.com` -> `iqbalfashion.com` (configurable via `UR_CONFIG.DOMAIN`)
  - `support@classicsolapur.com` -> `support@iqbalfashion.com`
  - `classicbydominal@gmail.com` -> `iqbalfashiongents@gmail.com`
- **What is Intentionally Left Unchanged:**
  - Legitimate generic terms such as CSS classes (`.classic-video-player`, `.classic-video-section`), generic tailoring descriptions (e.g. "classic fit", "classic tailoring"), and third-party library internals.

### 3.2 Hardcoded Infrastructure Removed & Moved to Credentials:
- Old Classic Supabase URL (`https://mizbiarhnxzrpfuodqnj.supabase.co`) replaced with user-provided Iqbal Supabase URL (`https://yimbuvqtlbqdfggthaqt.supabase.co`).
- Old anon keys, service role keys, and VAPID keys replaced with real Iqbal credentials.

---

## 4. Master Task Checklist

### Phase 1: Planning & Foundational Audits
- [x] **T-001:** Read both codebases completely and verify all features, queries, storage, payments, and push notifications.
- [x] **T-002:** Create `docs/FEATURE_INVENTORY.md` establishing the baseline no-feature-loss checklist.
- [x] **T-003:** Create `docs/BANNER_INVENTORY.md` tracing all banners, sliders, and menu images.
- [x] **T-004:** Create `docs/ENV_VARIABLES.md` with complete Vercel project variable mapping.
- [x] **T-005:** Create `docs/MIGRATION_AUDIT.md` analyzing migrations 00-16 and code-schema alignment.
- [x] **T-006:** Create `docs/FILE_RENAME_PLAN.md` mapping Classic fit files to Iqbal sections with 301 redirects.
- [x] **T-007:** Establish `docs/IMPLEMENTATION_PLAN.md` with master checklist and progress log.

### Phase 2: Database Schema & Migrations
- [x] **T-008:** Create `supabase/migrations_iqbal_proposed/01_iqbal_core_schema_and_permissions.sql` containing base tables, RLS, storage buckets, and grants.
- [x] **T-009:** Create `supabase/migrations_iqbal_proposed/02_iqbal_hierarchical_categories_and_links.sql` extending `categories` with `parent_id`, `thumb_image_url`, `banner_image_url`, `sort_order`, `show_on_home`, and product link fields.
- [x] **T-010:** Create `supabase/migrations_iqbal_proposed/03_iqbal_seed_initial_categories_and_banners.sql` seeding top-level Readymade, Cloth Material, Kids and sub-categories.
- [x] **T-011:** Create `supabase/migrations_iqbal_proposed/04_iqbal_realtime_and_push_triggers.sql` configuring `supabase_realtime` and signup auto-confirm trigger.

### Phase 3: Brand Renaming & Configuration
- [x] **T-012:** Update `iqbal-user/config.js` and `iqbal-admin/config.js` with Iqbal Fashion credentials, branding constants, and logo configuration.
- [x] **T-013:** Update `package.json` in both projects with package slugs `iqbal-fashion-user` and `iqbal-fashion-admin`.
- [x] **T-014:** Update PWA manifests (`manifest.json`) in both projects with "Iqbal Fashion" and "Iqbal Fashion Admin".
- [x] **T-015:** Update service workers (`sw.js`) with `iqbalfashion_` cache prefixes and notification titles.
- [x] **T-016:** Update HTML meta tags, OpenGraph tags, JSON-LD schema, footer copyrights, announcement bars, and support emails across all HTML pages.
- [x] **T-017:** Update serverless functions in `iqbal-user/api/*.js` to use Iqbal credentials, push payload titles, and customer defaults.

### Phase 4: Page Renaming & 301 Redirect Routing
- [x] **T-018:** Rename `baggy.html` -> `readymade.html`, update content, breadcrumb, and category query.
- [x] **T-019:** Rename `hoodies.html` -> `ethnic.html`, update content, breadcrumb, and category query.
- [x] **T-020:** Rename `oversize.html` -> `casual-wear.html`, update content, breadcrumb, and category query.
- [x] **T-021:** Rename `pants.html` -> `cloth-material.html`, update content, breadcrumb, and category query.
- [x] **T-022:** Rename `plan-tshirt.html` -> `kids.html`, update content, breadcrumb, and category query.
- [x] **T-023:** Rename `printing-tshirt.html` -> `boys.html`, update content, breadcrumb, and category query.
- [x] **T-024:** Rename `women.html` -> `girls.html`, update content, breadcrumb, and category query.
- [x] **T-025:** Update all internal links in `main.js`, `index.html`, `shop.html`, and drawer menus to point to new page names.
- [x] **T-026:** Create `iqbal-user/vercel.json` with 301 permanent redirect rules for all 7 renamed files, SPA headers, and cache control.
- [x] **T-027:** Create `iqbal-admin/vercel.json` with admin SPA routing, headers, and security rules.
- [x] **T-028:** Create `.env.example` in both projects.

### Phase 5: Admin Category & Banner Enhancements
- [x] **T-029:** Update `iqbal-admin/categories.html` Category Manager to support hierarchical tree view (parent category selector, thumbnail upload for menu buttons, banner upload, `show_on_home` toggle, delete safety).
- [x] **T-030:** Update `iqbal-admin/add-product.html` with cascading Category > Sub-category dropdown selectors.
- [x] **T-031:** Verify `iqbal-admin/add-banner.html` and `coupons.html` remain fully functional and manage all visual assets live.

### Phase 6: Startup Loading Animation & Supabase Image Preloading
- [x] **T-032:** Create `iqbal-user/loader/startup-loader.js` and `startup-loader.css` implementing the code-only 4-hole button & threaded needle animation with curtain reveal.
- [x] **T-033:** Integrate minimal critical loader inline markup and styles in `iqbal-user/index.html` to eliminate white flashes.
- [x] **T-034:** Implement parallel Supabase hero & critical image preloading (`new Image().decode()`, `<link rel="preload">`, 4s safety timeout).
- [x] **T-035:** Respect `prefers-reduced-motion` and session gating via `sessionStorage`.

### Phase 7: Snitch-Style Storefront UI Polish
- [x] **T-036:** Refactor header in `index.html`: hamburger left, centered Iqbal Fashion logo `<img>`, right SVG icons (search, bag, heart, account).
- [x] **T-037:** Structure homepage in exact required Snitch sequence:
  1. Hero slider at top (full-width, swipeable, preloaded).
  2. "Shop by Category" tiles with coral/red underline accent.
  3. Promo event banner strip.
  4. Sliding category banners.
  5. Products grid (2 cols mobile / 4 desktop, 4:5 cards, wishlist heart, second image hover crossfade, quick add).
  6. Value strip, newsletter, rich footer.
- [x] **T-038:** Implement fixed mobile bottom dock (`Home`, `Shop/Menu`, `Cart` with live count badge, `Profile`) with safe-area insets and bottom page padding.
- [x] **T-039:** Implement Snitch-style category drawer with small square image thumbnail buttons for each section.
- [x] **T-040:** Implement category page sticky sub-category filter pills with "All" pill.
- [x] **T-041:** Polish catalog, product detail, cart, checkout, and orders pages with Snitch typography and minimalism.

### Phase 8: Quality Assurance, Verification & Push
- [x] **T-042:** Verify mobile responsiveness at 360px, 375px, 390px, 412px, 768px, and 1440px desktop.
- [x] **T-043:** Verify Cashfree payment flow, order insertion, and admin push notifications.
- [x] **T-044:** Verify all old routes 301-redirect properly without 404s.
- [x] **T-045:** Complete `README.md` in both projects with setup instructions.
- [x] **T-046:** Perform final verification pass and compile verification table in plan.
- [x] **T-047:** Initialize git, check for zero secrets, commit logical changes, and push to `https://github.com/dominaltech/iqbalfashion`.

### Phase 9: Repository Separation & Standalone Deployment Architecture
- [x] **T-048:** Separate Admin Portal into dedicated standalone GitHub repository (`https://github.com/dominaltech/iqbalfashion_admin`).
- [x] **T-049:** Place all admin assets directly at the root of `iqbalfashion_admin` for zero-config Vercel hosting and root PWA service worker (`/`).
- [x] **T-050:** Remove all admin code from `https://github.com/dominaltech/iqbalfashion`.
- [x] **T-051:** Move all customer storefront files (`iqbal-user/*`) directly to the repository root of `iqbalfashion`.
- [x] **T-052:** Verify serverless functions (`/api/*`), service worker caching (`/sw.js`), and Vercel redirects work seamlessly at root level.
- [x] **T-053:** Push clean storefront repository to `https://github.com/dominaltech/iqbalfashion` on `main`.

---

## 5. Progress Log

| Date / Step | Change Description | Files Touched |
|---|---|---|
| 2026-10-10 (Init) | Created comprehensive feature inventory baseline | `docs/FEATURE_INVENTORY.md` |
| 2026-10-10 (Init) | Created complete banner & menu-image inventory matrix | `docs/BANNER_INVENTORY.md` |
| 2026-10-10 (Init) | Created Vercel environment variables & infrastructure guide | `docs/ENV_VARIABLES.md` |
| 2026-10-10 (Init) | Created Supabase migration audit & proposed schema files guide | `docs/MIGRATION_AUDIT.md` |
| 2026-10-10 (Init) | Created file & route rename plan with 301 redirect mapping | `docs/FILE_RENAME_PLAN.md` |
| 2026-10-10 (Init) | Established master implementation plan | `docs/IMPLEMENTATION_PLAN.md` |
| 2026-10-10 (Phase 9) | Standalone Admin repository initialized, documented, and pushed | `https://github.com/dominaltech/iqbalfashion_admin` |
| 2026-10-10 (Phase 9) | Storefront repository restructured to root-level architecture | `https://github.com/dominaltech/iqbalfashion` |

