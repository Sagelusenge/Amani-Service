# GitHub, Render et Aiven

Le fichier `render.yaml` définit deux services : `amani-services-web` (React statique)
et `amani-services-api` (Node.js). MySQL reste sur Aiven.

## Base de données

Configurer `MYSQL_HOST`, `MYSQL_PORT`, `MYSQL_USER`, `MYSQL_PASSWORD`,
`MYSQL_DATABASE` et `MYSQL_SSL_CA` (certificat PEM complet) côté backend uniquement.
En local, `MYSQL_SSL_CA_PATH` peut désigner le fichier PEM. La vérification TLS est obligatoire en production.

Pour une nouvelle base vide, depuis la racine avec ces variables configurées :

```sh
node backend/src/init-database.js
```

Ce script refuse les bases non vides. Il importe tables, données de référence,
triggers, procédures et vues dans la base configurée, sans créer une autre base.
L'import DDL MySQL n'est pas transactionnel : en cas d'erreur, inspecter les objets
déjà créés avant toute reprise. Ne pas lancer automatiquement à chaque démarrage.

## Déploiement

1. Publier les sources et `render.yaml` sur `Sagelusenge/Amani-Service`, branche `main`.
2. Créer un Blueprint Render depuis ce dépôt, dans le bon espace de travail.
3. Renseigner les variables `sync: false`. Ne jamais publier les secrets sur GitHub.
4. Définir `FRONTEND_ORIGIN` avec l'URL HTTPS réelle du frontend, sans slash final.
5. Définir `VITE_API_URL` avec l'URL HTTPS réelle du backend suivie de `/api`.
   Reconstruire le frontend après chaque changement de cette variable.
6. Vérifier `/api/health`, les services publics, puis la connexion administrateur.

Le backend utilise le plan `free`, sans disque persistant. Le frontend est un site
statique gratuit, dans les quotas Render. Le backend se met en veille après 15 minutes
sans trafic et le réveil peut prendre environ une minute.

Les nouveaux fichiers téléversés (8 Mo maximum) sont conservés dans la table
`stored_uploads` de MySQL. Ils survivent aux redémarrages et aux déploiements Render.
La table est créée automatiquement sans modifier les tables métier existantes.
Les anciennes URL sont conservées ; les anciens fichiers déjà perdus doivent être
restaurés depuis une copie originale. Inclure `stored_uploads` dans les sauvegardes
Aiven et surveiller la capacité de la base. Pour de gros volumes, préférer un stockage objet.

Les données MySQL restent sur Aiven. Vérifier séparément le plan Aiven : un essai
gratuit de 30 jours ne constitue pas une offre gratuite permanente.

Les données locales et le contenu de `backend/uploads` ne sont pas publiés dans Git.
Une migration des données locales nécessite un export/import distinct et la copie
des fichiers associés. Le schéma seul ne crée pas de compte administrateur.
Créer le compte via `npm run admin` depuis `backend` avec les variables Aiven,
en suivant `src/create-admin.js` ; ne pas mettre son mot de passe dans le dépôt.

## Contrôles locaux

```sh
npm --prefix backend run check
npm --prefix frontend run build
```

Le fichier `.deploy/` contient uniquement des éléments locaux de déploiement,
potentiellement secrets, et reste exclu du versionnement.

## Chargement public et domaine

La compilation du frontend récupère les données publiques via `VITE_API_URL` et
copie les images publiées dans le site statique. Les compteurs, services, paramètres
et actualités s'affichent depuis cet instantané, puis sont rafraîchis en arrière-plan.
Les changements administratifs sont donc visibles dès que l'API répond. Un nouveau
build du frontend renouvelle l'instantané pour les premières visites pendant une
mise en veille. Les dernières réponses publiques sont aussi conservées 24 heures
au maximum dans le navigateur ; un build plus récent prend la priorité.
Une erreur des endpoints publics fait échouer le build plutôt que publier des
chiffres inventés. Une image ancienne absente est signalée dans le journal du build.
L'administration et ses graphiques sont chargés séparément du site public.

Le plan gratuit conserve son délai de réveil pour les opérations interactives
(connexion, formulaire, nouveaux contenus). L'élimination de cette veille nécessite
un plan de service toujours actif ; ne pas changer le plan sans accord sur son coût.

Domaine prévu : `https://amani-services.eu` (origine autorisée par l'API, ainsi que
`https://www.amani-services.eu`). L'association Render et la zone DNS OVH doivent
être configurées indépendamment du code :

- Render / amani-services-web / Settings / Custom Domains : ajouter `amani-services.eu`.
- OVH / Zone DNS : A de la racine vers `216.24.57.1`.
- OVH / Zone DNS : CNAME de `www` vers `amani-services-web.onrender.com.`.
- Retirer les AAAA de ces deux noms s'ils existent, sans modifier les entrées mail.
- Dans Render, vérifier le domaine puis contrôler le certificat HTTPS et les deux noms.

Valeurs vérifiées dans https://render.com/docs/configure-other-dns le 22 novembre 2026.
