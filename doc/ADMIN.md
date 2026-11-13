The blog owner account (username = the YunoHost admin's email) is created at
install; its initial password is in `/home/yunohost.app/bearblog/admin_credentials.txt`
(readable as root) and upgrades never change it. Other users self-register at
`https://yourdomain.tld/signup/` and anyone who registers can create a blog, as
on the upstream SaaS.

### Blogs on subdomains

Bear Blog resolves blogs by hostname: `myblog.yourdomain.tld`. Those names need
DNS (a wildcard `*.yourdomain.tld` A/AAAA record is simplest) and a certificate
covering them. YunoHost issues wildcard certificates only for domains whose DNS
it recognises. Without one, browsers warn on blog subdomains; the main site is
unaffected.

The package adds an nginx server block for `*.yourdomain.tld`
(`/etc/nginx/conf.d/bearblog-blogs.conf`). Hosts that are real YunoHost domains
keep their own server blocks.

### SaaS-only parts, inert here

- The dashboard "upgrade/plan" pages point at upstream payment URLs and do
  nothing. Owner accounts are flagged as upgraded, so every blog feature works.
- The media center uploads to an S3-compatible bucket configured via
  `OBJECT_STORAGE_*` in `/var/www/bearblog/.env` (empty by default → rejected).
- Mail goes through the box's Postfix as `bearblog@yourdomain.tld`; that domain
  must be served by this server or the relay refuses it.

There is no config panel: secrets are app settings
(`yunohost app setting bearblog secret_key`), Django settings are in
`/var/www/bearblog/conf/settings.py`, the database is
`/home/yunohost.app/bearblog/dev.db`.
