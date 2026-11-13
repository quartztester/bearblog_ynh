The blog owner account (username = the YunoHost admin's email) is created at
install; its initial password is in `__DATA_DIR__/admin_credentials.txt`
(readable as root) and is not changed by upgrades. Other users register
themselves at `https://__DOMAIN__/signup/`; anyone who registers can create
a blog (this mirrors the upstream SaaS behaviour).

### Blogs on subdomains

Bear Blog resolves blogs by hostname: `myblog.__DOMAIN__`. For those names to
answer, they need DNS records (a wildcard `*.__DOMAIN__` A/AAAA record is the
simplest) and a TLS certificate covering them. YunoHost issues wildcard
certificates only for domains whose DNS is recognised (`yunohost domain add
--install-letsencrypt-cert` on a wildcard-resolving domain). Without a
wildcard cert browsers show a TLS warning on blog subdomains; the main site
is unaffected.

The package installs an extra nginx server block for `*.__DOMAIN__`
(`/etc/nginx/conf.d/__APP__-blogs.conf`); hosts that are real YunoHost
domains keep their own server blocks and are unaffected.

### SaaS-only parts, inert here

- The dashboard "upgrade/plan" pages point at the upstream payment URLs and
  do nothing useful on a self-hosted instance. Blog owner accounts are
  flagged as upgraded so all blog features stay available.
- The media center uploads to an S3-compatible bucket configured via
  `OBJECT_STORAGE_*` in `__INSTALL_DIR__/.env` (empty by default → uploads
  are rejected with a clear message).
- The email list/password-reset mails are sent through the box's Postfix
  with `From: __APP__@__DOMAIN__`; make sure that address's domain is served
  by this server or mail will be refused.

There is no config panel: app secrets are in the app settings
(`yunohost app setting __APP__ secret_key`), the Django settings file is
`__INSTALL_DIR__/conf/settings.py`, and its database is the SQLite file
`__DATA_DIR__/dev.db`.
