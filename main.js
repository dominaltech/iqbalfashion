// IQBAL FASHION STOREFRONT CORE JAVASCRIPT SYSTEM

(function() {
  'use strict';

  // 1. RESOLVE SUPABASE CREDENTIALS FROM WINDOW CONFIG OR FALLBACK
  const cfg = window.UR_CONFIG || window.IQBAL_CONFIG || {};
  const SUPABASE_URL = cfg.SUPABASE_URL || "https://yimbuvqtlbqdfggthaqt.supabase.co";
  const SUPABASE_ANON_KEY = cfg.SUPABASE_ANON_KEY || "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlpbWJ1dnF0bGJxZGZnZ3RoYXF0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTE2MzEyODEsImV4cCI6MjEwNzIwNzI4MX0.fnYjQ3mq13rkP-9sCyIsEt50Y5LQddwbGMtytJBajlU";

  window.UR_CONFIG = window.UR_CONFIG || {};
  window.UR_CONFIG.SUPABASE_URL = SUPABASE_URL;
  window.UR_CONFIG.SUPABASE_ANON_KEY = SUPABASE_ANON_KEY;
  window.UR_CONFIG.BRAND_NAME = "Iqbal Fashion";
  window.IQBAL_CONFIG = window.UR_CONFIG;
  window.CLASSIC_CONFIG = window.UR_CONFIG;

  // Global Store Delivery & Shipping Defaults (Hydrated from cache or Supabase)
  const cachedSettings = localStorage.getItem('iqbalfashion_store_settings') || localStorage.getItem('classic_store_settings');
  if (cachedSettings) {
    try {
      const parsed = JSON.parse(cachedSettings);
      window.UR_CONFIG.DELIVERY_FEE = parsed.delivery_fee !== undefined ? parseFloat(parsed.delivery_fee) : 60;
      window.UR_CONFIG.FREE_SHIPPING_ABOVE = parsed.free_shipping_above !== undefined ? parseFloat(parsed.free_shipping_above) : 999;
    } catch(e) {
      window.UR_CONFIG.DELIVERY_FEE = 60;
      window.UR_CONFIG.FREE_SHIPPING_ABOVE = 999;
    }
  } else {
    window.UR_CONFIG.DELIVERY_FEE = 60;
    window.UR_CONFIG.FREE_SHIPPING_ABOVE = 999;
  }

  // Global client reference
  window.urSupabase = null;

  async function fetchStoreSettings() {
    const client = window.urSupabase || createSupabaseClient();
    if (!client) return;
    try {
      const { data, error } = await client
        .from('store_settings')
        .select('*')
        .limit(1)
        .maybeSingle();

      if (data) {
        if (data.delivery_fee !== undefined) window.UR_CONFIG.DELIVERY_FEE = parseFloat(data.delivery_fee);
        if (data.free_shipping_above !== undefined) window.UR_CONFIG.FREE_SHIPPING_ABOVE = parseFloat(data.free_shipping_above);
        localStorage.setItem('iqbalfashion_store_settings', JSON.stringify(data));
      }
    } catch(e) {
      console.log('Store settings fetch bypass:', e);
    }
  }

  function createSupabaseClient() {
    if (window.urSupabase) return window.urSupabase;
    if (window.supabase && typeof window.supabase.createClient === 'function') {
      try {
        window.urSupabase = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
        console.log('Storefront Supabase initialized successfully');
        fetchStoreSettings();
        return window.urSupabase;
      } catch (e) {
        console.error('Error creating Supabase client:', e);
      }
    }
    return null;
  }

  // Synchronous attempt
  createSupabaseClient();

  // Retry loop for mobile browsers with slower CDN script evaluation
  let retryCount = 0;
  const initInterval = setInterval(function() {
    if (createSupabaseClient() || retryCount > 20) {
      clearInterval(initInterval);
      fetchStoreSettings();
      document.dispatchEvent(new CustomEvent('urSupabaseReady'));
    }
    retryCount++;
  }, 100);

  // 2. GLOBAL DRAWER CONTROLS FOR MOBILE MENU & TASKBAR (Parse-time global attachment)
  window.openCatDrawer = function() {
    let overlay = document.getElementById('hamburgerOverlay') || document.getElementById('catOverlay') || document.querySelector('.hamburger-overlay') || document.querySelector('.drawer-overlay');
    if (!overlay) {
      overlay = document.createElement('div');
      overlay.className = 'hamburger-overlay';
      overlay.id = 'hamburgerOverlay';
      overlay.innerHTML = `
        <div class="hamburger-drawer">
          <div class="ham-head">
            <img src="images/logo.png" alt="Iqbal Fashion" style="height:36px;width:auto;object-fit:contain;" />
            <button class="ham-close" id="hamCloseBtn" onclick="closeCatDrawer()"><svg viewBox="0 0 24 24" style="width:20px;height:20px;stroke:currentColor;fill:none;stroke-width:2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg></button>
          </div>
          <div class="ham-body" style="padding-bottom: 90px;">
            <a href="index.html" class="ham-link">Home</a>
            <a href="shop.html" class="ham-link">All Products Catalog</a>

            <!-- 1. READYMADE -->
            <div class="ham-cat-section">
              <div class="ham-section-title">1. READYMADE COLLECTION</div>
              <div class="ham-image-tiles-grid">
                <a href="ethnic.html" class="ham-image-tile">
                  <div class="ham-tile-thumb"><img src="images/hero2.jpg" alt="Ethnic Wear" loading="lazy" /></div>
                  <div class="ham-tile-info"><span class="ham-tile-name">Ethnic Wear</span><span class="ham-tile-arrow">→</span></div>
                </a>
                <a href="casual-wear.html" class="ham-image-tile">
                  <div class="ham-tile-thumb"><img src="images/cat-readymade.jpg" alt="Casual Wear" loading="lazy" /></div>
                  <div class="ham-tile-info"><span class="ham-tile-name">Casual Wear</span><span class="ham-tile-arrow">→</span></div>
                </a>
              </div>
              <a href="readymade.html" class="ham-link" style="font-size:12px;font-weight:700;color:#000;border-bottom:1px dashed #eee;padding:6px 0 10px;">Explore All Readymade →</a>
            </div>

            <!-- 2. CLOTH MATERIAL -->
            <div class="ham-cat-section">
              <div class="ham-section-title">2. CLOTH MATERIAL &amp; FABRICS</div>
              <div class="ham-image-tiles-grid">
                <a href="suiting.html" class="ham-image-tile">
                  <div class="ham-tile-thumb"><img src="images/cat-cloth-material.jpg" alt="Suiting Material" loading="lazy" /></div>
                  <div class="ham-tile-info"><span class="ham-tile-name">Suiting</span><span class="ham-tile-arrow">→</span></div>
                </a>
                <a href="shirting.html" class="ham-image-tile">
                  <div class="ham-tile-thumb"><img src="images/hero1.jpg" alt="Shirting Cloth" loading="lazy" /></div>
                  <div class="ham-tile-info"><span class="ham-tile-name">Shirting</span><span class="ham-tile-arrow">→</span></div>
                </a>
                <a href="linen.html" class="ham-image-tile">
                  <div class="ham-tile-thumb"><img src="images/cat-cloth-material.jpg" alt="Pure Linen" loading="lazy" /></div>
                  <div class="ham-tile-info"><span class="ham-tile-name">Pure Linen</span><span class="ham-tile-arrow">→</span></div>
                </a>
                <a href="cotton.html" class="ham-image-tile">
                  <div class="ham-tile-thumb"><img src="images/prod1.jpg" alt="Pure Cotton" loading="lazy" /></div>
                  <div class="ham-tile-info"><span class="ham-tile-name">Pure Cotton</span><span class="ham-tile-arrow">→</span></div>
                </a>
                <a href="silk.html" class="ham-image-tile">
                  <div class="ham-tile-thumb"><img src="images/hero2.jpg" alt="Royal Silk" loading="lazy" /></div>
                  <div class="ham-tile-info"><span class="ham-tile-name">Royal Silk</span><span class="ham-tile-arrow">→</span></div>
                </a>
                <a href="khadi.html" class="ham-image-tile">
                  <div class="ham-tile-thumb"><img src="images/cat-cloth-material.jpg" alt="Handloom Khadi" loading="lazy" /></div>
                  <div class="ham-tile-info"><span class="ham-tile-name">Khadi</span><span class="ham-tile-arrow">→</span></div>
                </a>
              </div>
              <a href="cloth-material.html" class="ham-link" style="font-size:12px;font-weight:700;color:#000;border-bottom:1px dashed #eee;padding:6px 0 10px;">Explore All Fabrics &amp; Unstitched Materials →</a>
            </div>

            <!-- 3. KIDS COLLECTION -->
            <div class="ham-cat-section">
              <div class="ham-section-title">3. KIDS COLLECTION</div>
              <div class="ham-image-tiles-grid">
                <a href="boys.html" class="ham-image-tile">
                  <div class="ham-tile-thumb"><img src="images/cat-kids.jpg" alt="Boys Collection" loading="lazy" /></div>
                  <div class="ham-tile-info"><span class="ham-tile-name">Boys Apparel</span><span class="ham-tile-arrow">→</span></div>
                </a>
                <a href="girls.html" class="ham-image-tile">
                  <div class="ham-tile-thumb"><img src="images/cat-kids.jpg" alt="Girls Collection" loading="lazy" /></div>
                  <div class="ham-tile-info"><span class="ham-tile-name">Girls Apparel</span><span class="ham-tile-arrow">→</span></div>
                </a>
              </div>
              <a href="kids.html" class="ham-link" style="font-size:12px;font-weight:700;color:#000;border-bottom:1px dashed #eee;padding:6px 0 10px;">Explore All Kids Collection →</a>
            </div>

            <div class="ham-divider" style="height:1px;background:var(--border);margin:16px 0;"></div>
            <a href="my-orders.html" class="ham-link">My Orders</a>
            <a href="cart.html" class="ham-link">My Shopping Bag</a>
            <a href="about.html" class="ham-link">About Us</a>
            <a href="policy.html" class="ham-link">Policy</a>
            <a href="contact.html" class="ham-link">Contact Us</a>
            <a href="signin.html" class="ham-link">Account / Sign In</a>
          </div>
        </div>
      `;
      overlay.addEventListener('click', function(e) {
        if (e.target === overlay) window.closeCatDrawer();
      });
      document.body.appendChild(overlay);
    }
    setTimeout(function() {
      overlay.classList.add('active');
      overlay.classList.add('open');
      document.body.style.overflow = 'hidden';
    }, 10);
  };

  window.closeCatDrawer = function(e) {
    if (e && e.target && e.target !== e.currentTarget && !e.target.classList.contains('hamburger-overlay') && !e.target.classList.contains('drawer-overlay') && !e.target.classList.contains('ham-close')) {
      return;
    }
    let overlays = document.querySelectorAll('#hamburgerOverlay, #catOverlay, .hamburger-overlay, .drawer-overlay');
    overlays.forEach(overlay => {
      overlay.classList.remove('active');
      overlay.classList.remove('open');
    });
    document.body.style.overflow = '';
  };

  // 3. SHOPPING CART STATE MANAGEMENT
  window.UR_CART = {
    get: function() {
      try {
        return JSON.parse(localStorage.getItem('iqbalfashion_cart') || localStorage.getItem('classic_cart')) || [];
      } catch (e) {
        return [];
      }
    },
    set: function(items) {
      localStorage.setItem('iqbalfashion_cart', JSON.stringify(items));
      this.updateBadge();
    },
    add: function(item) {
      let cart = this.get();
      let existingIndex = cart.findIndex(i => i.id === item.id && i.size === item.size);
      if (existingIndex > -1) {
        cart[existingIndex].quantity += (item.quantity || 1);
      } else {
        cart.push({
          id: item.id,
          name: item.name,
          price: parseFloat(item.price),
          image: item.image,
          size: item.size || 'Standard Cut',
          quantity: item.quantity || 1
        });
      }
      this.set(cart);
      window.UR_TOAST('Added to cart!');
    },
    remove: function(id, size) {
      let cart = this.get().filter(i => !(i.id === id && i.size === size));
      this.set(cart);
    },
    updateQty: function(id, size, delta) {
      let cart = this.get();
      let item = cart.find(i => i.id === id && i.size === size);
      if (item) {
        item.quantity += delta;
        if (item.quantity <= 0) {
          cart = cart.filter(i => !(i.id === id && i.size === size));
        }
      }
      this.set(cart);
    },
    calculateTotals: function() {
      let cart = this.get();
      let subtotal = cart.reduce((sum, item) => sum + (parseFloat(item.price || 0) * parseInt(item.quantity || 1)), 0);
      let isOnlyTestProduct = cart.length > 0 && cart.every(item => item.name && (item.name.includes('Test Product') || item.name.includes('1 Rupee') || item.name.includes('₹1')));
      
      let deliveryFee = (window.UR_CONFIG && window.UR_CONFIG.DELIVERY_FEE !== undefined) ? window.UR_CONFIG.DELIVERY_FEE : 60;
      let freeThreshold = (window.UR_CONFIG && window.UR_CONFIG.FREE_SHIPPING_ABOVE !== undefined) ? window.UR_CONFIG.FREE_SHIPPING_ABOVE : 999;

      let isFreeShipping = isOnlyTestProduct || (freeThreshold > 0 && subtotal >= freeThreshold);
      let shippingFee = isFreeShipping ? 0 : (subtotal > 0 ? deliveryFee : 0);

      // Dynamic Coupon discount calculation
      let coupon = window.UR_COUPON ? window.UR_COUPON.get() : null;
      let discount = 0;
      let discountType = null;
      let discountValue = 0;
      let couponCode = null;

      if (coupon && subtotal > 0) {
        const minOrder = parseFloat(coupon.min_order_value || 0);
        if (subtotal >= minOrder) {
          couponCode = coupon.code;
          discountType = coupon.discount_type || 'PERCENTAGE';
          discountValue = parseFloat(coupon.discount_value || 0);

          if (discountType === 'PERCENTAGE') {
            discount = (subtotal * (discountValue / 100));
            if (coupon.max_discount && discount > parseFloat(coupon.max_discount)) {
              discount = parseFloat(coupon.max_discount);
            }
          } else {
            // Flat amount discount
            discount = Math.min(subtotal, discountValue);
          }
          discount = Math.round(discount * 100) / 100;
        }
      }

      let total = Math.max(0, subtotal - discount + shippingFee);
      return { 
        subtotal, 
        discount, 
        discountType,
        discountValue, 
        couponCode, 
        coupon, 
        shippingFee, 
        total, 
        isOnlyTestProduct, 
        deliveryFee, 
        freeThreshold, 
        isFreeShipping 
      };
    },
    updateBadge: function() {
      let cart = this.get();
      let count = cart.reduce((sum, item) => sum + item.quantity, 0);
      document.querySelectorAll('.cart-count-badge').forEach(el => {
        el.textContent = count;
        el.style.display = count > 0 ? 'flex' : 'none';
      });
    }
  };

  // 3.5 DYNAMIC STORE COUPON & EVENT BANNER ENGINE
  window.UR_COUPON = {
    get: function() {
      try {
        const raw = localStorage.getItem('ur_applied_coupon');
        return raw ? JSON.parse(raw) : null;
      } catch (e) {
        return null;
      }
    },
    set: function(couponObj) {
      if (couponObj) {
        localStorage.setItem('ur_applied_coupon', JSON.stringify(couponObj));
      } else {
        localStorage.removeItem('ur_applied_coupon');
      }
    },
    fetchActiveCoupons: async function() {
      const client = window.urSupabase || (window.supabase && typeof window.supabase.createClient === 'function' ? window.supabase.createClient(window.UR_CONFIG.SUPABASE_URL, window.UR_CONFIG.SUPABASE_ANON_KEY) : null);
      if (!client) return [];
      try {
        const { data, error } = await client
          .from('coupons')
          .select('*')
          .eq('is_active', true)
          .order('created_at', { ascending: false });
        return data || [];
      } catch (err) {
        return [];
      }
    },
    fetchHomeBannerCoupon: async function() {
      const client = window.urSupabase || (window.supabase && typeof window.supabase.createClient === 'function' ? window.supabase.createClient(window.UR_CONFIG.SUPABASE_URL, window.UR_CONFIG.SUPABASE_ANON_KEY) : null);
      if (!client) return null;
      try {
        const { data, error } = await client
          .from('coupons')
          .select('*')
          .eq('is_active', true)
          .eq('show_home_banner', true)
          .order('created_at', { ascending: false })
          .limit(1)
          .maybeSingle();
        return data || null;
      } catch (err) {
        return null;
      }
    },
    fetchProductBannerCoupon: async function() {
      const client = window.urSupabase || (window.supabase && typeof window.supabase.createClient === 'function' ? window.supabase.createClient(window.UR_CONFIG.SUPABASE_URL, window.UR_CONFIG.SUPABASE_ANON_KEY) : null);
      if (!client) return null;
      try {
        const { data, error } = await client
          .from('coupons')
          .select('*')
          .eq('is_active', true)
          .eq('show_product_banner', true)
          .order('created_at', { ascending: false })
          .limit(1)
          .maybeSingle();
        return data || null;
      } catch (err) {
        return null;
      }
    },
    apply: async function(code) {
      const clean = (code || '').trim().toUpperCase();
      if (!clean) {
        if (typeof window.UR_TOAST === 'function') window.UR_TOAST('Please enter a coupon code');
        return { success: false, message: 'Please enter a coupon code' };
      }

      const client = window.urSupabase || (window.supabase && typeof window.supabase.createClient === 'function' ? window.supabase.createClient(window.UR_CONFIG.SUPABASE_URL, window.UR_CONFIG.SUPABASE_ANON_KEY) : null);
      
      let couponData = null;
      if (client) {
        try {
          const { data, error } = await client
            .from('coupons')
            .select('*')
            .eq('code', clean)
            .eq('is_active', true)
            .maybeSingle();
          if (data) couponData = data;
        } catch (e) {}
      }

      // Fallback defaults
      if (!couponData && (clean === 'URBAN5' || clean === 'RAKHI5')) {
        couponData = {
          code: clean,
          title: 'Special Discount',
          discount_type: 'PERCENTAGE',
          discount_value: 5,
          min_order_value: 0
        };
      }

      if (couponData) {
        const couponObj = {
          code: couponData.code,
          title: couponData.title,
          discount_type: couponData.discount_type || 'PERCENTAGE',
          discount_value: parseFloat(couponData.discount_value || 0),
          min_order_value: parseFloat(couponData.min_order_value || 0),
          max_discount: couponData.max_discount ? parseFloat(couponData.max_discount) : null
        };
        this.set(couponObj);
        const desc = couponObj.discount_type === 'PERCENTAGE' ? `${couponObj.discount_value}% OFF` : `₹${couponObj.discount_value} OFF`;
        if (typeof window.UR_TOAST === 'function') {
          window.UR_TOAST(`Coupon ${couponObj.code} applied! (${desc})`);
        }
        return { success: true, coupon: couponObj };
      } else {
        if (typeof window.UR_TOAST === 'function') {
          window.UR_TOAST('Invalid or expired coupon code.');
        }
        return { success: false, message: 'Invalid or expired coupon code' };
      }
    },
    toggle: async function(code) {
      const current = this.get();
      if (current && current.code === (code || '').toUpperCase()) {
        this.remove();
        return false;
      } else {
        const res = await this.apply(code);
        return res.success;
      }
    },
    remove: function() {
      this.set(null);
      if (typeof window.UR_TOAST === 'function') {
        window.UR_TOAST('Coupon removed.');
      }
    },
    isApplied: function(code) {
      const current = this.get();
      return !!(current && current.code === (code || '').toUpperCase());
    }
  };

  // 4. TOAST NOTIFICATION UTILITY
  window.UR_TOAST = function(message) {
    let container = document.getElementById('toastContainer');
    if (!container) {
      container = document.createElement('div');
      container.id = 'toastContainer';
      container.className = 'toast-container';
      document.body.appendChild(container);
    }
    let toast = document.createElement('div');
    toast.className = 'toast';
    toast.innerHTML = `<span>${message}</span>`;
    container.appendChild(toast);
    setTimeout(() => {
      toast.remove();
    }, 3000);
  };

  // 5. ANIMATIONS & OVERLAY EVENT LISTENERS
  function initAnimations() {
    const fadeEls = document.querySelectorAll('.fade-up');
    fadeEls.forEach(el => el.classList.add('visible'));
    if ('IntersectionObserver' in window) {
      const obs = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
          if (entry.isIntersecting) {
            entry.target.classList.add('visible');
          }
        });
      }, { threshold: 0.05 });
      fadeEls.forEach(el => obs.observe(el));
    }
  }

  // 2b. GLOBAL SEARCH OVERLAY CONTROLS
  window.openSearchOverlay = function() {
    let overlay = document.getElementById('searchOverlay');
    if (!overlay) {
      overlay = document.createElement('div');
      overlay.className = 'search-overlay';
      overlay.id = 'searchOverlay';
      overlay.innerHTML = `
        <button class="search-overlay-close" aria-label="Close search" onclick="closeSearchOverlay()">
          <svg viewBox="0 0 24 24" style="width:20px;height:20px;stroke:currentColor;fill:none;stroke-width:2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
        </button>
        <div class="search-box">
          <svg viewBox="0 0 24 24" style="width:20px;height:20px;stroke:currentColor;fill:none;stroke-width:2"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
          <input type="search" class="search-input" placeholder="Search for products…" autocomplete="off" />
        </div>
        <div class="search-label">Top Searches</div>
        <div class="search-tags">
          <a href="readymade.html" class="search-tag">Readymade</a>
          <a href="ethnic.html" class="search-tag">Ethnic Kurta</a>
          <a href="casual-wear.html" class="search-tag">Casual Wear</a>
          <a href="cloth-material.html" class="search-tag">Cloth Material</a>
          <a href="linen.html" class="search-tag">Pure Linen</a>
          <a href="cotton.html" class="search-tag">Pure Cotton</a>
          <a href="silk.html" class="search-tag">Royal Silk</a>
          <a href="kids.html" class="search-tag">Kids Wear</a>
        </div>
      `;
      document.body.appendChild(overlay);
    }
    setTimeout(function() {
      overlay.classList.add('active');
      overlay.classList.add('open');
      document.body.style.overflow = 'hidden';
      const input = overlay.querySelector('.search-input');
      if (input) input.focus();
    }, 10);
  };

  window.closeSearchOverlay = function() {
    let overlay = document.getElementById('searchOverlay');
    if (overlay) {
      overlay.classList.remove('active');
      overlay.classList.remove('open');
      document.body.style.overflow = '';
    }
  };

  function initOverlayListeners() {
    document.querySelectorAll('.js-search-open').forEach(btn => {
      btn.addEventListener('click', (e) => {
        e.preventDefault();
        window.openSearchOverlay();
      });
    });
    document.querySelectorAll('.search-overlay-close').forEach(btn => {
      btn.addEventListener('click', (e) => {
        e.preventDefault();
        window.closeSearchOverlay();
      });
    });

    document.addEventListener('keydown', function(e) {
      if (e.key === 'Enter' && e.target && e.target.classList.contains('search-input')) {
        e.preventDefault();
        const val = e.target.value.trim();
        if (val) {
          window.closeSearchOverlay();
          window.location.href = `shop.html?search=${encodeURIComponent(val)}`;
        }
      }
      if (e.key === 'Escape') {
        window.closeSearchOverlay();
        window.closeCatDrawer();
      }
    });

    document.querySelectorAll('.js-hamburger-open').forEach(btn => {
      btn.addEventListener('click', (e) => {
        e.preventDefault();
        window.openCatDrawer();
      });
    });
    const hamClose = document.getElementById('hamCloseBtn');
    if (hamClose) {
      hamClose.addEventListener('click', () => {
        window.closeCatDrawer();
      });
    }
    const hamOverlay = document.getElementById('hamburgerOverlay') || document.getElementById('catOverlay');
    if (hamOverlay) {
      hamOverlay.addEventListener('click', (e) => {
        if (e.target === hamOverlay) window.closeCatDrawer();
      });
    }
  }

    // 7. DYNAMIC CATEGORY NAVIGATION LOADER WITH SMART SESSION CACHING
    window.fetchStoreCategories = async function(forceRefresh = false) {
      const cacheKey = 'ur_cached_categories';
      const cacheTimeKey = 'ur_cached_categories_time';
      const now = Date.now();

      if (!forceRefresh) {
        const cached = sessionStorage.getItem(cacheKey);
        const cachedTime = sessionStorage.getItem(cacheTimeKey);
        if (cached && cachedTime && (now - parseInt(cachedTime, 10)) < 5000) {
          try {
            return JSON.parse(cached);
          } catch(e) {}
        }
      }

      const client = window.urSupabase || createSupabaseClient();
      if (!client) return [];
      try {
        const { data, error } = await client
          .from('categories')
          .select('id, name, slug, display_order, banner_url, image_url, is_active')
          .eq('is_active', true)
          .order('display_order', { ascending: true });

        if (data && data.length > 0) {
          try {
            sessionStorage.setItem(cacheKey, JSON.stringify(data));
            sessionStorage.setItem(cacheTimeKey, now.toString());
          } catch(e) {}
        }
        return data || [];
      } catch (err) {
        console.error('fetchStoreCategories error:', err);
        return [];
      }
    };

    async function initDynamicCategoriesNav() {
      const categories = await window.fetchStoreCategories();
      if (!categories || categories.length === 0) return;

      // Update Desktop Nav Links
      const navLinksContainer = document.querySelector('.site-header .nav-links');
      if (navLinksContainer) {
        let html = `
          <div class="nav-item"><a href="readymade.html" class="nav-link">Readymade</a></div>
          <div class="nav-item"><a href="cloth-material.html" class="nav-link">Cloth Material</a></div>
          <div class="nav-item"><a href="kids.html" class="nav-link">Kids</a></div>
          <div class="nav-item"><a href="ethnic.html" class="nav-link">Ethnic</a></div>
          <div class="nav-item"><a href="casual-wear.html" class="nav-link">Casual</a></div>
          <div class="nav-item"><a href="shop.html" class="nav-link">All Collections</a></div>
        `;
        navLinksContainer.innerHTML = html;
      }

      // Update Mobile Drawer Sublinks
      const hamSublinks = document.querySelector('.hamburger-drawer .ham-sublinks');
      if (hamSublinks) {
        let subHtml = '';
        categories.forEach(cat => {
          if (cat.slug === 'test-items' || (cat.name && cat.name.toLowerCase().includes('test'))) {
            return;
          }

          let targetUrl = `shop.html?category=${encodeURIComponent(cat.slug || cat.id)}`;
          if (cat.slug === 'readymade' || cat.slug === 'baggy') targetUrl = 'readymade.html';
          else if (cat.slug === 'ethnic' || cat.slug === 'hoodies') targetUrl = 'ethnic.html';
          else if (cat.slug === 'casual-wear' || cat.slug === 'oversize' || cat.slug === 'oversized') targetUrl = 'casual-wear.html';
          else if (cat.slug === 'cloth-material' || cat.slug === 'cloth_material' || cat.slug === 'pants' || cat.slug === 'linen-pants') targetUrl = 'cloth-material.html';
          else if (cat.slug === 'kids' || cat.slug === 'plan-tshirt' || cat.slug === 'plain-t-shirts') targetUrl = 'kids.html';
          else if (cat.slug === 'boys' || cat.slug === 'printing-tshirt' || cat.slug === 'printed-t-shirts') targetUrl = 'boys.html';
          else if (cat.slug === 'girls' || cat.slug === 'women') targetUrl = 'girls.html';
          else if (cat.slug === 'linen') targetUrl = 'linen.html';
          else if (cat.slug === 'cotton') targetUrl = 'cotton.html';
          else if (cat.slug === 'silk') targetUrl = 'silk.html';
          else if (cat.slug === 'khadi') targetUrl = 'khadi.html';
          else if (cat.slug === 'suiting') targetUrl = 'suiting.html';
          else if (cat.slug === 'shirting') targetUrl = 'shirting.html';

          subHtml += `<a href="${targetUrl}">${cat.name}</a>`;
        });
        hamSublinks.innerHTML = subHtml;
      }
    }

    // DOM INITIALIZATION
    document.addEventListener('DOMContentLoaded', function() {
      window.UR_CART.updateBadge();
      initAnimations();
      initOverlayListeners();
      initDynamicCategoriesNav();
      if ('serviceWorker' in navigator) {
        navigator.serviceWorker.register('sw.js')
          .then(reg => console.log('Storefront SW registered:', reg))
          .catch(err => console.error('Storefront SW registration failed:', err));
      }
    });

    document.addEventListener('urSupabaseReady', function() {
      initDynamicCategoriesNav();
    });

  })();

