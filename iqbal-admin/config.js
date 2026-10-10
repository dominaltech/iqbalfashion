// IQBAL FASHION ADMIN CONFIGURATION
// Centralized Brand & Infrastructure Configuration

const SUPABASE_URL = (typeof process !== 'undefined' && process.env && process.env.NEXT_PUBLIC_SUPABASE_URL) || "https://yimbuvqtlbqdfggthaqt.supabase.co";
const SUPABASE_ANON_KEY = (typeof process !== 'undefined' && process.env && process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY) || "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlpbWJ1dnF0bGJxZGZnZ3RoYXF0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTE2MzEyODEsImV4cCI6MjEwNzIwNzI4MX0.fnYjQ3mq13rkP-9sCyIsEt50Y5LQddwbGMtytJBajlU";

window.UR_CONFIG = {
  BRAND_NAME: "Iqbal Fashion Admin",
  STORE_NAME: "Iqbal Fashion",
  DOMAIN: "iqbalfashion.com",
  LOGO_URL: "images/logo.png",

  // Supabase Database & Auth Credentials
  SUPABASE_URL: SUPABASE_URL,
  SUPABASE_ANON_KEY: SUPABASE_ANON_KEY,

  // Cashfree Payment Gateway Credentials (READ FROM VERCEL ENV VARS)
  CASHFREE_APP_ID: (typeof process !== 'undefined' && process.env && process.env.CASHFREE_APP_ID) || "",
  CASHFREE_SECRET_KEY: (typeof process !== 'undefined' && process.env && process.env.CASHFREE_SECRET_KEY) || "",
  CASHFREE_ENV: (typeof process !== 'undefined' && process.env && process.env.CASHFREE_ENV) || "PRODUCTION",

  // Web Push Notifications VAPID Keys
  VAPID_SUBJECT: "mailto:iqbalfashiongents@gmail.com",
  VAPID_PUBLIC_KEY: "BF3kSJsLXqbdtvzEQewSqxomcxnyvbse1p2M6fGn8x-tIzy_HpANDKK6AeHoafBz6Gx0EHGWF2MaOuC2jg7pKCM",
  VAPID_PRIVATE_KEY: "" // Server-only, never exposed to client
};

// Aliases for seamless backward compatibility
window.IQBAL_CONFIG = window.UR_CONFIG;
window.CLASSIC_CONFIG = window.UR_CONFIG;
