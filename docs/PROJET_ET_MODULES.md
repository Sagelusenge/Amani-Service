# Architecture et périmètre

## Site public
Accueil, expertises, méthode, présentation, contact avec enregistrement SQL, et liste des publications publiées.

## Admin
Vue générale, clients, services, demandes, devis, factures, paiements, tâches, rendez-vous, publications, campagnes, calendrier éditorial, médias (URL), demandes de communication, prospects, contrats, documents (URL), catégories, témoignages, pages, bannières, messages, utilisateurs (lecture), rôles (lecture), permissions (lecture), paramètres et rapports.

## Validation / sécurité
JWT 8 heures, mot de passe bcrypt 12 rounds, helmet, CORS, limitateur de débit sur login/contact, requêtes préparées, sélection blanche des tables et colonnes, privilèges SQL limités. Pas de compte administrateur préconfiguré.

## Modèle
Toutes les entités métier disposent d'un `id` numérique auto-incrémenté ET d'un `*_code` métier (`PREFIX-NNN-AAAA`). Les références sont des clés uniques, les relations se font par FK numériques. `quote_items`, `invoice_items`, `campaign_metrics`, `role_permissions`, `communication_comments`, `audit_logs`, `site_visits` complètent les entités principales.

## Fonctionnalités à approfondir pour V2
Gestion des employés et permissions RBAC fines, workflow devis > facture avec UI dédiée, gestion d'upload fichiers, notifications email, règles de suppression douce et archivage, pagination côté serveur améliorée, validations métiers strictes, tableau de bord graphiques, filtres avancés, tests end-to-end, intégration d'un agenda, échéanciers et audit transactionnel.
