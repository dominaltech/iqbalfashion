/**
 * ==============================================================================
 * IQBAL FASHION — STARTUP LOADER & ASSET PRELOADER
 * Thread & Button Micro-Animation with Split Curtain Reveal
 * ==============================================================================
 */

(function() {
  'use strict';

  const LOADER_ID = 'iqbalStartupLoader';
  const SESSION_KEY = 'hasSeenStartupLoader';
  const MAX_SAFETY_TIMEOUT = 3800; // Milliseconds

  const loaderEl = document.getElementById(LOADER_ID);
  if (!loaderEl) return;

  // 1. Session Gating & Accessibility Check
  const hasSeen = sessionStorage.getItem(SESSION_KEY);
  const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  if (hasSeen || prefersReducedMotion) {
    loaderEl.style.display = 'none';
    if (loaderEl.parentNode) loaderEl.parentNode.removeChild(loaderEl);
    return;
  }

  const progressBar = loaderEl.querySelector('.loader-progress-bar-fill');
  let isDismissed = false;

  function updateProgress(percent) {
    if (progressBar) {
      progressBar.style.width = Math.min(100, Math.max(0, percent)) + '%';
    }
  }

  // 2. Dismiss & Curtain Split Reveal
  function dismissLoader() {
    if (isDismissed) return;
    isDismissed = true;
    updateProgress(100);

    setTimeout(() => {
      loaderEl.classList.add('split');
      sessionStorage.setItem(SESSION_KEY, 'true');

      // Dispatch event for other scripts
      try {
        window.dispatchEvent(new CustomEvent('iqbalLoaderComplete'));
      } catch (e) {}

      // Remove from DOM after curtain splits
      setTimeout(() => {
        if (loaderEl.parentNode) {
          loaderEl.parentNode.removeChild(loaderEl);
        }
      }, 900);
    }, 400);
  }

  // 3. Fallback Safety Timeout
  const safetyTimer = setTimeout(() => {
    dismissLoader();
  }, MAX_SAFETY_TIMEOUT);

  // 4. Preload Critical Assets (Hero Slider First Banner)
  async function preloadCriticalHero() {
    let heroUrl = null;

    // Check cached home data
    try {
      const cached = localStorage.getItem('iqbalfashion_home_cache') || localStorage.getItem('classic_home_cache');
      if (cached) {
        const parsed = JSON.parse(cached);
        if (parsed.banners && parsed.banners.length > 0 && parsed.banners[0].image_url) {
          heroUrl = parsed.banners[0].image_url;
        }
      }
    } catch (e) {}

    // Fallback to local default hero or wait for Supabase
    if (!heroUrl) {
      heroUrl = 'images/hero1.jpg';
    }

    updateProgress(35);

    try {
      const img = new Image();
      img.src = heroUrl;
      if ('decode' in img) {
        await img.decode();
      } else {
        await new Promise((resolve) => {
          img.onload = resolve;
          img.onerror = resolve;
        });
      }
      updateProgress(85);
    } catch (err) {
      // Decode error fallback
      updateProgress(85);
    }

    // Minimum animation duration (2000ms) for aesthetic appreciation
    setTimeout(() => {
      clearTimeout(safetyTimer);
      dismissLoader();
    }, 1900);
  }

  // Start preloader on DOM load
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', preloadCriticalHero);
  } else {
    preloadCriticalHero();
  }

})();
