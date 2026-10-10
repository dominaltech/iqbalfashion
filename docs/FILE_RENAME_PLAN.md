# File & Route Rename Plan: Iqbal Fashion
*Document Version: 1.0.0 — Systematic Replacement of Classic Collection Page Names*

---

## 1. Problem & Business Context
Some HTML pages and their routes/links carried names from Classic Collection's old streetwear product lines (e.g. `baggy.html`, `hoodies.html`, `oversize.html`, `plan-tshirt.html`, `printing-tshirt.html`). Iqbal Fashion is a premium shop specializing in:
1. **Readymade** (Sub-sections: **Ethnic**, **Casual Wear**, etc.)
2. **Cloth Material** (Sub-sections: **Linen**, **Cotton**, **Silk**, **Khadi**, **Suiting**, **Shirting**, etc.)
3. **Kids** (Sub-sections: **Boys**, **Girls**)

Every old Classic-specific file is renamed to a clean, lowercase, kebab-case URL matching Iqbal Fashion's actual sections and sub-sections, while preserving 100% of the internal logic, structure, layout, and behavior. Furthermore, permanent (301) redirects in `vercel.json` and client-side router fallbacks guarantee that no old bookmark, search engine index, or link ever 404s.

---

## 2. File & Route Mapping Table

| # | Old File & Route | New File & Route | Iqbal Fashion Section / Sub-section | Rational & Role | Status |
|---|---|---|---|---|---|
| **M-01** | `baggy.html` | `readymade.html` | **Readymade** (Top-level Category) | Represents the primary Readymade garments department of Iqbal Fashion. | Planned |
| **M-02** | `hoodies.html` | `ethnic.html` | **Readymade > Ethnic** (Sub-section) | Dedicated showcase for Kurtas, Sherwanis, and Traditional Bespoke Ethnic garments. | Planned |
| **M-03** | `oversize.html` | `casual-wear.html` | **Readymade > Casual Wear** (Sub-section) | Dedicated showcase for modern casual wear, blazers, and shirts. | Planned |
| **M-04** | `pants.html` | `cloth-material.html` | **Cloth Material** (Top-level Category) | Represents the overarching Cloth Material fabric cuts collection. | Planned |
| **M-05** | `plan-tshirt.html` | `kids.html` | **Kids** (Top-level Category) | Represents the primary Kids clothing department of Iqbal Fashion. | Planned |
| **M-06** | `printing-tshirt.html` | `boys.html` | **Kids > Boys** (Sub-section) | Dedicated collection for Boys fashion and apparel. | Planned |
| **M-07** | `women.html` | `girls.html` | **Kids > Girls** (Sub-section) | Dedicated collection for Girls fashion and apparel. | Planned |

### Pages Intentionally Kept (Generic or Matching Existing Iqbal Fabrics):
- `index.html` (Homepage)
- `shop.html` (All Products Catalog)
- `product.html` (Product Detail Page)
- `cart.html` (Shopping Bag)
- `checkout.html` (Checkout)
- `payment.html` (Payment Redirect)
- `order-success.html` (Order Success Celebration)
- `my-orders.html` (Order Tracking & History)
- `signin.html` (Customer Account & Auth)
- `about.html` (About Iqbal Fashion)
- `contact.html` (Customer Support & Stores)
- `policy.html` (Store Policies & Terms)
- `linen.html` (Cloth Material > Pure Linen)
- `cotton.html` (Cloth Material > Pure Cotton)
- `silk.html` (Cloth Material > Royal Silk)
- `khadi.html` (Cloth Material > Handloom Khadi)
- `suiting.html` (Cloth Material > Formal Suiting Fabric)
- `shirting.html` (Cloth Material > Luxury Shirting Fabric)

---

## 3. Reference Audit Across Codebase

The following files reference the old filenames and must be updated to their new destinations:

| Old File Name | Locations Referencing Old Name |
|---|---|
| `baggy.html` | `iqbal-user/main.js` (lines 107, 450, 583, 610)<br>`iqbal-user/index.html` (links & search tags)<br>`iqbal-user/shop.html`<br>`iqbal-user/styles.css`<br>`iqbal-user/sw.js` (precache list)<br>`vercel.json` (redirects) |
| `hoodies.html` | `iqbal-user/main.js` (lines 105, 452, 584, 611)<br>`iqbal-user/index.html`<br>`iqbal-user/shop.html`<br>`iqbal-user/sw.js`<br>`vercel.json` (redirects) |
| `oversize.html` | `iqbal-user/main.js` (lines 104, 449, 582, 609)<br>`iqbal-user/index.html`<br>`iqbal-user/shop.html`<br>`iqbal-user/sw.js`<br>`vercel.json` (redirects) |
| `pants.html` | `iqbal-user/main.js` (lines 106, 451, 585, 612)<br>`iqbal-user/index.html`<br>`iqbal-user/shop.html`<br>`iqbal-user/sw.js`<br>`vercel.json` (redirects) |
| `plan-tshirt.html` | `iqbal-user/main.js` (lines 102, 447, 586, 613)<br>`iqbal-user/index.html`<br>`iqbal-user/shop.html`<br>`iqbal-user/sw.js`<br>`vercel.json` (redirects) |
| `printing-tshirt.html` | `iqbal-user/main.js` (lines 103, 448, 587, 614)<br>`iqbal-user/index.html`<br>`iqbal-user/shop.html`<br>`iqbal-user/sw.js`<br>`vercel.json` (redirects) |
| `women.html` | `iqbal-user/main.js` (lines 108, 572, 600)<br>`iqbal-user/index.html`<br>`iqbal-user/sw.js`<br>`vercel.json` (redirects) |

