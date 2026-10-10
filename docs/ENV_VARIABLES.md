# Vercel Environment Variables & Configuration: Iqbal Fashion
*Document Version: 1.0.0 — Comprehensive Secret & Infrastructure Guide*

This document outlines every environment variable required to run both **Iqbal User Portal** (Storefront) and **Iqbal Admin Portal** on Vercel as two distinct projects.

---

## 1. Ground Rules on Security & Secrets
1. **The Supabase Service Role Key is SERVER-ONLY:** It must **never** be prefixed with `VITE_` or `NEXT_PUBLIC_` and must **never** be placed in client-accessible code or repositories. It is used exclusively inside serverless API routes (`/api/verify-cashfree-order.js`, `/api/send-push.js`, `/api/cashfree-webhook.js`).
2. **Zero Hardcoded Secrets:** No `.env` files with real keys are committed to Git. `.gitignore` strictly excludes all `.env*` files except `.env.example`.
3. **Separate Vercel Projects:**
   - **Vercel Project 1:** `iqbal-fashion-user` (Customer Storefront)
   - **Vercel Project 2:** `iqbal-fashion-admin` (Admin Management Portal)

---

## 2. Master Environment Variables Matrix

### 2.1 Iqbal User Portal (`iqbal-fashion-user`)

| Variable Name | Client vs Server | Purpose | Where Used (Files) | Sample / Placeholder |
|---|---|---|---|---|
| `NEXT_PUBLIC_SUPABASE_URL` | Public (Client & Server) | Supabase Project REST & Storage API URL | `config.js`, `main.js`, `api/*.js` | `https://yimbuvqtlbqdfggthaqt.supabase.co` |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Public (Client & Server) | Supabase Anonymous Client Public API Key | `config.js`, `main.js`, `api/*.js` | `eyJhbGciOiJIUzI1Ni...` |
| `SUPABASE_SERVICE_ROLE_KEY` | **SERVER-ONLY SECRET** | Supabase Elevated Master Access (Admin functions & RLS bypass) | `api/verify-cashfree-order.js`, `api/send-push.js`, `api/cashfree-webhook.js` | `eyJhbGciOiJIUzI1Ni...` |
| `CASHFREE_APP_ID` | Server Secret | Cashfree Payment Gateway Client ID / App ID | `api/create-cashfree-order.js`, `api/verify-cashfree-order.js` | Cashfree Client ID |
| `CASHFREE_SECRET_KEY` | Server Secret | Cashfree Payment Gateway Client Secret Key | `api/create-cashfree-order.js`, `api/verify-cashfree-order.js` | Cashfree Secret Key |
| `CASHFREE_ENV` | Server | Cashfree Gateway Environment (`PRODUCTION` or `TEST`) | `api/create-cashfree-order.js`, `api/verify-cashfree-order.js` | `PRODUCTION` |
| `VAPID_SUBJECT` | Server | Web Push Notification Contact URI | `api/send-push.js`, `api/verify-cashfree-order.js`, `api/cashfree-webhook.js` | `mailto:iqbalfashiongents@gmail.com` |
| `NEXT_PUBLIC_VAPID_PUBLIC_KEY` | Public (Client & Server) | Web Push Public Encryption Key (Base64 URL) | `config.js`, `api/send-push.js`, `api/verify-cashfree-order.js` | `BF3kSJsLXqbdtvzEQewSqxomcxnyvbse1p2M6fGn8x-tIzy_HpANDKK6AeHoafBz6Gx0EHGWF2MaOuC2jg7pKCM` |
| `VAPID_PRIVATE_KEY` | **SERVER-ONLY SECRET** | Web Push Private Signing Key | `api/send-push.js`, `api/verify-cashfree-order.js`, `api/cashfree-webhook.js` | `uhpnPsNgbA1cNt6kkNND0mLKMNzAlnPOPowST4H8KFE` |
| `SITE_URL` | Server | Storefront Primary Domain for Callback & Webhook Resolution | `api/create-cashfree-order.js` | `https://iqbalfashion.vercel.app` |

