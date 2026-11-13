Bear Blog is a publishing platform for personal blogs written in Markdown:
no trackers, no heavy styling, server-side rendering, very fast pages. It is
the engine behind bearblog.dev, packaged for self-hosting.

- Markdown-first editor with live preview
- Each registered user gets their own blog, on a subdomain
  (`myblog.example.org`) or a custom domain
- Landing page, signup flow and dashboard (posts, pages, tags, feeds)
- RSS/Atom/JSON feeds, sitemap, basic analytics with IP hashing and GeoIP
- One blog owner account is created at install from the chosen YunoHost admin;
  further users self-register through the app's signup form

Upstream is the source of the hosted SaaS and is not designed for
self-hosting: some SaaS-only parts (payments page, S3 media uploads) are inert
here, see the admin documentation.
