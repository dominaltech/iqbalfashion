const CACHE_NAME = 'iqbal-fashion-cache-v1';
const ASSETS_TO_CACHE = [
  './index.html',
  './mens.html',
  './kids.html',
  './cloth-piece.html',
  './profile.html',
  './admin.html',
  './manifest.json',
  './sw.js'
];

// Install Event - Pre-cache critical pages
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      console.log('[Service Worker] Pre-caching offline pages');
      return cache.addAll(ASSETS_TO_CACHE);
    }).then(() => self.skipWaiting())
  );
});

// Activate Event - Clean up old caches
self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((cacheNames) => {
      return Promise.all(
        cacheNames.map((cache) => {
          if (cache !== CACHE_NAME) {
            console.log('[Service Worker] Clearing old cache', cache);
            return caches.delete(cache);
          }
        })
      );
    }).then(() => self.clients.claim())
  );
});

// Fetch Event - Serve cached assets when offline, cache-first for images
self.addEventListener('fetch', (event) => {
  const requestUrl = new URL(event.request.url);

  // For external assets like Supabase scripts or Google fonts, use network-first
  if (event.request.url.includes('supabase') || event.request.url.includes('googleapis') || event.request.url.includes('gstatic')) {
    event.respondWith(
      fetch(event.request)
        .catch(() => caches.match(event.request))
    );
    return;
  }

  // Cache-first for images, otherwise network-first with offline fallback
  if (event.request.destination === 'image') {
    event.respondWith(
      caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((cachedResponse) => {
          if (cachedResponse) return cachedResponse;

          return fetch(event.request).then((networkResponse) => {
            cache.put(event.request, networkResponse.clone());
            return networkResponse;
          }).catch(() => {
            // Return a offline placeholder or simple SVG if offline and not in cache
            return new Response(
              '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" width="100" height="100"><rect width="100" height="100" fill="#F0EDE6"/><text x="50" y="50" font-family="sans-serif" font-size="8" fill="#5E6E63" text-anchor="middle">Offline Image</text></svg>',
              { headers: { 'Content-Type': 'image/svg+xml' } }
            );
          });
        });
      })
    );
  } else {
    // Network first, fallback to cache
    event.respondWith(
      fetch(event.request)
        .then((response) => {
          // If response is valid, cache it
          if (response && response.status === 200 && response.type === 'basic') {
            const responseClone = response.clone();
            caches.open(CACHE_NAME).then((cache) => {
              cache.put(event.request, responseClone);
            });
          }
          return response;
        })
        .catch(() => {
          return caches.match(event.request).then((cachedResponse) => {
            if (cachedResponse) return cachedResponse;
            // Fallback for HTML pages
            if (event.request.mode === 'navigate') {
              return caches.match('./index.html');
            }
          });
        })
    );
  }
});
