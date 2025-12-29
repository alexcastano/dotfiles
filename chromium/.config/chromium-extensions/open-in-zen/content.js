// Open in Zen - Redirects external links to Zen Browser via protocol handler

(function() {
  'use strict';

  // Get the webapp's hostname (current page)
  const webappHost = window.location.hostname;

  // Handle click events on links
  document.addEventListener('click', function(event) {
    // Find the closest anchor element (handles clicks on elements inside <a>)
    const link = event.target.closest('a');
    if (!link) return;

    const href = link.href;
    if (!href) return;

    // Parse the URL
    let url;
    try {
      url = new URL(href);
    } catch (e) {
      return; // Invalid URL, let browser handle it
    }

    // Skip non-http(s) protocols (mailto:, tel:, javascript:, etc.)
    if (!url.protocol.startsWith('http')) return;

    // Skip internal links (same hostname)
    if (url.hostname === webappHost) return;

    // Skip if user is holding modifier keys (let them override)
    if (event.ctrlKey || event.metaKey || event.shiftKey) return;

    // External link! Redirect to zen-open:// protocol
    event.preventDefault();
    event.stopPropagation();

    // Open via protocol handler
    window.location.href = 'zen-open://' + encodeURIComponent(href);
  }, true); // Use capture phase to intercept before other handlers

  // Also handle middle-click (auxclick)
  document.addEventListener('auxclick', function(event) {
    if (event.button !== 1) return; // Only middle-click

    const link = event.target.closest('a');
    if (!link) return;

    const href = link.href;
    if (!href) return;

    let url;
    try {
      url = new URL(href);
    } catch (e) {
      return;
    }

    if (!url.protocol.startsWith('http')) return;
    if (url.hostname === webappHost) return;

    event.preventDefault();
    event.stopPropagation();
    window.location.href = 'zen-open://' + encodeURIComponent(href);
  }, true);
})();
