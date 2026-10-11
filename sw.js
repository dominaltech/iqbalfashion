// IQBAL FASHION STOREFRONT SERVICE WORKER
// REAL-TIME DIRECT NETWORK FOR SUPABASE & LIVE CODE UPDATES WITHOUT MANUAL CACHE BUSTING
const STATIC_CACHE_NAME = 'iqbalfashion-live-v4';

self.addEventListener('install', (event) => {
  self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((cacheNames) => {
      return Promise.all(
        cacheNames.map((cache) => {
          console.log('Clearing old storefront cache:', cache);
          return caches.delete(cache);
        })
      );
    }).then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', (event) => {
  if (event.request.method !== 'GET') return;
  const url = new URL(event.request.url);

  // 1. ALL SUPABASE REQUESTS (REST, STORAGE IMAGES, VIDEOS) - ALWAYS LIVE NETWORK
  if (url.hostname.includes('supabase.co')) {
    event.respondWith(fetch(event.request));
    return;
  }

  // 2. LIVE HTML, CSS, JS CODE & REPO ASSETS - NETWORK-FIRST WITH NO-CACHE
  // Ensures any new commits pushed to GitHub are immediately served to visitors
  event.respondWith(
    fetch(event.request, { cache: 'no-cache' })
      .then((networkResponse) => {
        if (networkResponse && networkResponse.status === 200 && event.request.url.startsWith('http')) {
          const responseClone = networkResponse.clone();
          caches.open(STATIC_CACHE_NAME).then((cache) => {
            cache.put(event.request, responseClone);
          }).catch(() => {});
        }
        return networkResponse;
      })
      .catch(() => caches.match(event.request))
  );
});
