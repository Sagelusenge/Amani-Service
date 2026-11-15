-- Exécuter en tant qu'administrateur MySQL; remplacer le mot de passe avant utilisation.
CREATE USER IF NOT EXISTS 'amani_app'@'localhost' IDENTIFIED BY 'CHANGE_ME';
GRANT SELECT,INSERT,UPDATE,DELETE,EXECUTE ON amani_services.* TO 'amani_app'@'localhost';
FLUSH PRIVILEGES;
