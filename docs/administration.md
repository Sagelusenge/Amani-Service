# Administration Amani

- **Rôles / Permissions** : créer un rôle, sélectionner ses pages et autoriser la lecture ou la modification. Les droits sont vérifiés côté API à chaque requête. Le rôle admin conserve tous les droits. Une suspension coupe les accès API immédiatement.
- **Utilisateurs** : choisir le rôle et le statut actif. Modifier son propre compte via l’avatar en haut de page.
- **Devis / Factures** : créer le document, ouvrir Consulter, ajouter les lignes et enregistrer. Le total est recalculé côté serveur. Le bouton d’impression ouvre le document et permet « Enregistrer en PDF » dans le navigateur.
- **Reçus / Contrats** : impression depuis Consulter. Compléter les coordonnées et les conditions contractuelles dans Paramètres avant utilisation. Aucun taux fiscal n’est ajouté automatiquement.
- **Tâches** : un administrateur peut ajouter une observation datée, pendant le suivi ou après clôture. Le bouton Terminer marque explicitement le travail achevé ; une échéance dépassée reste distincte de la clôture.
- **Rendez-vous** : choisir le mois, cliquer sur une date puis renseigner client, horaires, objet, statut et lieu. Le calendrier se rafraîchit toutes les 15 secondes.
- **Fichiers** : JPEG, PNG et WebP dans Médias et Bannières ; PDF également dans Documents. Limite : 8 Mo. Les fichiers sont conservés dans backend/uploads ; sauvegarder ce dossier avec la base. Les URL de fichiers sont accessibles à quiconque dispose du lien.
- **Paramètres** : company_name, company_address, company_email, company_phone, company_registration, currency, document_footer, contract_terms. Les clés hero_image et about_image acceptent des images depuis l’appareil. La devise USD est une valeur initiale à adapter à votre activité.
- **Rapports** : les états de sortie filtrent les dates et le statut, affichent les montants mensuels et permettent un export CSV (maximum 1 000 lignes ; réduire la période si nécessaire).
- **Messages** : reçus depuis le formulaire public ; seuls leur statut et leur traitement sont modifiables. Actualisation toutes les 15 secondes.

La configuration initiale des droits et des paramètres est idempotente au démarrage du backend. Les tables de permissions et les journaux existants sont utilisés ; aucune suppression de données métier n’est nécessaire.

## Finalisation

Le tableau de bord s’adapte aux modules autorisés. Les conditions d’un contrat se modifient depuis sa fiche de consultation ; elles sont historisées dans le journal. Les conditions par défaut servent de point de départ. Les lignes commerciales recalculent le total du document et prévalent sur une saisie manuelle du total.

Vérification de rendu (sans navigateur) : `node frontend/verify-render.mjs`. Compilation : `npm --prefix frontend run build`. Vérification du backend : `npm --prefix backend run check`.

## Actions dans les listes

Les devis, factures et paiements proposent une action Imprimer / PDF. Les factures et paiements peuvent être archivés puis restaurés via le filtre Actifs / Archives / Tous. Cet archivage ne modifie pas les montants, le statut comptable ou les rapports financiers. Les suppressions de demandes et services restent réservées à l’administrateur avec confirmation. Les observations des tâches sont datées et conservent leur auteur.

## Images, impressions et réponses

Une image se charge directement dans les formulaires Publications et Campagnes. La liste Prospects propose une impression avec la recherche courante (limite 2 000 lignes). Les actions Imprimer des Contrats et Documents se trouvent dans leur liste. Le bouton Répondre des Messages prépare un texte puis ouvre Outlook Web ou la messagerie configurée ; aucun email n’est envoyé par le backend.

Les rôles proposent les droits Consulter, Ajouter, Modifier, Supprimer, Imprimer, Archiver et Répondre par module. Attribuer le rôle à chaque utilisateur dans Utilisateurs. Les anciens droits Modifier sont interprétés comme Ajouter et Modifier ; les autres actions sont à attribuer explicitement. La gestion des rôles et des comptes reste réservée à l’administrateur. Les pages publiques restent accessibles sans compte ; les droits contrôlent leur gestion dans l’admin.
