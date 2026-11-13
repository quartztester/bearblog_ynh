Le compte propriétaire du blog (identifiant = l'email de l'administrateur
YunoHost) est créé à l'installation ; son mot de passe initial est dans
`/home/yunohost.app/bearblog/admin_credentials.txt` (lisible en root) et n'est pas modifié par
les mises à jour. Les autres utilisateurs s'inscrivent sur
`https://votredomaine.tld/signup/` ; toute inscription peut créer un blog,
comme sur le SaaS amont.

### Blogs sur sous-domaines

Bear Blog résout les blogs par nom d'hôte : `monblog.votredomaine.tld`. Ces noms
doivent résoudre (un enregistrement wildcard `*.votredomaine.tld` est le plus
simple) et avoir un certificat TLS couvrant. YunoHost ne délivre de certificat
wildcard que pour les domaines dont il reconnaît le DNS. Sans lui, le
navigateur avertit sur les sous-domaines de blog ; le site principal n'est pas
affecté.

Le paquet ajoute un bloc serveur nginx pour `*.votredomaine.tld`
(`/etc/nginx/conf.d/bearblog-blogs.conf`) ; les hôtes qui sont de vrais
domaines YunoHost gardent leurs blocs existants.

### Parties SaaS inactives

- Les pages « upgrade/plan » pointent vers les URLs de paiement amont et sont
  inutiles. Les comptes propriétaires sont marqués « upgraded », donc toutes
  les fonctionnalités restent accessibles.
- Le centre média téléverse vers un compatible S3 configuré via
  `OBJECT_STORAGE_*` dans `/var/www/bearblog/.env` (vide par défaut → refus).
- Les emails partent via le Postfix de la machine avec
  `From : bearblog@votredomaine.tld` ; ce domaine doit être servi par ce
  serveur sinon le relais refuse le message.

Pas de panneau de configuration : secrets dans les réglages de l'app
(`yunohost app setting bearblog secret_key`), réglages Django dans
`/var/www/bearblog/conf/settings.py`, base SQLite dans
`/home/yunohost.app/bearblog/dev.db`.
