Compte propriétaire du blog créé à l'installation. Identifiant = email admin
YunoHost. Mot de passe initial :
`/home/yunohost.app/bearblog/admin_credentials.txt` (lisible root).
Mises à jour ne le changent pas. Autres utilisateurs s'inscrivent sur
`https://votredomaine.tld/signup/`. Toute inscription crée un blog — comme le
SaaS amont.

### Blogs sur sous-domaines

Bear Blog résout les blogs par nom d'hôte : `monblog.votredomaine.tld`. DNS
requis (wildcard `*.votredomaine.tld` A/AAAA, plus simple) + certificat TLS
couvrant ces noms. YunoHost délivre un certificat wildcard seulement pour les
domaines au DNS reconnu (`yunohost domain add --install-letsencrypt-cert` sur
domaine à résolution wildcard). Pas de certificat wildcard → avertissement TLS
sur les sous-domaines de blog. Site principal épargné.

Le paquet installe un bloc serveur nginx supplémentaire pour
`*.votredomaine.tld` (`/etc/nginx/conf.d/bearblog-blogs.conf`). Les hôtes qui
sont de vrais domaines YunoHost gardent leurs blocs. Non affectés.

### Parties SaaS inactives

- Pages « upgrade/plan » du tableau de bord → URLs de paiement amont. Mort en
  auto-hébergement. Comptes propriétaires marqués « upgraded » — toutes les
  fonctionnalités blog restent actives.
- Centre média : téléversement vers compatible S3, via `OBJECT_STORAGE_*` dans
  `/var/www/bearblog/.env`. Vide par défaut → téléversements refusés, message
  clair.
- Emails (listes, réinitialisation) via Postfix de la machine,
  `From : bearblog@votredomaine.tld`. Le domaine de l'adresse doit être servi
  par ce serveur, sinon relais refuse.

Pas de panneau de configuration. Secrets : réglages de l'app
(`yunohost app setting bearblog secret_key`). Réglages Django :
`/var/www/bearblog/conf/settings.py`. Base : fichier SQLite
`/home/yunohost.app/bearblog/dev.db`.
