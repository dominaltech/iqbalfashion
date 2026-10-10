# Feature Inventory Baseline: Classic Collection to Iqbal Fashion
*Document Version: 1.0.0 — No-Feature-Loss Baseline*

This inventory lists every single user-facing storefront feature, admin portal capability, API serverless function, database model, payment step, notification flow, and background service worker worker job present in the original Classic Collection codebase. **Every single item listed here is preserved and operational in Iqbal Fashion.**

---

## 1. Storefront (Customer User Portal)

### 1.1 Header & Global Navigation
- [x] **Store Logo & Branding:** Clickable brand logo routing to home page.
- [x] **Desktop Navigation Bar:** Dynamic category links and direct links to catalog (`shop.html`) and collection pages.
- [x] **Mobile Hamburger Drawer:**
  - Drawer slide-in animation from left with backdrop blur/darkening overlay.
  - Close button and outside tap dismiss.
  - Direct routes: Home, All Products Catalog, Dynamic Categories, My Orders, Shopping Bag, About Us, Policies, Contact Us, Account/Sign In.
  - Admin-managed menu image thumbnails for each section.
- [x] **Interactive Search Modal Overlay:**
  - Fullscreen/modal search interface with instant keyboard autofocus.
  - Search input with enter-key redirection to `shop.html?search=query`.
  - Curated quick-tag suggestion pills for instant 1-tap search.
- [x] **Shopping Bag Icon & Live Counter:**
  - Dynamic count badge displaying total items in cart (`localStorage`).
  - Slide-out quick cart drawer on desktop/mobile and link to `cart.html`.
- [x] **User Account Icon:**
  - Direct link to `signin.html` / profile management.
- [x] **Announcement Bar:**
  - Top rotating ticker featuring delivery guarantees, return policy, and store highlights.
  - Quick utility links: Track Order (`my-orders.html`) and Contact Us (`contact.html`).
- [x] **Sticky Auto-Hiding Behavior:**
  - Smooth elevation, hides on downward scroll, reveals on upward scroll.

### 1.2 Homepage Experience
- [x] **Hero Banner Image Slider:**
  - Multi-slide hero showcase dynamically fetched from Supabase `banners` table.
  - High-priority preloading on first slide (`fetchpriority="high"`).
  - Autoplay (1500ms rotation), touch swipe detection (left/right gesture on mobile), previous/next arrow buttons on desktop, pagination dot indicators.
  - Overlay typography: Title, subtitle, badge tag, and clickable link URL destination.
- [x] **Dynamic Promotional Event Banner Strip:**
  - Manageable from Admin Panel via `coupons` table (`show_home_banner = true`).
  - Displays event badge (e.g. Special Offer), headline message, coupon code, and 1-tap "APPLY DISCOUNT" button.
- [x] **Shop by Category Section:**
  - Grid of category tiles populated from `categories` table.
  - Category thumbnail/banner background with hover zoom animation.
  - Direct routing to specific category catalog page or filter.
- [x] **Featured / New Arrivals Product Grid:**
  - 2-column grid on mobile, 4-column grid on desktop.
  - Shimmer skeleton placeholder cards while loading from Supabase.
  - Product Card details: 4:5 editorial imagery, "NEW" badge tag, category label, product name, selling price, MRP with strikethrough, calculated discount percentage.
- [x] **Brand Video Showcase Section:**
  - Embedded high-definition video player (`classic.mp4` / `iqbal.mp4`).
  - IntersectionObserver autoplay: plays automatically when scrolled into view (>=50% visible), pauses when scrolled out.
  - Mute/Unmute sound toggle pill with animated audio wave SVG icon.
- [x] **Brand Trust Badges / Value Strip:**
  - 4 benefit cards: Fast Express Delivery, 2-Day Easy Returns, 100% Authentic Fabric/Apparel, Secure Online UPI & Card Payments.
- [x] **Newsletter Subscription Bar:**
  - Email capture input with submit handler and toast notification feedback.
- [x] **Rich Multi-Column Footer:**
  - Brand description, company links, legal policies (Shipping, Return & Exchange, Privacy), customer support email, and copyright.

### 1.3 Mobile Experience & Fixed Bottom Bar
- [x] **Fixed Mobile Navigation Bar (Bottom Dock):**
  - Always fixed at bottom of screen on viewport <= 1024px.
  - 4 primary destinations: Home, Shop (opens catalog/menu), Cart (with live badge), Profile / Account.
  - Proper touch target heights (>=44px), SVG icons, safe-area inset padding (`env(safe-area-inset-bottom)`).
  - Main content padding-bottom offset ensuring no elements are obscured.

