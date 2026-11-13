Bear Blog: publishing platform for personal Markdown blogs. No trackers, no
heavy styling, server-side rendering, fast pages. Engine behind bearblog.dev,
packaged for self-hosting.

### Features

- Markdown-first editor, live preview
- Each registered user gets their own blog, on a subdomain
  (`myblog.example.org`) or a custom domain
- Landing page, signup flow, dashboard (posts, pages, tags, feeds)
- RSS/Atom/JSON feeds, sitemap, basic analytics, IP hashing, GeoIP country
  resolution
- One blog owner account created at install from the chosen YunoHost admin.
  Further users self-register through the app's signup form

Upstream powers the hosted SaaS. Not designed for self-hosting. Some
SaaS-only parts (payments page, S3 media uploads) are inert here — see the
admin documentation.
