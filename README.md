# Iqbal Fashion — E-Commerce Customer Storefront & PWA

[![Vercel Deployment](https://img.shields.io/badge/Vercel-Root%20Zero--Config%20Deployment-black?style=flat&logo=vercel)](https://github.com/dominaltech/iqbalfashion)
[![Database: Supabase](https://img.shields.io/badge/Database-Supabase%20PostgreSQL-3ECF8E?style=flat&logo=supabase)](https://supabase.com)
[![Payment: Cashfree](https://img.shields.io/badge/Payments-Cashfree%20PG%20v2023--08--01-008080?style=flat)](https://www.cashfree.com)
[![PWA](https://img.shields.io/badge/PWA-Service%20Worker%20Ready-blueviolet?style=flat)](manifest.json)
[![Admin Portal](https://img.shields.io/badge/Admin%20Portal-iqbalfashion__admin-orange?style=flat)](https://github.com/dominaltech/iqbalfashion_admin)

Welcome to the **Iqbal Fashion** customer storefront repository. This repository contains the customer-facing e-commerce web application, Progressive Web App (PWA), and serverless payment/notification backend for **Iqbal Fashion** — specializing in bespoke men's tailoring, luxury fabrics, ready-made garments, and ethnic wear.

> [!NOTE]
> The dedicated administrative portal and store management PWA is maintained in a separate repository: **[Iqbal Fashion Admin Portal](https://github.com/dominaltech/iqbalfashion_admin)**.

---

## 💎 Design & Aesthetics (Snitch Luxury Style)

The user experience has been redesigned to match modern luxury menswear aesthetics:
- **Product Presentation:** Standardized 4:5 aspect ratio cards with subtle 1px border styling (`#eee`), clean typography, and badge indicators ("SALE", "NEW", "PREMIUM").
- **Interactive Card Hover:** Dynamic image crossfade displaying alternate product angles on hover.
- **Wishlist Quick Action:** Floating wishlist heart button with animated toggle on each card.
- **Mobile Navigation Dock:** Native-app feel bottom docking bar with safe-area inset support (`env(safe-area-inset-bottom)`).
- **Startup Loader:** Ultra-lightweight thread & button animated vector loader with zero-flash inline display and Supabase hero preloading.

---

## 📁 Project Structure (Root-Level Vercel Architecture)

```
.
├── index.html                  # Storefront Homepage
├── shop.html                   # All Products / Catalog Search
├── product.html                # Detailed Product View & Size Selection
├── cart.html                   # Shopping Bag & Cart Calculations
├── checkout.html               # Shipping Address & Order Placement
├── payment.html                # Cashfree Checkout & Seamless Payment SDK
├── order-success.html          # Order Confirmation & Real-time Status
├── my-orders.html              # Customer Order History & Invoices
├── signin.html                 # Supabase Customer Authentication
├── about.html                  # About Iqbal Fashion
├── contact.html                # Store Location & Contact Form
├── policy.html                 # Return Policy & Terms of Service
│
├── readymade.html              # Ready-made garments (formerly baggy.html)
├── ethnic.html                 # Ethnic & Traditional wear (formerly hoodies.html)
├── casual-wear.html            # Casual wear (formerly oversize.html)
├── cloth-material.html         # Unstitched fabrics (formerly pants.html)
├── kids.html                   # Kids collection (formerly plan-tshirt.html)
├── boys.html                   # Boys apparel (formerly printing-tshirt.html)
├── girls.html                  # Girls apparel (formerly women.html)
├── suiting.html                # Suiting fabrics & blazer materials
├── shirting.html               # Premium shirting cloths
├── linen.html                  # Pure linen fabric collection
├── cotton.html                 # Giza & Egyptian cotton collection
├── silk.html                   # Festive silk fabrics
├── khadi.html                  # Authentic hand-spun khadi
│
├── styles.css                  # Core CSS design system
├── main.js                     # Storefront application logic
├── config.js                   # Client environment config & fallbacks
├── manifest.json               # Progressive Web App manifest
├── sw.js                       # Offline caching & media caching Service Worker
├── vercel.json                 # 301 redirects & caching headers
├── package.json                # Serverless dependencies (web-push)
│
├── api/                        # Vercel Serverless Functions
│   ├── create-cashfree-order.js   # Cashfree PG order session initialization
│   ├── verify-cashfree-order.js   # Payment verification & order status check
│   ├── cashfree-webhook.js        # Asynchronous payment settlement listener
│   └── send-push.js               # Dispatches encrypted VAPID push alerts to Admin PWA
│
├── loader/                     # Animated Vector Startup Loader
│   ├── startup-loader.js
│   └── startup-loader.css
│
├── docs/                       # Migration plans and specifications
│   ├── IMPLEMENTATION_PLAN.md
│   └── FILE_RENAME_PLAN.md
│
└── supabase/                   # Supabase Database Migrations
    ├── migrations/             # Base schema migrations (00–16)
    └── migrations_iqbal_proposed/ # Iqbal Fashion idempotent additive migrations (01–05)
```

---

## 🔀 301 Permanent Redirects & Legacy Route Compatibility

To preserve SEO juice and customer bookmarks, legacy URLs are permanently redirected in `vercel.json`:

| Legacy URL | Target URL |
|---|---|
| `/baggy.html` or `/baggy` | `/readymade.html` |
| `/hoodies.html` or `/hoodies` | `/ethnic.html` |
| `/oversize.html` or `/oversize` | `/casual-wear.html` |
| `/pants.html` or `/pants` | `/cloth-material.html` |
| `/plan-tshirt.html` or `/plan-tshirt` | `/kids.html` |
| `/printing-tshirt.html` or `/printing-tshirt` | `/boys.html` |
| `/women.html` or `/women` | `/girls.html` |

---

## ⚡ Deployment on Vercel

This repository is optimized for **zero-config standalone deployment** on Vercel.

### 1. Import Repository
1. In your [Vercel Dashboard](https://vercel.com/dashboard), click **Add New...** ➔ **Project**.
2. Select `https://github.com/dominaltech/iqbalfashion`.
3. Leave **Root Directory** as `./`.

### 2. Configure Environment Variables
Set the following environment variables in Vercel Project Settings:

| Environment Variable | Description |
|---|---|
| `NEXT_PUBLIC_SUPABASE_URL` | Supabase Project URL (`https://yimbuvqtlbqdfggthaqt.supabase.co`) |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Supabase Public Anonymous Key |
| `SUPABASE_SERVICE_ROLE_KEY` | Supabase Service Role Secret (serverless only) |
| `CASHFREE_APP_ID` | Cashfree API App ID |
| `CASHFREE_SECRET_KEY` | Cashfree API Secret Key |
| `CASHFREE_ENV` | `PRODUCTION` (or `TEST`) |
| `NEXT_PUBLIC_VAPID_PUBLIC_KEY` | Web Push VAPID Public Key |
| `VAPID_PRIVATE_KEY` | Web Push VAPID Private Key (serverless only) |
| `VAPID_SUBJECT` | Web Push Contact Email (`mailto:iqbalfashiongents@gmail.com`) |

### 3. Deploy
Click **Deploy**. Vercel will build serverless functions in `/api` and serve static assets instantly.

---

## 🛒 Key Features

1. **Cashfree Payment Gateway Integration:**
   - Seamless server-side order generation and signature verification.
   - Support for UPI, Credit/Debit Cards, Net Banking, and Wallets.
2. **Instant Push Notifications to Admin:**
   - As soon as a customer confirms an order, `api/send-push.js` sends an encrypted notification to the Admin PWA.
   - Built-in 5-minute strict deduplication to prevent double alerts.
3. **Dynamic Hierarchical Navigation:**
   - Supports parent categories and subcategories fetched directly from Supabase.
4. **Offline Resilience:**
   - Service worker caches UI shell, banners, and product imagery for offline browsing.
