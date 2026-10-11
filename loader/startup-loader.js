/**
 * ==============================================================================
 * IQBAL FASHION — ADAPTIVE STARTUP LOADER & ASSET PRELOADER
 * Tailored Thread Stitching Micro-Animation with Dynamic Asset Preloading:
 * - Waits for live Supabase data (banners, categories, products)
 * - Decodes first hero banner image
 * - Preloads top product images
 * - Ensures homepage video has buffered and is ready to play (readyState >= 2)
 * - ZERO flash of dummy poster images
 * - Seamlessly loops thread stitching animation if network is slow
 * - Split-curtain luxury reveal once all assets are prepared
 * ==============================================================================
 */

(function() {
  'use strict';

  const LOADER_ID = 'iqbalStartupLoader';
  const MIN_ANIMATION_TIME = 1350; // Ensure at least 1 full stitch cycle is appreciated
  const MAX_SAFETY_TIMEOUT = 6500; // Hard fallback so user is never permanently blocked

  const loaderEl = document.getElementById(LOADER_ID);
  if (!loaderEl) return;

  const stageEl = loaderEl.querySelector('.loader-stage');
  const btnWrap = document.getElementById('loaderButtonWrap');
  const progressBar = loaderEl.querySelector('.loader-progress-bar-fill');

  let isDismissed = false;
  const startTime = Date.now();

  function updateProgress(percent) {
    if (progressBar) {
      progressBar.style.width = Math.min(100, Math.max(0, percent)) + '%';
    }
  }

  // Preload single image helper with modern HTMLImageElement.decode()
  function preloadImage(url) {
    if (!url) return Promise.resolve();
    return new Promise((resolve) => {
      const img = new Image();
      img.src = url;
      if ('decode' in img) {
        img.decode().then(resolve).catch(resolve);
      } else {
        img.onload = resolve;
        img.onerror = resolve;
      }
    });
  }

  // Video Ready Helper: waits until video has enough data to start playback (readyState >= 2)
  function waitForVideoReady(videoEl, timeoutMs = 4500) {
    return new Promise((resolve) => {
      if (!videoEl) return resolve();

      // If already buffered enough data
      if (videoEl.readyState >= 2) {
        return resolve();
      }

      let done = false;
      const finish = () => {
        if (!done) {
          done = true;
          cleanup();
          resolve();
        }
      };

      const cleanup = () => {
        videoEl.removeEventListener('loadeddata', finish);
        videoEl.removeEventListener('canplay', finish);
        videoEl.removeEventListener('canplaythrough', finish);
        videoEl.removeEventListener('playing', finish);
        videoEl.removeEventListener('error', finish);
      };

      videoEl.addEventListener('loadeddata', finish, { once: true });
      videoEl.addEventListener('canplay', finish, { once: true });
      videoEl.addEventListener('canplaythrough', finish, { once: true });
      videoEl.addEventListener('playing', finish, { once: true });
      videoEl.addEventListener('error', finish, { once: true });

      // Start preloading if paused
      try {
        const p = videoEl.play();
        if (p !== undefined) p.catch(() => {});
      } catch (e) {}

      // Fallback timeout so slow CDN never freezes the loader
      setTimeout(finish, timeoutMs);
    });
  }

  // Split Curtain Reveal
  function dismissLoader() {
    if (isDismissed) return;
    isDismissed = true;

    // Transition from looping animation to finished settled state
    if (stageEl) {
      stageEl.classList.remove('is-looping');
      stageEl.classList.add('is-finished');
    }
    if (btnWrap) {
      btnWrap.classList.add('finished');
    }
    updateProgress(100);

    // After button settle spin completes (~450ms), split the curtain
    setTimeout(() => {
      loaderEl.classList.add('split');

      // Ensure video is playing smoothly
      const vid = document.getElementById('homeBgVideo');
      if (vid && vid.paused) {
        vid.play().catch(() => {});
      }

      try {
        window.dispatchEvent(new CustomEvent('iqbalLoaderComplete'));
      } catch (e) {}

      // Cleanly remove from DOM after curtain splits
      setTimeout(() => {
        if (loaderEl && loaderEl.parentNode) {
          loaderEl.parentNode.removeChild(loaderEl);
        }
      }, 950);
    }, 450);
  }

  // Master Asset Preloader Orchestration
  async function prepareHomepageAssets() {
    updateProgress(20);

    // 1. Kick off data loading (banners + video fetched first in the new loadHomePageData)
    let dataPromise = null;
    if (typeof window.loadHomePageData === 'function') {
      try {
        dataPromise = window.loadHomePageData();
      } catch(e) {}
    }

    updateProgress(35);

    // 2. Wait for live Supabase data to arrive and render (banners + video)
    //    Use a generous timeout so slow networks still get live content
    if (dataPromise && typeof dataPromise.then === 'function') {
      try {
        await Promise.race([
          dataPromise,
          new Promise(r => setTimeout(r, 5500)) // up to 5.5s for live data
        ]);
      } catch(e) {}
    }

    updateProgress(60);

    // 3. Get hero image URL from the NOW-RENDERED DOM (live Supabase images, respecting mobile srcset)
    let heroUrl = null;
    try {
      const firstSlide = document.querySelector('#heroSlider .snitch-slide');
      if (firstSlide) {
        const sourceEl = firstSlide.querySelector('source');
        const imgEl = firstSlide.querySelector('.snitch-slide-img');
        if (window.innerWidth <= 768 && sourceEl && sourceEl.srcset) {
          heroUrl = sourceEl.srcset;
        } else if (imgEl && imgEl.src && !imgEl.src.endsWith('/')) {
          heroUrl = imgEl.src;
        }
      }
    } catch(e) {}

    // 4. Preload first banner image, video poster, and buffer video in parallel
    const vidEl = document.getElementById('homeBgVideo');
    const posterUrl = vidEl ? (vidEl.getAttribute('poster') || vidEl.poster) : null;

    const imagePreload = heroUrl ? preloadImage(heroUrl) : Promise.resolve();
    const posterPreload = posterUrl ? preloadImage(posterUrl) : Promise.resolve();
    // Video timeout: 2.5s — if slow cellular, proceed with high-res poster ready
    const videoPreload = waitForVideoReady(vidEl, 2500);

    await Promise.all([
      imagePreload.then(() => updateProgress(80)),
      posterPreload.then(() => updateProgress(90)),
      videoPreload.then(() => updateProgress(95))
    ]);

    // 5. Ensure minimum animation time has elapsed for visual delight
    const elapsed = Date.now() - startTime;
    const remainingTime = Math.max(0, MIN_ANIMATION_TIME - elapsed);

    setTimeout(() => {
      dismissLoader();
    }, remainingTime);
  }

  // Safety maximum fallback timer
  const safetyTimer = setTimeout(() => {
    dismissLoader();
  }, MAX_SAFETY_TIMEOUT);

  // Initialize
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => {
      prepareHomepageAssets().finally(() => clearTimeout(safetyTimer));
    });
  } else {
    prepareHomepageAssets().finally(() => clearTimeout(safetyTimer));
  }
})();
