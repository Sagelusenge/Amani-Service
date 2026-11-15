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

Attention : les fichiers téléversés dans `uploads` sont temporaires et disparaissent
lors des redémarrages, mises en veille ou redéploiements. Pour les conserver, il faut
ajouter un stockage externe durable avant d’utiliser les téléversements en production.
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
