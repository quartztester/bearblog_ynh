Le compte propriétaire du blog (identifiant = l'email de l'administrateur
YunoHost) est créé à l'installation ; son mot de passe initial se trouve dans
`__DATA_DIR__/admin_credentials.txt` (lisible en root) et n'est pas modifié
par les mises à jour. Les autres utilisateurs s'inscrivent sur
`https://__DOMAIN__/signup/` ; toute inscription peut créer un blog
(comportement identique au SaaS amont).

### Blogs sur sous-domaines

Bear Blog résout les blogs par nom d'hôte : `monblog.__DOMAIN__`. Ces noms
doient résoudre (un enregistrement wildcard `*.__DOMAIN__` est le plus
simple) et disposer d'un certificat TLS les couvrant. YunoHost ne délivre de
certificat wildcard que pour les domaines dont le DNS est reconnu (`yunohost
domain add --install-letsencrypt-cert` sur un domaine à résolution wildcard).
Sans certificat wildcard, le navigateur affiche un avertissement TLS sur les
sous-domaines de blog ; le site principal n'est pas affecté.

Le paquet installe un bloc serveur nginx supplémentaire pour `*.__DOMAIN__`
(`/etc/nginx/conf.d/__APP__-blogs.conf`) ; les hôtes qui sont de vrais
domaines YunoHost gardent leurs blocs existants.

### Parties SaaS inactives

- Les pages « upgrade/plan » du tableau de bord pointent vers les URLs de
  paiement amont et sont inutiles en auto-hébergement. Les comptes
  propriétaires sont marqués « upgraded » pour garder toutes les
  fonctionnalités accessibles.
- Le centre média téléverse vers un compatible S3 configuré via
  `OBJECT_STORAGE_*` dans `__INSTALL_DIR__/.env` (vide par défaut → les
  téléversements sont refusés proprement).
- Les emails (listes, réinitialisation) partent via le Postfix de la machine
  avec `From : __APP__@__DOMAIN__` ; ce domaine doit être servi par ce
  serveur sinon le relais refusera le message.

Pas de panneau de configuration : les secrets sont dans les réglages de
l'app (`yunohost app setting __APP__ secret_key`), les réglages Django dans
`__INSTALL_DIR__/conf/settings.py`, et la base est le fichier SQLite
`__DATA_DIR__/dev.db`.
