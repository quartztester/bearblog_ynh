Bear Blog est une plateforme de publication de blogs personnels écrits en
Markdown : sans traqueurs, sans style lourd, rendu côté serveur, pages très
rapides. C'est le moteur de bearblog.dev, empaqueté pour l'auto-hébergement.

- Éditeur Markdown avec aperçu en direct
- Chaque utilisateur inscrit obtient son propre blog, sur un sous-domaine
  (`monblog.exemple.org`) ou un domaine personnalisé
- Page d'accueil, inscription et tableau de bord (articles, pages, tags, flux)
- Flux RSS/Atom/JSON, sitemap, statistiques de base avec hachage d'IP et
  géolocalisation par pays
- Un compte propriétaire est créé à l'installation depuis l'administrateur
  YunoHost choisi ; les autres s'inscrivent via le formulaire

Le projet amont est le code du SaaS hébergé et n'est pas conçu pour
l'auto-hébergement : certaines fonctions SaaS (paiements, téléversements média
vers S3) sont inactives ici, voir la documentation administrateur.