### 1.4 Catalog & Category Listing Pages (`shop.html`, category pages)
- [x] **Live Product Search & Filtering:**
  - Realtime client-side text filtering against product name, description, and category.
- [x] **Sticky Category Filter Pills:**
  - Horizontally scrollable category pills with "ALL" pill and category chips.
  - Active category visual highlight with instantaneous product list refilter.
  - Deep-link support via URL query parameters (`?category=slug` and `?search=query`).
- [x] **Category Header Banner:**
  - Dynamic category banner and description retrieved from Supabase `categories` table when a category is selected.
- [x] **Sorting & Layout Controls:**
  - Sort by Newest, Price: Low to High, Price: High to Low.
- [x] **Product Grid & Empty State:**
  - Responsive cards with lazy loading and clean fallback for missing assets.
  - Clean empty search state with clear search button.

### 1.5 Product Detail Page (`product.html`)
- [x] **Image Gallery Showcase:**
  - Multi-image gallery with main stage zoom on hover and click.
  - Mobile swipe gesture navigation between gallery slides.
  - Thumbnail row selector with active highlight and slide counter badge.
- [x] **Product Metadata & Pricing:**
  - Brand title, product name, discount badge, current selling price, original MRP, discount percentage.
- [x] **Size / Cut Length Selector:**
  - Dynamic size pills fetched from `product_variants` (e.g. 1.2M, 1.4M, 1.6M, 2.0M, Standard Cut, etc.).
  - Visual out-of-stock indicator (`is_in_stock = false` or `stock_quantity = 0`) disabling selection or showing out-of-stock warning.
  - Dynamic custom cut length support.
- [x] **Quantity Selector:**
  - Increment/decrement counter with minimum constraint of 1.
- [x] **Shopping Actions:**
  - "ADD TO CART" button with cart drawer / toast feedback and badge counter bounce.
  - "BUY NOW" instant checkout redirection.
  - Sticky mobile Add to Bag bottom bar when scrolling past main actions.
- [x] **Product Details & Accordions:**
  - Product description, fabric specifications, wash care guidelines, shipping and return policy dropdowns.
- [x] **Promotional Event Coupon Strip:**
  - Displays active coupons with 1-click apply action directly on PDP.

### 1.6 Shopping Cart (`cart.html` & Cart Drawer)
- [x] **Local Cart State Engine (`UR_CART`):**
  - Persistent shopping bag in `localStorage`.
  - Item attributes: product ID, name, image, size/cut length, price, quantity.
- [x] **Quantity & Item Controls:**
  - Increase (+), decrease (-), remove item from bag.
- [x] **Dynamic Pricing Calculation:**
  - Order subtotal calculation.
  - Shipping fee calculation respecting dynamic store settings:
    - Default delivery fee (e.g. ₹60).
    - Free shipping threshold (e.g. Free delivery on orders above ₹999).
    - ₹1 test swatch free shipping logic.
- [x] **Dynamic Coupon Code Engine (`UR_COUPON`):**
  - Coupon input box with apply button.
  - Validates active coupon codes against Supabase `coupons` table.
  - Supports percentage discounts (`% OFF`) with optional max cap, and flat cash discounts (`₹ OFF`).
  - Realtime discount calculation and removal toggle.
- [x] **Order Summary Card:**
  - Subtotal, Discount amount, Delivery fee, Total payable amount.
- [x] **Navigation:**
  - Proceed to Checkout button routing to `checkout.html`.

### 1.7 Checkout Flow (`checkout.html`)
- [x] **Customer Information Form:**
  - Full Name, Phone Number (10 digits validation), Email address.
- [x] **Delivery Address:**
  - House/Street address, Landmark, City, State, PIN code.
  - Remember address for future visits via `localStorage`.
- [x] **Order Review:**
  - Line items summary with sizes, quantities, and pricing breakdown.
- [x] **Payment Mode:**
  - Online Payment via Cashfree Payment Gateway (UPI, Cards, Netbanking).
  - Cash on Delivery (COD) fallback if enabled.
- [x] **Order Creation in Supabase:**
  - Inserts new row into `orders` table with unique order number (e.g. `IQB-timestamp`).
  - Inserts item records into `order_items` table.
  - Tracks order status as `PLACED` and payment status as `PENDING`.
- [x] **Cashfree Integration:**
  - Invokes serverless API route `/api/create-cashfree-order`.
  - Mounts Cashfree JS SDK checkout modal / redirect seamlessly.

