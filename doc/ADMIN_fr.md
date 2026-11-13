Compte blog = email de l'admin YunoHost. Créé à l'installation. Mot de passe
initial : `/home/yunohost.app/bearblog/admin_credentials.txt` (root seul). Les
mises à jour ne le changent jamais. Autres utilisateurs : inscription libre sur
`https://votredomaine.tld/signup/` — chaque inscrit peut créer un blog, comme le
SaaS amont.

### Blogs sur sous-domaines

Bear Blog choisit le blog par nom d'hôte : `monblog.votredomaine.tld`. Les
sous-domaines doivent résoudre (wildcard `*.votredomaine.tld` A/AAAA, le plus
simple) et avoir un certificat couvrant. YunoHost délivre un certificat wildcard
seulement pour les domaines DNS reconnus (`yunohost domain add
--install-letsencrypt-cert` sur domaine à résolution wildcard). Sans wildcard =
avertissement TLS sur les sous-domaines. Site principal épargné.

Le paquet pose un bloc serveur nginx `*.votredomaine.tld` dans
`/etc/nginx/conf.d/bearblog-blogs.conf`. Les vrais domaines YunoHost gardent
leurs blocs, intacts.

### Parties SaaS, mortes ici

- Pages « upgrade/plan » du tableau de bord : URLs de paiement amont. Inutiles
  en auto-hébergement. Comptes propriétaires marqués « upgraded », toutes
  fonctions ouvertes.
- Le centre média veut un bucket S3 via `OBJECT_STORAGE_*` dans
  `/var/www/bearblog/.env`. Vide = téléversement refusé, message clair.
- Les emails (listes, réinitialisation) partent via Postfix local,
  `From : bearblog@votredomaine.tld`. Ce domaine doit être servi ici sinon refus.

Pas de panneau de configuration. Secrets dans les réglages de l'app
(`yunohost app setting bearblog secret_key`). Réglages Django :
`/var/www/bearblog/conf/settings.py`. Base : SQLite
`/home/yunohost.app/bearblog/dev.db`.
