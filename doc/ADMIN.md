Blog owner account = YunoHost admin's email. Made at install. Initial password:
`/home/yunohost.app/bearblog/admin_credentials.txt` (root-only). Upgrades never
rotate it. Other users self-register at `https://yourdomain.tld/signup/` — every
signup can make a blog, same as upstream SaaS.

### Blogs on subdomains

Bear Blog picks blog by hostname: `myblog.yourdomain.tld`. Subdomains must
resolve (wildcard `*.yourdomain.tld` A/AAAA simplest) and have a cert covering
them. YunoHost issues wildcard certs only for DNS-recognised domains
(`yunohost domain add --install-letsencrypt-cert` on a wildcard-resolving
domain). No wildcard cert = browser TLS warning on blog subdomains. Main site
unaffected.

Package drops an extra nginx server block for `*.yourdomain.tld` at
`/etc/nginx/conf.d/bearblog-blogs.conf`. Real YunoHost domains keep their own
blocks, untouched.

### SaaS parts, dead here

- Dashboard "upgrade/plan" pages hit upstream payment URLs. Useless
  self-hosted. Owner accounts flagged upgraded, all blog features open.
- Media center wants an S3 bucket via `OBJECT_STORAGE_*` in
  `/var/www/bearblog/.env`. Empty = upload rejected with clear message.
- Mail (lists, password reset) goes through box Postfix,
  `From: bearblog@yourdomain.tld`. That domain must be served here or mail dies.

No config panel. Secrets in app settings
(`yunohost app setting bearblog secret_key`). Django settings:
`/var/www/bearblog/conf/settings.py`. DB: SQLite
`/home/yunohost.app/bearblog/dev.db`.