### 1.8 Payment Verification & Post-Checkout (`payment.html`, `order-success.html`)
- [x] **Payment Verification API:**
  - `/api/verify-cashfree-order` verifies status directly with Cashfree PG server.
  - Updates Supabase order `payment_status` to `PAID` (or `FAILED` upon cancellation).
  - Updates `order_status` to `PLACED` (or `CANCELLED`).
- [x] **Instant Admin Push Dispatch:**
  - Triggers web push notification directly to registered admin PWA devices on every successful payment.
  - Strict deduplication within 5 minutes preventing repeated alerts for the same order.
- [x] **Order Success Page:**
  - Order confirmed celebratory UI with order number, delivery estimate, customer summary, items list, and tracking button.
  - Auto-clears purchased items from shopping cart.

### 1.9 Customer Orders & Tracking (`my-orders.html`)
- [x] **Look up by Phone / Email:**
  - Allows customers to view past order history by phone number.
- [x] **Order Status Display:**
  - Order status badge: `PLACED`, `PROCESSING`, `SHIPPED`, `DELIVERED`, `CANCELLED`.
  - Courier partner name and tracking number link when fulfilled by admin.

### 1.10 Static & Policy Pages
- [x] `about.html`: Brand story, craftsmanship, heritage, and values.
- [x] `policy.html`: Shipping policy, Return & exchange policy, Privacy policy, Terms.
- [x] `contact.html`: Contact form, store address, phone numbers, and support email.
- [x] `signin.html`: Customer login / account registration via Supabase Auth.

---

## 2. Admin Portal (`iqbal-admin`)

### 2.1 Navigation & Dashboard Layout
- [x] **Header with Admin Badge:**
  - Brand logo with gold "ADMIN" badge pill.
  - Mobile drawer trigger and quick action shortcuts.
- [x] **Desktop Tab Navigation:**
  - Dashboard, Orders, Coupons & Banners, All Products, Categories, Sizes & Stock, + Add Product, Bulk Upload, Hero Banners, Users.
- [x] **Mobile Fixed Bottom Taskbar:**
  - Dashboard, Orders, Products, Categories, Sizes, Menu drawer button.
- [x] **Slide-Out Admin Navigation Drawer:**
  - Categorized menu sections: Overview & Sales, Marketing & Promotions, Catalog & Inventory, Users & System.
- [x] **Web Push Notification Registration Button:**
  - 1-click device registration for browser Web Push notifications.
  - Saves subscription endpoint and encryption keys to `admin_push_subscriptions` in Supabase.
  - Status indicator: "NOTIFICATIONS ENABLED" with green indicator.

### 2.2 Analytics Dashboard (`index.html`)
- [x] **Metric Summary Cards:**
  - Total Revenue (₹), Total Orders count, Pending Orders, Delivered Orders, Total Customers.
- [x] **Recent Orders Table:**
  - Realtime list of latest customer orders with status badges and quick view actions.

### 2.3 Order Management & Slips (`orders.html`)
- [x] **Comprehensive Orders Table:**
  - Order Number, Customer Name, Phone, Delivery Address, Total Amount, Payment Status (`PAID`, `PENDING`, `FAILED`), Order Status (`PLACED`, `PROCESSING`, `SHIPPED`, `DELIVERED`, `CANCELLED`).
  - Line items breakdown with product names, sizes/lengths, and quantities.
- [x] **Status Update Action:**
  - Instant status switcher updating Supabase `orders` table in realtime.
- [x] **Courier Tracking Assignment:**
  - Modal to input Courier Name (e.g. Bluedart, Delhivery, DTDC) and Tracking AWB Number.
- [x] **Printable Packing Slip & Invoice:**
  - Formatted printable invoice/packing slip for fulfillment and shipping packages.
- [x] **Order Deletion Safety:**
  - Delete order with confirmation (deletes child `order_items` and `payments` safely).

### 2.4 Hero Banner Slider Manager (`add-banner.html`)
- [x] **Create Hero Banner:**
  - Banner Title, Subtitle, Badge Text, Target Page Link.
  - Image upload with client-side compression to Supabase Storage (`product-images` or `banner-images`).
  - Display priority / ordering integer.
  - Published status toggle (`is_active`).
- [x] **Manage Active Banners:**
  - Table of current banners with thumbnail preview.
  - Edit banner modal (change title, replace image, update link, reorder).
  - Delete banner action.

### 2.5 Promotional Coupons & Event Banners (`coupons.html`)
- [x] **Create & Edit Coupons:**
  - Coupon Code (unique, uppercase).
  - Discount type: Percentage (`%`) or Flat (`₹`).
  - Discount value, Minimum order threshold, Maximum discount cap.
  - Active status toggle.