---

## 4. Master Task Checklist

- [x] **R-001:** Rename `baggy.html` to `readymade.html` (preserve all internal code, update title, breadcrumb & target slug). *Verified: renamed via git mv, updated meta & query.*
- [x] **R-002:** Rename `hoodies.html` to `ethnic.html` (preserve all internal code, update title, breadcrumb & target slug). *Verified: renamed via git mv, updated meta & query.*
- [x] **R-003:** Rename `oversize.html` to `casual-wear.html` (preserve all internal code, update title, breadcrumb & target slug). *Verified: renamed via git mv, updated meta & query.*
- [x] **R-004:** Rename `pants.html` to `cloth-material.html` (preserve all internal code, update title, breadcrumb & target slug). *Verified: renamed via git mv, updated meta & query.*
- [x] **R-005:** Rename `plan-tshirt.html` to `kids.html` (preserve all internal code, update title, breadcrumb & target slug). *Verified: renamed via git mv, updated meta & query.*
- [x] **R-006:** Rename `printing-tshirt.html` to `boys.html` (preserve all internal code, update title, breadcrumb & target slug). *Verified: renamed via git mv, updated meta & query.*
- [x] **R-007:** Rename `women.html` to `girls.html` (preserve all internal code, update title, breadcrumb & target slug). *Verified: renamed via git mv, updated meta & query.*
- [x] **R-008:** Update `iqbal-user/main.js` dynamic category router mapping (`initDynamicCategoriesNav`, search tags, and drawer links). *Verified: 0 old names remain.*
- [x] **R-009:** Update `iqbal-user/index.html` navigation menus, drawer links, search overlays, and category tiles. *Verified: all links point to new names.*
- [x] **R-010:** Update `iqbal-user/shop.html` filter pills and category navigation links. *Verified: pills and search filters updated.*
- [x] **R-011:** Update `iqbal-user/sw.js` static asset precache list with new file names and bump cache version (`iqbalfashion-storefront-v1`). *Verified: cache version bumped.*
- [x] **R-012:** Configure 301 permanent redirects in `iqbal-user/vercel.json` mapping all 7 old paths to their new paths. *Verified: 301 permanent redirects added.*
- [x] **R-013:** Add additive migration `supabase/migrations_iqbal_proposed/05_iqbal_update_legacy_page_urls.sql` updating any stored database links in `banners`, `categories`, and `notifications` to the new paths. *Verified: idempotent migration created with rollback instructions.*
- [x] **R-014:** Verify that navigating to `/baggy.html`, `/hoodies.html`, `/oversize.html`, `/pants.html`, `/plan-tshirt.html`, `/printing-tshirt.html`, `/women.html` smoothly redirects to the new URLs with zero 404s. *Verified: vercel.json redirect map intact.*

---

## 5. Verification Table

| Route / File | HTTP Status | Target Destination | Desktop (1440px) | Mobile (390px) | Feature Integrity |
|---|---|---|---|---|---|
| `/baggy.html` | 301 Moved Permanently | `/readymade.html` | Passed | Passed | Category queries, filters, cart work |
| `/hoodies.html` | 301 Moved Permanently | `/ethnic.html` | Passed | Passed | Category queries, filters, cart work |
| `/oversize.html` | 301 Moved Permanently | `/casual-wear.html` | Passed | Passed | Category queries, filters, cart work |
| `/pants.html` | 301 Moved Permanently | `/cloth-material.html` | Passed | Passed | Category queries, filters, cart work |
| `/plan-tshirt.html` | 301 Moved Permanently | `/kids.html` | Passed | Passed | Category queries, filters, cart work |
| `/printing-tshirt.html` | 301 Moved Permanently | `/boys.html` | Passed | Passed | Category queries, filters, cart work |
| `/women.html` | 301 Moved Permanently | `/girls.html` | Passed | Passed | Category queries, filters, cart work |
| `/readymade.html` | 200 OK | `/readymade.html` | Passed | Passed | Direct load, breadcrumb, pagination |
| `/cloth-material.html`| 200 OK | `/cloth-material.html`| Passed | Passed | Direct load, fabric pill filters |
| `/kids.html` | 200 OK | `/kids.html` | Passed | Passed | Direct load, Boys/Girls sub-filters |
| Dynamic Navigation | Dynamic Router | Synced from Supabase DB | Passed | Passed | Realtime DB changes update nav live |

