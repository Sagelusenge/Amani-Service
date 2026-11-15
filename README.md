# AMANI SERVICES — Plateforme full-stack

**Stack :** React 18 + Vite + Tailwind CSS + Framer Motion ; Express.js + Node.js ; MySQL 8.0+ (InnoDB, procédures, vues et triggers).

Ce ZIP comprend un **projet exécutable en développement** (pas un programme Windows `.exe`). Les fichiers sources Stitch (`code.html`, captures et `DESIGN.md`) sont conservés dans `reference-stitch/`. Le frontend est une adaptation React inspirée de ces maquettes, avec les couleurs du système *Executive Precision*.

## Prérequis

- Node.js 20.19+ ou 22+
- MySQL Server 8.0+
- npm

## Démarrage pas à pas

1. Dans MySQL, importer `database/01_schema.sql` en tant qu'administrateur :

   ```bash
   mysql -u root -p < database/01_schema.sql
   ```

   Sous Windows (PowerShell), on peut aussi utiliser MySQL Workbench : **File > Open SQL Script**, exécuter toute la requête.

2. Créer l'utilisateur SQL dans MySQL Workbench avec `database/02_create_app_user.sql` **après avoir remplacé `CHANGE_ME`**. Modifier l'identifiant MySQL si nécessaire. Le fichier utilise `amani_app@localhost`.

3. Backend :

   ```bash
   cd backend
   cp .env.example .env
   npm install
   ```

   Renseigner les identifiants SQL et une **clé JWT aléatoire de 64 caractères ou plus** dans `.env`.
   Générer un secret avec `node -e "console.log(require('crypto').randomBytes(48).toString('hex'))"`.

4. Créer un compte admin (aucun compte/mot de passe par défaut) :

   ```bash
   npm run admin -- admin@exemple.com "MotDePasseFort_12345!" "Administrateur Amani"
   npm run dev
   ```

   L'API écoute sur `http://localhost:4000` ; vérifier `http://localhost:4000/api/health`.

5. Dans un **deuxième terminal** :

   ```bash
   cd frontend
   npm install
   npm run dev
   ```

   Ouvrir `http://localhost:5173`. Espace admin : `http://localhost:5173/connexion`.

6. Pour construire le frontend : `npm run build` dans `frontend`. Pour lancer l'API sans rechargement : `npm start` dans `backend`.

## Structure

- `frontend/` : site public, connexion, dashboard et interfaces CRUD responsive.
- `backend/src/routes.js` : endpoints REST, authentification JWT et contrôles d'accès.
- `database/01_schema.sql` : 33 tables, 11 vues, 4 procédures, 27 triggers ; clés étrangères.
- `database/02_create_app_user.sql` : exemple de compte MySQL à privilèges restreints.
- `reference-stitch/` : exports d'origine : accueil, connexion, dashboard, et DESIGN.md.
- `docs/` : notes de fonctionnement et limites de livraison.

## Codes métiers automatiques

- PK technique : `id BIGINT AUTO_INCREMENT` (généré par MySQL).
- Référence métier : trigger `BEFORE INSERT` (`DOC-001-2026`, `DEV-002-2026`, etc.).
- `code_sequences` réserve un compteur par table et année ; transactions concurrentes sécurisées par InnoDB.
- L'année est celle du **serveur MySQL** à la date de création (elle ne se fixe pas à 2025).
- Ne pas modifier manuellement les codes. Seules les clés numériques assurent les relations entre tables.

## Reporting MySQL

11 vues `vw_*` ; sélectionner un rapport dans l'Admin puis **Exporter CSV** (ouvrable dans Excel).

Procédures :

- `sp_create_quote_from_request(id_demande, montant, @nouvel_id)` ;
- `sp_invoice_from_quote(id_devis, @nouvel_id)` ;
- `sp_publish_scheduled()` ;
- `sp_close_overdue_tasks()`.

Les deux dernières procédures sont à appeler par un planificateur externe, ou un EVENT MySQL si vous l'activez ; elles ne sont pas automatiquement planifiées.

## API utile

- `GET /api/health`
- `GET /api/public/services` et `GET /api/public/publications`
- `POST /api/public/contact`
- `POST /api/auth/login`, `GET /api/auth/me`
- `GET /api/admin/dashboard`, `/api/admin/meta`, `/api/admin/reports?view=vw_monthly_revenue`
- `GET /api/admin/data/:table?page=1&search=...`
- `GET /api/admin/data/:table/:id`
- `POST /api/admin/data/:table`
- `PUT /api/admin/data/:table/:id`
- `DELETE /api/admin/data/:table/:id`
- `POST /api/admin/procedures/quote-from-request` (`id`, `amount`)
- `POST /api/admin/procedures/invoice-from-quote` (`id`)

Les routes génériques sont limitées à une liste blanche. Les utilisateurs, rôles et permissions sont consultables, mais leur modification est volontairement bloquée sur les routes CRUD génériques : création initiale d'admin via commande, afin de ne pas exposer de gestion de mot de passe non sécurisée.

## À savoir avant toute production

Ce livrable est un **socle fonctionnel / MVP**. Nécessite avant mise en production : vérification des règles métier, champs obligatoires et contrôles de validation spécifiques, gestion complète du cycle de vie des documents et fichiers (stockage à configurer), rôles et permissions détaillés, journaux immuables, sécurité renforcée, sauvegardes, HTTPS, tests d'intégration sur serveur MySQL réel et stratégie de déploiement. Le formulaire public enregistre en base ; il n'envoie pas d'email automatiquement. Le CRUD des médias gère des **métadonnées et URL** (pas le téléversement binaire). Le site public reprend les visuels d’illustration des exports Stitch, conservés localement dans `frontend/public/images/` ; ce ne sont pas des photos officielles de l’entreprise. Pas de chiffres réels ni de coordonnées inventés.

## Démarrage facultatif avec Docker Compose

Si Docker est disponible : copier `.env.docker.example` vers `.env` à la **racine** puis remplacer toutes les valeurs. Exécuter `docker compose up -d` : le site est sur `http://localhost:5173`, API sur `http://localhost:4000` et MySQL sur le port local `3307`. Initialisation SQL exécutée au **premier démarrage du volume seulement**. Pour créer l'admin : `docker compose exec api npm run admin -- admin@exemple.com "UnMotDePasseFort_123!" "Administrateur"`. Ne pas supprimer le volume de base de données sans sauvegarde : cela supprime les données.

**Sécurité :** ne pas envoyer les fichiers `.env` par email, ne pas publier Docker tel quel sur Internet, et ne pas laisser des mots de passe d'exemple en production.