- [x] **Homepage Event Banner Toggle:**
  - `show_home_banner` boolean toggle.
  - Banner Headline Message and Tag (e.g. "SPECIAL EVENT OFFER").
  - Instantly appears or disappears from storefront home page without redeploy.
- [x] **Product Offer Badge Toggle:**
  - `show_product_banner` boolean toggle displaying promotional badge on product pages.

### 2.6 Category Management (`categories.html`)
- [x] **View Categories:**
  - Ordered listing of categories with thumbnail, name, slug, description, display order, active status.
- [x] **Add Category:**
  - Category Name, auto-generated URL slug, Description, Display order, Active toggle.
  - Image / Banner file upload to Supabase Storage with preview.
- [x] **Edit Category:**
  - Full modal editing of name, slug, description, banner replacement, display order, and status.
- [x] **Delete Category Safety:**
  - Safe unlinking of assigned products before deletion.

### 2.7 Catalog & Product Management (`all-products.html`, `add-product.html`)
- [x] **All Products Catalog Table:**
  - Search products by name, filter by category.
  - Thumbnail, name, price, MRP, category, stock availability status, new arrival flag.
  - Quick actions: Edit, Toggle Status, Delete.
- [x] **Add Product Workflow (`add-product.html`):**
  - Product Name, Selling Price, Original MRP, Category dropdown selector, Description.
  - Primary Cover Image upload with preview.
  - Unlimited Gallery Images multi-file upload with drag-and-drop support and reordering badges.
  - Fabric Cut Lengths / Sizes availability grid:
    - Interactive 3-state chips: In-Stock (green) → Out-of-Stock (red cross) → Unselected.
    - Presets: Standard cuts (1.2M - 2.5M), Suit cuts (2.8M - 5.0M), All/Custom.
    - Custom meter cut addition on the fly.
  - Automatic client-side canvas WebP/JPEG compression.
  - Inserts `products` row, uploads all gallery files to Supabase Storage, records `product_images` rows, and inserts `product_variants` rows.
- [x] **Bulk Product Upload (`bulk-upload.html`):**
  - Batch upload interface for multiple products.

### 2.8 Sizes & Stock Matrix (`sizes.html`)
- [x] **Master Size Presets Hub:**
  - Configure standard cut lengths, trouser lengths, shirt lengths, suit lengths.
  - Add new cut presets, toggle active state, delete unused presets.
- [x] **Store Delivery & Shipping Charges:**
  - Configure store-wide standard delivery fee (e.g. ₹60).
  - Configure free shipping threshold (e.g. ₹999).
  - Saves to `store_settings` table in Supabase.

### 2.9 Registered Customers (`users.html`)
- [x] **Customer Profiles Table:**
  - Full name, phone number, role, default address, registered date.

---

## 3. Serverless Functions & Backend Infrastructure (`/api`)

- [x] `/api/create-cashfree-order.js`:
  - Validates request body, reads `CASHFREE_APP_ID`, `CASHFREE_SECRET_KEY`, `CASHFREE_ENV`.
  - Dispatches HTTPS POST to Cashfree `/pg/orders` with `order_id`, `order_amount`, customer details, return URL.
  - Returns Cashfree payment session ID to frontend.
- [x] `/api/verify-cashfree-order.js`:
  - Verifies order with Cashfree API `/pg/orders/{order_id}` and `/pg/orders/{order_id}/payments`.
  - Updates Supabase `orders` table with safe constraint values (`PAID`/`FAILED`, `PLACED`/`CANCELLED`).
  - Dispatches push notification to admin PWA with strict 5-minute deduplication map.
- [x] `/api/cashfree-webhook.js`:
  - Cashfree Webhook endpoint listening for `PAYMENT_SUCCESS_WEBHOOK` and failure events.
  - Idempotent database update and admin push notification dispatch.
- [x] `/api/send-push.js`:
  - Encrypted Web Push dispatch using `web-push` library.
  - Fetches subscriptions from `admin_push_subscriptions` using service role key.
  - Deduplicates events to avoid annoying duplicate notifications.

---

## 4. Progressive Web App (PWA) & Service Workers

- [x] `iqbal-user/sw.js`:
  - Offline asset caching (`STATIC_CACHE_NAME`).
  - Cache-first strategy for media and Supabase Storage assets (`MEDIA_CACHE_NAME`).
  - Network-first strategy for live HTML, CSS, and JS ensuring instant updates.
  - Passthrough for live Supabase REST/Realtime calls.
- [x] `iqbal-admin/sw.js`:
  - Admin PWA caching with fast reload.
  - Background Web Push notification receiver (`self.addEventListener('push')`).
  - Notification click handler opening `/orders.html` in browser or focusing existing tab.
