// Service Worker — Quran Memorization System
// Caches audio files for offline playback

const CACHE_NAME = 'quran-audio-v1';
const AUDIO_CACHE = 'quran-audio-files-v1';
const APP_CACHE = 'quran-app-v1';

const APP_SHELL = [
  './',
  './index.html',
];

// On install — cache app shell
self.addEventListener('install', e => {
  e.waitUntil(
    caches.open(APP_CACHE).then(c => c.addAll(APP_SHELL))
  );
  self.skipWaiting();
});

self.addEventListener('activate', e => {
  e.waitUntil(
    caches.keys().then(keys =>
      Promise.all(keys.filter(k => k !== AUDIO_CACHE && k !== APP_CACHE).map(k => caches.delete(k)))
    )
  );
  self.clients.claim();
});

// Fetch — serve from cache, fallback to network and cache
self.addEventListener('fetch', e => {
  const url = new URL(e.request.url);

  // Audio files — cache first, then network
  if (url.hostname === 'cdn.islamic.network' || e.request.url.includes('.mp3')) {
    e.respondWith(
      caches.open(AUDIO_CACHE).then(async cache => {
        const cached = await cache.match(e.request);
        if (cached) return cached;
        try {
          const response = await fetch(e.request);
          if (response.ok) cache.put(e.request, response.clone());
          return response;
        } catch {
          return new Response('Audio not available offline', { status: 503 });
        }
      })
    );
    return;
  }

  // App shell — network first, fallback to cache
  e.respondWith(
    fetch(e.request).catch(() => caches.match(e.request))
  );
});

// Message from app — cache a specific surah
self.addEventListener('message', e => {
  if (e.data.type === 'CACHE_SURAH') {
    const { url } = e.data;
    caches.open(AUDIO_CACHE).then(async cache => {
      const cached = await cache.match(url);
      if (!cached) {
        try {
          const res = await fetch(url);
          if (res.ok) {
            cache.put(url, res);
            e.source.postMessage({ type: 'CACHED', url });
          }
        } catch {}
      } else {
        e.source.postMessage({ type: 'ALREADY_CACHED', url });
      }
    });
  }

  if (e.data.type === 'GET_CACHED_LIST') {
    caches.open(AUDIO_CACHE).then(async cache => {
      const keys = await cache.keys();
      const urls = keys.map(r => r.url);
      e.source.postMessage({ type: 'CACHED_LIST', urls });
    });
  }

  if (e.data.type === 'CLEAR_CACHE') {
    caches.delete(AUDIO_CACHE).then(() => {
      e.source.postMessage({ type: 'CACHE_CLEARED' });
    });
  }
});
