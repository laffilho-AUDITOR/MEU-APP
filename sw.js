const CACHE = 'semef-manaus-v3';
const CORE = ['./', './index.html', './manifest.json', './icon-192.png', './icon-512.png'];

self.addEventListener('install', e => {
  self.skipWaiting();
  e.waitUntil(caches.open(CACHE).then(c => Promise.allSettled(CORE.map(u => c.add(u)))));
});

self.addEventListener('activate', e => e.waitUntil((async () => {
  const ks = await caches.keys();
  await Promise.all(ks.filter(k => k !== CACHE).map(k => caches.delete(k)));
  await self.clients.claim();
})()));

self.addEventListener('fetch', e => {
  const req = e.request;
  if (req.method !== 'GET') return;
  const url = new URL(req.url);
  if (url.origin !== location.origin) return;            // Supabase e CDN passam direto

  const ehPagina = req.mode === 'navigate' || /\.(html|json)$/.test(url.pathname);

  if (ehPagina) {
    // rede primeiro, e ignora qualquer cache HTTP do navegador/CDN no caminho:
    // nunca mais serve HTML velho, nem do Service Worker nem do cache do navegador
    e.respondWith(
      fetch(req, { cache: 'no-store' }).then(r => {
        const copia = r.clone();
        caches.open(CACHE).then(c => c.put(req, copia));
        return r;
      }).catch(() => caches.match(req).then(m => m || caches.match('./index.html')))
    );
  } else {
    // imagens e afins: cache primeiro
    e.respondWith(
      caches.match(req).then(m => m || fetch(req).then(r => {
        const copia = r.clone();
        caches.open(CACHE).then(c => c.put(req, copia));
        return r;
      }))
    );
  }
});