---

### 2.2 Iqbal Admin Portal (`iqbal-fashion-admin`)

| Variable Name | Client vs Server | Purpose | Where Used (Files) | Sample / Placeholder |
|---|---|---|---|---|
| `NEXT_PUBLIC_SUPABASE_URL` | Public (Client) | Supabase Project REST & Storage API URL | `config.js`, `admin.js` | `https://yimbuvqtlbqdfggthaqt.supabase.co` |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Public (Client) | Supabase Anonymous Client Public API Key | `config.js`, `admin.js` | `eyJhbGciOiJIUzI1Ni...` |
| `NEXT_PUBLIC_VAPID_PUBLIC_KEY` | Public (Client) | Web Push Public Key (used by Service Worker `pushManager.subscribe`) | `config.js`, `admin.js` | `BF3kSJsLXqbdtvzEQewSqxomcxnyvbse1p2M6fGn8x-tIzy_HpANDKK6AeHoafBz6Gx0EHGWF2MaOuC2jg7pKCM` |
| `VAPID_SUBJECT` | Public (Client) | Web Push Subject URI | `config.js` | `mailto:iqbalfashiongents@gmail.com` |

---

## 3. Web Push VAPID Key Specifications
In the Classic Collection codebase, the following exact environment variable names are expected by the serverless functions and client scripts:
- **`VAPID_SUBJECT`**: Used by `webpush.setVapidDetails(vapidSubject, vapidPublicKey, vapidPrivateKey)`. Example: `mailto:iqbalfashiongents@gmail.com`.
- **`NEXT_PUBLIC_VAPID_PUBLIC_KEY`**: Exposed to both serverless functions and browser client. On the frontend (`config.js`), it is mapped into `window.UR_CONFIG.VAPID_PUBLIC_KEY` which is converted into a `Uint8Array` when calling `registration.pushManager.subscribe()`.
- **`VAPID_PRIVATE_KEY`**: **Server-only secret** used exclusively in `/api/send-push.js`, `/api/verify-cashfree-order.js`, and `/api/cashfree-webhook.js` to sign push messages.

### How to Generate Fresh VAPID Keys:
Run in any terminal:
```bash
npx web-push generate-vapid-keys
```
Output will provide:
```text
=======================================
Public Key:
<65-byte base64url string>

Private Key:
<32-byte base64url string>
=======================================
```

---

## 4. Cashfree Payment Gateway Settings
Configure in your Cashfree Merchant Dashboard (`merchant.cashfree.com`):
1. **Webhook Notification URL:**
   - URL: `https://<YOUR-USER-VERCEL-DOMAIN>/api/cashfree-webhook`
   - Events subscribed: `PAYMENT_SUCCESS_WEBHOOK`, `PAYMENT_FAILED_WEBHOOK`, `PAYMENT_USER_DROPPED_WEBHOOK`
   - API Version: `2023-08-01`
2. **Return URL:**
   - Automatically constructed dynamically by `/api/create-cashfree-order.js`:
     `https://<YOUR-USER-VERCEL-DOMAIN>/order-success.html?order_id={order_id}`
3. **Whitelisted Origins / Domains:**
   - Add your production Vercel domain and custom domain (e.g. `https://iqbalfashion.com`, `https://iqbalfashion.vercel.app`).

---

## 5. Supabase Auth & Dashboard Settings
Configure in your Supabase Dashboard (`supabase.com/dashboard/project/yimbuvqtlbqdfggthaqt/auth/url-configuration`):
1. **Site URL:**
   `https://<YOUR-USER-VERCEL-DOMAIN>`
2. **Redirect URLs (Allow list):**
   - `https://<YOUR-USER-VERCEL-DOMAIN>/**`
   - `https://<YOUR-ADMIN-VERCEL-DOMAIN>/**`
   - `http://localhost:3000/**`
   - `http://localhost:5000/**`
