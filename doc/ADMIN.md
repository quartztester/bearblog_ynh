Blog owner account created at install. Username = YunoHost admin email.
Initial password: `/home/yunohost.app/bearblog/admin_credentials.txt` (root-readable).
Upgrades never change it. Other users self-register at
`https://yourdomain.tld/signup/`. Anyone who registers gets a blog — same as
upstream SaaS.

### Blogs on subdomains

Bear Blog resolves blogs by hostname: `myblog.yourdomain.tld`. Those names need
DNS (wildcard `*.yourdomain.tld` A/AAAA record simplest) plus a TLS certificate
covering them. YunoHost issues wildcard certs only for domains with recognised
DNS (`yunohost domain add --install-letsencrypt-cert` on a wildcard-resolving
domain). No wildcard cert → TLS warning on blog subdomains. Main site fine.

Package installs extra nginx server block for `*.yourdomain.tld`
(`/etc/nginx/conf.d/bearblog-blogs.conf`). Hosts that are real YunoHost domains
keep their own server blocks. Unaffected.

### SaaS-only parts, inert here

- Dashboard "upgrade/plan" pages point at upstream payment URLs. Dead on
  self-host. Blog owner accounts flagged upgraded — all blog features stay on.
- Media center uploads to an S3-compatible bucket, configured via
  `OBJECT_STORAGE_*` in `/var/www/bearblog/.env`. Empty by default → uploads
  rejected with a clear message.
- Email list/password-reset mails go through the box's Postfix,
  `From: bearblog@yourdomain.tld`. That address's domain must be served by this
  server or mail is refused.

No config panel. App secrets: app settings
(`yunohost app setting bearblog secret_key`). Django settings:
`/var/www/bearblog/conf/settings.py`. Database: SQLite file
`/home/yunohost.app/bearblog/dev.db`.
