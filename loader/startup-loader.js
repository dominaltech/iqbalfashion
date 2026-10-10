/**
 * ==============================================================================
 * IQBAL FASHION — STARTUP LOADER & ASSET PRELOADER
 * Thread & Button Micro-Animation with Split Curtain Reveal
 * Plays on every website start/load as requested
 * ==============================================================================
 */

(function() {
  'use strict';

  const LOADER_ID = 'iqbalStartupLoader';
  const MAX_SAFETY_TIMEOUT = 2800; // Fast and snappy (2.8s max fallback)

  const loaderEl = document.getElementById(LOADER_ID);
  if (!loaderEl) return;

  const progressBar = loaderEl.querySelector('.loader-progress-bar-fill');
  let isDismissed = false;

  function updateProgress(percent) {
    if (progressBar) {
      progressBar.style.width = Math.min(100, Math.max(0, percent)) + '%';
    }
  }

  // Dismiss & Curtain Split Reveal
  function dismissLoader() {
    if (isDismissed) return;
    isDismissed = true;
    updateProgress(100);

    setTimeout(() => {
      loaderEl.classList.add('split');

      // Dispatch event for other scripts
      try {
        window.dispatchEvent(new CustomEvent('iqbalLoaderComplete'));
      } catch (e) {}

      // Remove from DOM after curtain splits
      setTimeout(() => {
        if (loaderEl && loaderEl.parentNode) {
          loaderEl.parentNode.removeChild(loaderEl);
        }
      }, 900);
    }, 450);
  }

  // Preload Critical Assets (Hero Slider First Banner)
  async function preloadCriticalHero() {
    let heroUrl = null;

    try {
      const cached = localStorage.getItem('iqbalfashion_home_cache');
      if (cached) {
        const parsed = JSON.parse(cached);
        if (parsed.banners && parsed.banners.length > 0 && parsed.banners[0].image_url) {
          heroUrl = parsed.banners[0].image_url;
        }
      }
    } catch (e) {}

    if (!heroUrl) {
      heroUrl = 'images/hero1.jpg';
    }

    updateProgress(45);

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
      updateProgress(90);
    } catch (err) {}

    // Ensure the animation has had at least 1.8s to play smoothly
    setTimeout(() => {
      dismissLoader();
    }, 1800);
  }

  // Safety timer
  setTimeout(() => {
    dismissLoader();
  }, MAX_SAFETY_TIMEOUT);

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', preloadCriticalHero);
  } else {
    preloadCriticalHero();
  }
})();
