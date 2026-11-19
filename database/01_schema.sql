CREATE DATABASE IF NOT EXISTS amani_services CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE amani_services;

SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS code_sequences (entity VARCHAR(80) NOT NULL, code_year SMALLINT UNSIGNED NOT NULL, current_number BIGINT UNSIGNED NOT NULL DEFAULT 0, PRIMARY KEY(entity,code_year)) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `roles` (
 `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `role_code` VARCHAR(32) UNIQUE,
 `name` VARCHAR(255),
 `description` TEXT,
 `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 UNIQUE KEY uq_role_name (`name`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `permissions` (
 `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `permission_code` VARCHAR(32) UNIQUE,
 `name` VARCHAR(255),
 `description` TEXT,
 `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 UNIQUE KEY uq_perm_name (`name`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `users` (
 `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `user_code` VARCHAR(32) UNIQUE,
 `full_name` VARCHAR(255),
 `email` VARCHAR(190),
 `role_id` BIGINT UNSIGNED NULL,
 `is_active` TINYINT(1) DEFAULT 1,
 `password_hash` VARCHAR(255) NOT NULL,
 `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 UNIQUE KEY uq_users_email (`email`),
 CONSTRAINT `fk_users_role_id` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `categories` (
 `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `category_code` VARCHAR(32) UNIQUE,
 `name` VARCHAR(255),
 `description` TEXT,
 `type` VARCHAR(255),
 `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `clients` (
 `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `client_code` VARCHAR(32) UNIQUE,
 `name` VARCHAR(255),
 `company` VARCHAR(255),
 `email` VARCHAR(190),
 `phone` VARCHAR(50),
 `address` VARCHAR(255),
 `status` VARCHAR(40) DEFAULT 'nouveau',
 `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `services` (
 `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `service_code` VARCHAR(32) UNIQUE,
 `title` VARCHAR(255),
 `category` VARCHAR(255),
 `summary` TEXT,
 `description` TEXT,
 `indicative_price` DECIMAL(13,2) DEFAULT 0,
 `status` VARCHAR(40) DEFAULT 'nouveau',
 `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `media_assets` (
 `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `media_code` VARCHAR(32) UNIQUE,
 `filename` VARCHAR(255),
 `url` VARCHAR(600),
 `mime_type` VARCHAR(100),
 `alt_text` VARCHAR(255),
 `folder` VARCHAR(255),
 `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `site_pages` (
 `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `page_code` VARCHAR(32) UNIQUE,
 `slug` VARCHAR(190),
 `title` VARCHAR(255),
 `content` LONGTEXT,
 `status` VARCHAR(40) DEFAULT 'nouveau',
 `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 UNIQUE KEY uq_pages_slug (`slug`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `banners` (
 `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `banner_code` VARCHAR(32) UNIQUE,
 `title` VARCHAR(255),
 `subtitle` TEXT,
 `image_url` VARCHAR(600),
 `link_url` VARCHAR(600),
 `sort_order` INT DEFAULT 0,
 `is_active` TINYINT(1) DEFAULT 1,
 `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `testimonials` (
 `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `testimonial_code` VARCHAR(32) UNIQUE,
 `client_name` VARCHAR(255),
 `company` VARCHAR(255),
 `quote_text` TEXT,
 `is_published` TINYINT(1) DEFAULT 0,
 `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `site_settings` (
 `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `setting_code` VARCHAR(32) UNIQUE,
 `setting_key` VARCHAR(255),
 `setting_value` TEXT,
 `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 UNIQUE KEY uq_setting_key (`setting_key`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `contact_messages` (
 `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `message_code` VARCHAR(32) UNIQUE,
 `name` VARCHAR(255),
 `email` VARCHAR(190),
 `phone` VARCHAR(50),
 `subject` VARCHAR(255),
 `message` TEXT,
 `status` VARCHAR(40) DEFAULT 'nouveau',
 `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `leads` (
 `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `lead_code` VARCHAR(32) UNIQUE,
 `name` VARCHAR(255),
 `company` VARCHAR(255),
 `email` VARCHAR(190),
 `phone` VARCHAR(50),
 `source` VARCHAR(255),
 `stage` VARCHAR(50),
 `estimated_value` DECIMAL(13,2) DEFAULT 0,
 `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `service_requests` (
 `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `request_code` VARCHAR(32) UNIQUE,
 `client_id` BIGINT UNSIGNED NULL,
 `service_id` BIGINT UNSIGNED NULL,
 `subject` VARCHAR(255),
 `description` TEXT,
 `priority` VARCHAR(25) DEFAULT 'normale',
 `status` VARCHAR(40) DEFAULT 'nouveau',
 `due_date` DATE NULL,
 `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 CONSTRAINT `fk_service_requests_client_id` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE SET NULL,
 CONSTRAINT `fk_service_requests_service_id` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `quotes` (
 `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `quote_code` VARCHAR(32) UNIQUE,
 `client_id` BIGINT UNSIGNED NULL,
 `request_id` BIGINT UNSIGNED NULL,
 `issue_date` DATE NULL,
 `valid_until` DATE NULL,
 `total_amount` DECIMAL(13,2) DEFAULT 0,
 `status` VARCHAR(40) DEFAULT 'nouveau',
 `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 CONSTRAINT `fk_quotes_client_id` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE SET NULL,
 CONSTRAINT `fk_quotes_request_id` FOREIGN KEY (`request_id`) REFERENCES `service_requests` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `invoices` (
 `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `invoice_code` VARCHAR(32) UNIQUE,
 `client_id` BIGINT UNSIGNED NULL,
 `quote_id` BIGINT UNSIGNED NULL,
 `issue_date` DATE NULL,
 `due_date` DATE NULL,
 `total_amount` DECIMAL(13,2) DEFAULT 0,
 `paid_amount` DECIMAL(13,2) DEFAULT 0,
 `status` VARCHAR(40) DEFAULT 'nouveau',
 `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 CONSTRAINT `fk_invoices_client_id` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE SET NULL,
 CONSTRAINT `fk_invoices_quote_id` FOREIGN KEY (`quote_id`) REFERENCES `quotes` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `payments` (
 `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `payment_code` VARCHAR(32) UNIQUE,
 `invoice_id` BIGINT UNSIGNED NULL,
 `amount` DECIMAL(13,2) DEFAULT 0,
 `method` VARCHAR(255),
 `payment_date` DATE NULL,
 `transaction_ref` VARCHAR(160),
 `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 CONSTRAINT `fk_payments_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `tasks` (
 `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `task_code` VARCHAR(32) UNIQUE,
 `title` VARCHAR(255),
 `description` TEXT,
 `assigned_to` BIGINT UNSIGNED NULL,
 `client_id` BIGINT UNSIGNED NULL,
 `priority` VARCHAR(25) DEFAULT 'normale',
 `status` VARCHAR(40) DEFAULT 'nouveau',
 `due_date` DATE NULL,
 `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 CONSTRAINT `fk_tasks_assigned_to` FOREIGN KEY (`assigned_to`) REFERENCES `users` (`id`) ON DELETE SET NULL,
 CONSTRAINT `fk_tasks_client_id` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `appointments` (
 `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `appointment_code` VARCHAR(32) UNIQUE,
 `client_id` BIGINT UNSIGNED NULL,
 `title` VARCHAR(255),
 `start_at` DATETIME NULL,
 `end_at` DATETIME NULL,
 `location` VARCHAR(255),
 `status` VARCHAR(40) DEFAULT 'nouveau',
 `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 CONSTRAINT `fk_appointments_client_id` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `campaigns` (
 `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `campaign_code` VARCHAR(32) UNIQUE,
 `name` VARCHAR(255),
 `description` TEXT,
 `client_id` BIGINT UNSIGNED NULL,
 `owner_id` BIGINT UNSIGNED NULL,
 `channel` VARCHAR(255),
 `target_audience` VARCHAR(255),
 `budget` DECIMAL(13,2) DEFAULT 0,
 `start_date` DATE NULL,
 `end_date` DATE NULL,
 `status` VARCHAR(40) DEFAULT 'nouveau',
 `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 CONSTRAINT `fk_campaigns_client_id` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE SET NULL,
 CONSTRAINT `fk_campaigns_owner_id` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `publications` (
 `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `publication_code` VARCHAR(32) UNIQUE,
 `title` VARCHAR(255),
 `slug` VARCHAR(190),
 `summary` TEXT,
 `body` LONGTEXT,
 `category_id` BIGINT UNSIGNED NULL,
 `media_id` BIGINT UNSIGNED NULL,
 `author_id` BIGINT UNSIGNED NULL,
 `status` VARCHAR(40) DEFAULT 'nouveau',
 `scheduled_at` DATETIME NULL,
 `meta_title` VARCHAR(255),
 `meta_description` VARCHAR(300),
 `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 UNIQUE KEY uq_publication_slug (`slug`),
 CONSTRAINT `fk_publications_category_id` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL,
 CONSTRAINT `fk_publications_media_id` FOREIGN KEY (`media_id`) REFERENCES `media_assets` (`id`) ON DELETE SET NULL,
 CONSTRAINT `fk_publications_author_id` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `editorial_events` (
 `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `event_code` VARCHAR(32) UNIQUE,
 `publication_id` BIGINT UNSIGNED NULL,
 `campaign_id` BIGINT UNSIGNED NULL,
 `title` VARCHAR(255),
 `channel` VARCHAR(255),
 `scheduled_at` DATETIME NULL,
 `status` VARCHAR(40) DEFAULT 'nouveau',
 `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 CONSTRAINT `fk_editorial_events_publication_id` FOREIGN KEY (`publication_id`) REFERENCES `publications` (`id`) ON DELETE SET NULL,
 CONSTRAINT `fk_editorial_events_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `campaigns` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `communication_requests` (
 `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `communication_code` VARCHAR(32) UNIQUE,
 `client_id` BIGINT UNSIGNED NULL,
 `title` VARCHAR(255),
 `description` TEXT,
 `assigned_to` BIGINT UNSIGNED NULL,
 `priority` VARCHAR(25) DEFAULT 'normale',
 `status` VARCHAR(40) DEFAULT 'nouveau',
 `delivery_date` DATE NULL,
 `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 CONSTRAINT `fk_communication_requests_client_id` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE SET NULL,
 CONSTRAINT `fk_communication_requests_assigned_to` FOREIGN KEY (`assigned_to`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `contracts` (
 `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `contract_code` VARCHAR(32) UNIQUE,
 `client_id` BIGINT UNSIGNED NULL,
 `title` VARCHAR(255),
 `start_date` DATE NULL,
 `end_date` DATE NULL,
 `amount` DECIMAL(13,2) DEFAULT 0,
 `status` VARCHAR(40) DEFAULT 'nouveau',
 `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 CONSTRAINT `fk_contracts_client_id` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `documents` (
 `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `document_code` VARCHAR(32) UNIQUE,
 `client_id` BIGINT UNSIGNED NULL,
 `title` VARCHAR(255),
 `document_type` VARCHAR(255),
 `file_url` VARCHAR(600),
 `status` VARCHAR(40) DEFAULT 'nouveau',
 `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 CONSTRAINT `fk_documents_client_id` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `notifications` (
 `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `notification_code` VARCHAR(32) UNIQUE,
 `user_id` BIGINT UNSIGNED NULL,
 `title` VARCHAR(255),
 `message` TEXT,
 `is_read` TINYINT(1) DEFAULT 0,
 `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 CONSTRAINT `fk_notifications_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS role_permissions (role_id BIGINT UNSIGNED NOT NULL, permission_id BIGINT UNSIGNED NOT NULL, PRIMARY KEY(role_id,permission_id), FOREIGN KEY(role_id) REFERENCES roles(id) ON DELETE CASCADE, FOREIGN KEY(permission_id) REFERENCES permissions(id) ON DELETE CASCADE) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS quote_items (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, quote_id BIGINT UNSIGNED NOT NULL, service_id BIGINT UNSIGNED NULL, label VARCHAR(255) NOT NULL, quantity DECIMAL(10,2) NOT NULL DEFAULT 1, unit_price DECIMAL(13,2) NOT NULL DEFAULT 0, line_total DECIMAL(13,2) GENERATED ALWAYS AS (quantity * unit_price) STORED, FOREIGN KEY (quote_id) REFERENCES quotes(id) ON DELETE CASCADE, FOREIGN KEY(service_id) REFERENCES services(id) ON DELETE SET NULL) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS invoice_items (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, invoice_id BIGINT UNSIGNED NOT NULL, label VARCHAR(255) NOT NULL, quantity DECIMAL(10,2) NOT NULL DEFAULT 1, unit_price DECIMAL(13,2) NOT NULL DEFAULT 0, line_total DECIMAL(13,2) GENERATED ALWAYS AS (quantity * unit_price) STORED, FOREIGN KEY(invoice_id) REFERENCES invoices(id) ON DELETE CASCADE) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS audit_logs (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, actor_id BIGINT UNSIGNED NULL, entity_name VARCHAR(80) NOT NULL, entity_id BIGINT UNSIGNED NULL, action_name VARCHAR(32) NOT NULL, detail JSON NULL, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY(actor_id) REFERENCES users(id) ON DELETE SET NULL) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS campaign_metrics (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, campaign_id BIGINT UNSIGNED NOT NULL, metric_date DATE NOT NULL, impressions INT UNSIGNED DEFAULT 0, clicks INT UNSIGNED DEFAULT 0, conversions INT UNSIGNED DEFAULT 0, spend DECIMAL(13,2) DEFAULT 0, UNIQUE KEY uq_campaign_metric(campaign_id,metric_date), FOREIGN KEY(campaign_id) REFERENCES campaigns(id) ON DELETE CASCADE) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS site_visits (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, visit_date DATE NOT NULL, source VARCHAR(120) DEFAULT 'direct', page_path VARCHAR(200), sessions INT UNSIGNED DEFAULT 1, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, INDEX idx_site_visits_date(visit_date)) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS communication_comments (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, communication_request_id BIGINT UNSIGNED NOT NULL, user_id BIGINT UNSIGNED NULL, comment_text TEXT NOT NULL, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, FOREIGN KEY(communication_request_id) REFERENCES communication_requests(id) ON DELETE CASCADE, FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE SET NULL) ENGINE=InnoDB;

INSERT INTO roles (role_code,name,description) VALUES ('ROL-001-2026','admin','Administrateur principal'),('ROL-002-2026','manager','Responsable'),('ROL-003-2026','editor','Gestionnaire éditorial') ON DUPLICATE KEY UPDATE description=VALUES(description);

INSERT INTO services(service_code,title,category,summary,description,status) VALUES ('SRV-001-2026','Assistance administrative','Administration','Gestion documentaire et assistance au quotidien','Courriers, dossiers, formalités et suivi administratif.','publié'),('SRV-002-2026','Organisation professionnelle','Organisation','Optimisation de l’organisation et des rendez-vous','Planification, coordination et support opérationnel.','publié'),('SRV-003-2026','Communication professionnelle','Communication','Accompagnement de votre communication','Contenus, publications et présence professionnelle.','publié'),('SRV-004-2026','Stratégie commerciale','Commercial','Accompagnement à la croissance commerciale','Prospection, suivi des opportunités et stratégie.','publié') ON DUPLICATE KEY UPDATE title=VALUES(title);

INSERT INTO code_sequences(entity,code_year,current_number) VALUES ('roles',2026,3),('services',2026,4) ON DUPLICATE KEY UPDATE current_number=GREATEST(current_number,VALUES(current_number));

DELIMITER $$

DROP TRIGGER IF EXISTS `trg_roles_code`$$
CREATE TRIGGER `trg_roles_code` BEFORE INSERT ON `roles` FOR EACH ROW
BEGIN
 DECLARE next_num BIGINT UNSIGNED;
 DECLARE y SMALLINT UNSIGNED;
 SET y = YEAR(CURRENT_DATE());
 IF NEW.`role_code` IS NULL OR NEW.`role_code` = '' THEN
  INSERT INTO code_sequences(entity,code_year,current_number) VALUES('roles',y,LAST_INSERT_ID(1))
  ON DUPLICATE KEY UPDATE current_number=LAST_INSERT_ID(current_number+1);
  SET next_num = LAST_INSERT_ID();
  SET NEW.`role_code` = CONCAT('ROL-',LPAD(next_num,3,'0'),'-',y);
 END IF;
END$$

DROP TRIGGER IF EXISTS `trg_permissions_code`$$
CREATE TRIGGER `trg_permissions_code` BEFORE INSERT ON `permissions` FOR EACH ROW
BEGIN
 DECLARE next_num BIGINT UNSIGNED;
 DECLARE y SMALLINT UNSIGNED;
 SET y = YEAR(CURRENT_DATE());
 IF NEW.`permission_code` IS NULL OR NEW.`permission_code` = '' THEN
  INSERT INTO code_sequences(entity,code_year,current_number) VALUES('permissions',y,LAST_INSERT_ID(1))
  ON DUPLICATE KEY UPDATE current_number=LAST_INSERT_ID(current_number+1);
  SET next_num = LAST_INSERT_ID();
  SET NEW.`permission_code` = CONCAT('PER-',LPAD(next_num,3,'0'),'-',y);
 END IF;
END$$

DROP TRIGGER IF EXISTS `trg_users_code`$$
CREATE TRIGGER `trg_users_code` BEFORE INSERT ON `users` FOR EACH ROW
BEGIN
 DECLARE next_num BIGINT UNSIGNED;
 DECLARE y SMALLINT UNSIGNED;
 SET y = YEAR(CURRENT_DATE());
 IF NEW.`user_code` IS NULL OR NEW.`user_code` = '' THEN
  INSERT INTO code_sequences(entity,code_year,current_number) VALUES('users',y,LAST_INSERT_ID(1))
  ON DUPLICATE KEY UPDATE current_number=LAST_INSERT_ID(current_number+1);
  SET next_num = LAST_INSERT_ID();
  SET NEW.`user_code` = CONCAT('USR-',LPAD(next_num,3,'0'),'-',y);
 END IF;
END$$

DROP TRIGGER IF EXISTS `trg_categories_code`$$
CREATE TRIGGER `trg_categories_code` BEFORE INSERT ON `categories` FOR EACH ROW
BEGIN
 DECLARE next_num BIGINT UNSIGNED;
 DECLARE y SMALLINT UNSIGNED;
 SET y = YEAR(CURRENT_DATE());
 IF NEW.`category_code` IS NULL OR NEW.`category_code` = '' THEN
  INSERT INTO code_sequences(entity,code_year,current_number) VALUES('categories',y,LAST_INSERT_ID(1))
  ON DUPLICATE KEY UPDATE current_number=LAST_INSERT_ID(current_number+1);
  SET next_num = LAST_INSERT_ID();
  SET NEW.`category_code` = CONCAT('CAT-',LPAD(next_num,3,'0'),'-',y);
 END IF;
END$$

DROP TRIGGER IF EXISTS `trg_clients_code`$$
CREATE TRIGGER `trg_clients_code` BEFORE INSERT ON `clients` FOR EACH ROW
BEGIN
 DECLARE next_num BIGINT UNSIGNED;
 DECLARE y SMALLINT UNSIGNED;
 SET y = YEAR(CURRENT_DATE());
 IF NEW.`client_code` IS NULL OR NEW.`client_code` = '' THEN
  INSERT INTO code_sequences(entity,code_year,current_number) VALUES('clients',y,LAST_INSERT_ID(1))
  ON DUPLICATE KEY UPDATE current_number=LAST_INSERT_ID(current_number+1);
  SET next_num = LAST_INSERT_ID();
  SET NEW.`client_code` = CONCAT('CLI-',LPAD(next_num,3,'0'),'-',y);
 END IF;
END$$

DROP TRIGGER IF EXISTS `trg_services_code`$$
CREATE TRIGGER `trg_services_code` BEFORE INSERT ON `services` FOR EACH ROW
BEGIN
 DECLARE next_num BIGINT UNSIGNED;
 DECLARE y SMALLINT UNSIGNED;
 SET y = YEAR(CURRENT_DATE());
 IF NEW.`service_code` IS NULL OR NEW.`service_code` = '' THEN
  INSERT INTO code_sequences(entity,code_year,current_number) VALUES('services',y,LAST_INSERT_ID(1))
  ON DUPLICATE KEY UPDATE current_number=LAST_INSERT_ID(current_number+1);
  SET next_num = LAST_INSERT_ID();
  SET NEW.`service_code` = CONCAT('SRV-',LPAD(next_num,3,'0'),'-',y);
 END IF;
END$$

DROP TRIGGER IF EXISTS `trg_media_assets_code`$$
CREATE TRIGGER `trg_media_assets_code` BEFORE INSERT ON `media_assets` FOR EACH ROW
BEGIN
 DECLARE next_num BIGINT UNSIGNED;
 DECLARE y SMALLINT UNSIGNED;
 SET y = YEAR(CURRENT_DATE());
 IF NEW.`media_code` IS NULL OR NEW.`media_code` = '' THEN
  INSERT INTO code_sequences(entity,code_year,current_number) VALUES('media_assets',y,LAST_INSERT_ID(1))
  ON DUPLICATE KEY UPDATE current_number=LAST_INSERT_ID(current_number+1);
  SET next_num = LAST_INSERT_ID();
  SET NEW.`media_code` = CONCAT('MED-',LPAD(next_num,3,'0'),'-',y);
 END IF;
END$$

DROP TRIGGER IF EXISTS `trg_site_pages_code`$$
CREATE TRIGGER `trg_site_pages_code` BEFORE INSERT ON `site_pages` FOR EACH ROW
BEGIN
 DECLARE next_num BIGINT UNSIGNED;
 DECLARE y SMALLINT UNSIGNED;
 SET y = YEAR(CURRENT_DATE());
 IF NEW.`page_code` IS NULL OR NEW.`page_code` = '' THEN
  INSERT INTO code_sequences(entity,code_year,current_number) VALUES('site_pages',y,LAST_INSERT_ID(1))
  ON DUPLICATE KEY UPDATE current_number=LAST_INSERT_ID(current_number+1);
  SET next_num = LAST_INSERT_ID();
  SET NEW.`page_code` = CONCAT('PAG-',LPAD(next_num,3,'0'),'-',y);
 END IF;
END$$

DROP TRIGGER IF EXISTS `trg_banners_code`$$
CREATE TRIGGER `trg_banners_code` BEFORE INSERT ON `banners` FOR EACH ROW
BEGIN
 DECLARE next_num BIGINT UNSIGNED;
 DECLARE y SMALLINT UNSIGNED;
 SET y = YEAR(CURRENT_DATE());
 IF NEW.`banner_code` IS NULL OR NEW.`banner_code` = '' THEN
  INSERT INTO code_sequences(entity,code_year,current_number) VALUES('banners',y,LAST_INSERT_ID(1))
  ON DUPLICATE KEY UPDATE current_number=LAST_INSERT_ID(current_number+1);
  SET next_num = LAST_INSERT_ID();
  SET NEW.`banner_code` = CONCAT('BAN-',LPAD(next_num,3,'0'),'-',y);
 END IF;
END$$

DROP TRIGGER IF EXISTS `trg_testimonials_code`$$
CREATE TRIGGER `trg_testimonials_code` BEFORE INSERT ON `testimonials` FOR EACH ROW
BEGIN
 DECLARE next_num BIGINT UNSIGNED;
 DECLARE y SMALLINT UNSIGNED;
 SET y = YEAR(CURRENT_DATE());
 IF NEW.`testimonial_code` IS NULL OR NEW.`testimonial_code` = '' THEN
  INSERT INTO code_sequences(entity,code_year,current_number) VALUES('testimonials',y,LAST_INSERT_ID(1))
  ON DUPLICATE KEY UPDATE current_number=LAST_INSERT_ID(current_number+1);
  SET next_num = LAST_INSERT_ID();
  SET NEW.`testimonial_code` = CONCAT('TEM-',LPAD(next_num,3,'0'),'-',y);
 END IF;
END$$

DROP TRIGGER IF EXISTS `trg_site_settings_code`$$
CREATE TRIGGER `trg_site_settings_code` BEFORE INSERT ON `site_settings` FOR EACH ROW
BEGIN
 DECLARE next_num BIGINT UNSIGNED;
 DECLARE y SMALLINT UNSIGNED;
 SET y = YEAR(CURRENT_DATE());
 IF NEW.`setting_code` IS NULL OR NEW.`setting_code` = '' THEN
  INSERT INTO code_sequences(entity,code_year,current_number) VALUES('site_settings',y,LAST_INSERT_ID(1))
  ON DUPLICATE KEY UPDATE current_number=LAST_INSERT_ID(current_number+1);
  SET next_num = LAST_INSERT_ID();
  SET NEW.`setting_code` = CONCAT('CFG-',LPAD(next_num,3,'0'),'-',y);
 END IF;
END$$

DROP TRIGGER IF EXISTS `trg_contact_messages_code`$$
CREATE TRIGGER `trg_contact_messages_code` BEFORE INSERT ON `contact_messages` FOR EACH ROW
BEGIN
 DECLARE next_num BIGINT UNSIGNED;
 DECLARE y SMALLINT UNSIGNED;
 SET y = YEAR(CURRENT_DATE());
 IF NEW.`message_code` IS NULL OR NEW.`message_code` = '' THEN
  INSERT INTO code_sequences(entity,code_year,current_number) VALUES('contact_messages',y,LAST_INSERT_ID(1))
  ON DUPLICATE KEY UPDATE current_number=LAST_INSERT_ID(current_number+1);
  SET next_num = LAST_INSERT_ID();
  SET NEW.`message_code` = CONCAT('MSG-',LPAD(next_num,3,'0'),'-',y);
 END IF;
END$$

DROP TRIGGER IF EXISTS `trg_leads_code`$$
CREATE TRIGGER `trg_leads_code` BEFORE INSERT ON `leads` FOR EACH ROW
BEGIN
 DECLARE next_num BIGINT UNSIGNED;
 DECLARE y SMALLINT UNSIGNED;
 SET y = YEAR(CURRENT_DATE());
 IF NEW.`lead_code` IS NULL OR NEW.`lead_code` = '' THEN
  INSERT INTO code_sequences(entity,code_year,current_number) VALUES('leads',y,LAST_INSERT_ID(1))
  ON DUPLICATE KEY UPDATE current_number=LAST_INSERT_ID(current_number+1);
  SET next_num = LAST_INSERT_ID();
  SET NEW.`lead_code` = CONCAT('PRO-',LPAD(next_num,3,'0'),'-',y);
 END IF;
END$$

DROP TRIGGER IF EXISTS `trg_service_requests_code`$$
CREATE TRIGGER `trg_service_requests_code` BEFORE INSERT ON `service_requests` FOR EACH ROW
BEGIN
 DECLARE next_num BIGINT UNSIGNED;
 DECLARE y SMALLINT UNSIGNED;
 SET y = YEAR(CURRENT_DATE());
 IF NEW.`request_code` IS NULL OR NEW.`request_code` = '' THEN
  INSERT INTO code_sequences(entity,code_year,current_number) VALUES('service_requests',y,LAST_INSERT_ID(1))
  ON DUPLICATE KEY UPDATE current_number=LAST_INSERT_ID(current_number+1);
  SET next_num = LAST_INSERT_ID();
  SET NEW.`request_code` = CONCAT('DEM-',LPAD(next_num,3,'0'),'-',y);
 END IF;
END$$

DROP TRIGGER IF EXISTS `trg_quotes_code`$$
CREATE TRIGGER `trg_quotes_code` BEFORE INSERT ON `quotes` FOR EACH ROW
BEGIN
 DECLARE next_num BIGINT UNSIGNED;
 DECLARE y SMALLINT UNSIGNED;
 SET y = YEAR(CURRENT_DATE());
 IF NEW.`quote_code` IS NULL OR NEW.`quote_code` = '' THEN
  INSERT INTO code_sequences(entity,code_year,current_number) VALUES('quotes',y,LAST_INSERT_ID(1))
  ON DUPLICATE KEY UPDATE current_number=LAST_INSERT_ID(current_number+1);
  SET next_num = LAST_INSERT_ID();
  SET NEW.`quote_code` = CONCAT('DEV-',LPAD(next_num,3,'0'),'-',y);
 END IF;
END$$

DROP TRIGGER IF EXISTS `trg_invoices_code`$$
CREATE TRIGGER `trg_invoices_code` BEFORE INSERT ON `invoices` FOR EACH ROW
BEGIN
 DECLARE next_num BIGINT UNSIGNED;
 DECLARE y SMALLINT UNSIGNED;
 SET y = YEAR(CURRENT_DATE());
 IF NEW.`invoice_code` IS NULL OR NEW.`invoice_code` = '' THEN
  INSERT INTO code_sequences(entity,code_year,current_number) VALUES('invoices',y,LAST_INSERT_ID(1))
  ON DUPLICATE KEY UPDATE current_number=LAST_INSERT_ID(current_number+1);
  SET next_num = LAST_INSERT_ID();
  SET NEW.`invoice_code` = CONCAT('FAC-',LPAD(next_num,3,'0'),'-',y);
 END IF;
END$$

DROP TRIGGER IF EXISTS `trg_payments_code`$$
CREATE TRIGGER `trg_payments_code` BEFORE INSERT ON `payments` FOR EACH ROW
BEGIN
 DECLARE next_num BIGINT UNSIGNED;
 DECLARE y SMALLINT UNSIGNED;
 SET y = YEAR(CURRENT_DATE());
 IF NEW.`payment_code` IS NULL OR NEW.`payment_code` = '' THEN
  INSERT INTO code_sequences(entity,code_year,current_number) VALUES('payments',y,LAST_INSERT_ID(1))
  ON DUPLICATE KEY UPDATE current_number=LAST_INSERT_ID(current_number+1);
  SET next_num = LAST_INSERT_ID();
  SET NEW.`payment_code` = CONCAT('PAY-',LPAD(next_num,3,'0'),'-',y);
 END IF;
END$$

DROP TRIGGER IF EXISTS `trg_tasks_code`$$
CREATE TRIGGER `trg_tasks_code` BEFORE INSERT ON `tasks` FOR EACH ROW
BEGIN
 DECLARE next_num BIGINT UNSIGNED;
 DECLARE y SMALLINT UNSIGNED;
 SET y = YEAR(CURRENT_DATE());
 IF NEW.`task_code` IS NULL OR NEW.`task_code` = '' THEN
  INSERT INTO code_sequences(entity,code_year,current_number) VALUES('tasks',y,LAST_INSERT_ID(1))
  ON DUPLICATE KEY UPDATE current_number=LAST_INSERT_ID(current_number+1);
  SET next_num = LAST_INSERT_ID();
  SET NEW.`task_code` = CONCAT('TAC-',LPAD(next_num,3,'0'),'-',y);
 END IF;
END$$

DROP TRIGGER IF EXISTS `trg_appointments_code`$$
CREATE TRIGGER `trg_appointments_code` BEFORE INSERT ON `appointments` FOR EACH ROW
BEGIN
 DECLARE next_num BIGINT UNSIGNED;
 DECLARE y SMALLINT UNSIGNED;
 SET y = YEAR(CURRENT_DATE());
 IF NEW.`appointment_code` IS NULL OR NEW.`appointment_code` = '' THEN
  INSERT INTO code_sequences(entity,code_year,current_number) VALUES('appointments',y,LAST_INSERT_ID(1))
  ON DUPLICATE KEY UPDATE current_number=LAST_INSERT_ID(current_number+1);
  SET next_num = LAST_INSERT_ID();
  SET NEW.`appointment_code` = CONCAT('RDV-',LPAD(next_num,3,'0'),'-',y);
 END IF;
END$$

DROP TRIGGER IF EXISTS `trg_campaigns_code`$$
CREATE TRIGGER `trg_campaigns_code` BEFORE INSERT ON `campaigns` FOR EACH ROW
BEGIN
 DECLARE next_num BIGINT UNSIGNED;
 DECLARE y SMALLINT UNSIGNED;
 SET y = YEAR(CURRENT_DATE());
 IF NEW.`campaign_code` IS NULL OR NEW.`campaign_code` = '' THEN
  INSERT INTO code_sequences(entity,code_year,current_number) VALUES('campaigns',y,LAST_INSERT_ID(1))
  ON DUPLICATE KEY UPDATE current_number=LAST_INSERT_ID(current_number+1);
  SET next_num = LAST_INSERT_ID();
  SET NEW.`campaign_code` = CONCAT('CAM-',LPAD(next_num,3,'0'),'-',y);
 END IF;
END$$

DROP TRIGGER IF EXISTS `trg_publications_code`$$
CREATE TRIGGER `trg_publications_code` BEFORE INSERT ON `publications` FOR EACH ROW
BEGIN
 DECLARE next_num BIGINT UNSIGNED;
 DECLARE y SMALLINT UNSIGNED;
 SET y = YEAR(CURRENT_DATE());
 IF NEW.`publication_code` IS NULL OR NEW.`publication_code` = '' THEN
  INSERT INTO code_sequences(entity,code_year,current_number) VALUES('publications',y,LAST_INSERT_ID(1))
  ON DUPLICATE KEY UPDATE current_number=LAST_INSERT_ID(current_number+1);
  SET next_num = LAST_INSERT_ID();
  SET NEW.`publication_code` = CONCAT('PUB-',LPAD(next_num,3,'0'),'-',y);
 END IF;
END$$

DROP TRIGGER IF EXISTS `trg_editorial_events_code`$$
CREATE TRIGGER `trg_editorial_events_code` BEFORE INSERT ON `editorial_events` FOR EACH ROW
BEGIN
 DECLARE next_num BIGINT UNSIGNED;
 DECLARE y SMALLINT UNSIGNED;
 SET y = YEAR(CURRENT_DATE());
 IF NEW.`event_code` IS NULL OR NEW.`event_code` = '' THEN
  INSERT INTO code_sequences(entity,code_year,current_number) VALUES('editorial_events',y,LAST_INSERT_ID(1))
  ON DUPLICATE KEY UPDATE current_number=LAST_INSERT_ID(current_number+1);
  SET next_num = LAST_INSERT_ID();
  SET NEW.`event_code` = CONCAT('EDI-',LPAD(next_num,3,'0'),'-',y);
 END IF;
END$$

DROP TRIGGER IF EXISTS `trg_communication_requests_code`$$
CREATE TRIGGER `trg_communication_requests_code` BEFORE INSERT ON `communication_requests` FOR EACH ROW
BEGIN
 DECLARE next_num BIGINT UNSIGNED;
 DECLARE y SMALLINT UNSIGNED;
 SET y = YEAR(CURRENT_DATE());
 IF NEW.`communication_code` IS NULL OR NEW.`communication_code` = '' THEN
  INSERT INTO code_sequences(entity,code_year,current_number) VALUES('communication_requests',y,LAST_INSERT_ID(1))
  ON DUPLICATE KEY UPDATE current_number=LAST_INSERT_ID(current_number+1);
  SET next_num = LAST_INSERT_ID();
  SET NEW.`communication_code` = CONCAT('COM-',LPAD(next_num,3,'0'),'-',y);
 END IF;
END$$

DROP TRIGGER IF EXISTS `trg_contracts_code`$$
CREATE TRIGGER `trg_contracts_code` BEFORE INSERT ON `contracts` FOR EACH ROW
BEGIN
 DECLARE next_num BIGINT UNSIGNED;
 DECLARE y SMALLINT UNSIGNED;
 SET y = YEAR(CURRENT_DATE());
 IF NEW.`contract_code` IS NULL OR NEW.`contract_code` = '' THEN
  INSERT INTO code_sequences(entity,code_year,current_number) VALUES('contracts',y,LAST_INSERT_ID(1))
  ON DUPLICATE KEY UPDATE current_number=LAST_INSERT_ID(current_number+1);
  SET next_num = LAST_INSERT_ID();
  SET NEW.`contract_code` = CONCAT('CTR-',LPAD(next_num,3,'0'),'-',y);
 END IF;
END$$

DROP TRIGGER IF EXISTS `trg_documents_code`$$
CREATE TRIGGER `trg_documents_code` BEFORE INSERT ON `documents` FOR EACH ROW
BEGIN
 DECLARE next_num BIGINT UNSIGNED;
 DECLARE y SMALLINT UNSIGNED;
 SET y = YEAR(CURRENT_DATE());
 IF NEW.`document_code` IS NULL OR NEW.`document_code` = '' THEN
  INSERT INTO code_sequences(entity,code_year,current_number) VALUES('documents',y,LAST_INSERT_ID(1))
  ON DUPLICATE KEY UPDATE current_number=LAST_INSERT_ID(current_number+1);
  SET next_num = LAST_INSERT_ID();
  SET NEW.`document_code` = CONCAT('DOC-',LPAD(next_num,3,'0'),'-',y);
 END IF;
END$$

DROP TRIGGER IF EXISTS `trg_notifications_code`$$
CREATE TRIGGER `trg_notifications_code` BEFORE INSERT ON `notifications` FOR EACH ROW
BEGIN
 DECLARE next_num BIGINT UNSIGNED;
 DECLARE y SMALLINT UNSIGNED;
 SET y = YEAR(CURRENT_DATE());
 IF NEW.`notification_code` IS NULL OR NEW.`notification_code` = '' THEN
  INSERT INTO code_sequences(entity,code_year,current_number) VALUES('notifications',y,LAST_INSERT_ID(1))
  ON DUPLICATE KEY UPDATE current_number=LAST_INSERT_ID(current_number+1);
  SET next_num = LAST_INSERT_ID();
  SET NEW.`notification_code` = CONCAT('NOT-',LPAD(next_num,3,'0'),'-',y);
 END IF;
END$$

DROP TRIGGER IF EXISTS trg_payment_invoice_total$$
CREATE TRIGGER trg_payment_invoice_total AFTER INSERT ON payments FOR EACH ROW
BEGIN
 UPDATE invoices SET paid_amount=(SELECT COALESCE(SUM(amount),0) FROM payments WHERE invoice_id=NEW.invoice_id), status=CASE WHEN (SELECT COALESCE(SUM(amount),0) FROM payments WHERE invoice_id=NEW.invoice_id)>=total_amount THEN 'payée' ELSE 'partielle' END WHERE id=NEW.invoice_id;
END$$

DROP PROCEDURE IF EXISTS sp_create_quote_from_request$$
CREATE PROCEDURE sp_create_quote_from_request(IN p_request_id BIGINT UNSIGNED, IN p_amount DECIMAL(13,2), OUT p_quote_id BIGINT UNSIGNED)
BEGIN
 DECLARE v_client_id BIGINT UNSIGNED;
 SELECT client_id INTO v_client_id FROM service_requests WHERE id=p_request_id;
 IF v_client_id IS NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Demande sans client'; END IF;
 INSERT INTO quotes(client_id,request_id,issue_date,valid_until,total_amount,status) VALUES(v_client_id,p_request_id,CURDATE(),DATE_ADD(CURDATE(),INTERVAL 30 DAY),p_amount,'brouillon');
 SET p_quote_id=LAST_INSERT_ID();
 UPDATE service_requests SET status='devis créé' WHERE id=p_request_id;
END$$

DROP PROCEDURE IF EXISTS sp_invoice_from_quote$$
CREATE PROCEDURE sp_invoice_from_quote(IN p_quote_id BIGINT UNSIGNED, OUT p_invoice_id BIGINT UNSIGNED)
BEGIN
 INSERT INTO invoices(client_id,quote_id,issue_date,due_date,total_amount,status)
 SELECT client_id,id,CURDATE(),DATE_ADD(CURDATE(),INTERVAL 30 DAY),total_amount,'impayée' FROM quotes WHERE id=p_quote_id AND status IN ('accepté','accepte');
 IF ROW_COUNT()=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Devis inexistant ou non accepté'; END IF;
 SET p_invoice_id=LAST_INSERT_ID();
 INSERT INTO invoice_items(invoice_id,label,quantity,unit_price) SELECT p_invoice_id,label,quantity,unit_price FROM quote_items WHERE quote_id=p_quote_id;
END$$

DROP PROCEDURE IF EXISTS sp_publish_scheduled$$
CREATE PROCEDURE sp_publish_scheduled()
BEGIN
 UPDATE publications SET status='publié' WHERE status='programmé' AND scheduled_at<=NOW();
 UPDATE editorial_events SET status='terminé' WHERE status='programmé' AND scheduled_at<=NOW();
END$$

DROP PROCEDURE IF EXISTS sp_close_overdue_tasks$$
CREATE PROCEDURE sp_close_overdue_tasks()
BEGIN
 UPDATE tasks SET priority='urgente' WHERE due_date<CURDATE() AND status NOT IN ('terminée','annulée');
END$$

DELIMITER ;

CREATE OR REPLACE VIEW `vw_dashboard_kpis` AS SELECT (SELECT COUNT(*) FROM clients) AS total_clients,(SELECT COUNT(*) FROM service_requests WHERE status IN ('nouveau','nouvelle')) AS new_requests,(SELECT COUNT(*) FROM tasks WHERE status NOT IN ('terminée','annulée')) AS open_tasks,(SELECT COUNT(*) FROM quotes WHERE status IN ('en attente','envoyé')) AS pending_quotes,(SELECT COALESCE(SUM(amount),0) FROM payments) AS total_collected,(SELECT COALESCE(SUM(total_amount-paid_amount),0) FROM invoices WHERE status <> 'annulée') AS outstanding_balance;

CREATE OR REPLACE VIEW `vw_monthly_revenue` AS SELECT DATE_FORMAT(payment_date,'%Y-%m') AS month,COUNT(*) AS payments_count,SUM(amount) AS revenue FROM payments WHERE payment_date IS NOT NULL GROUP BY DATE_FORMAT(payment_date,'%Y-%m');

CREATE OR REPLACE VIEW `vw_requests_by_status` AS SELECT status,COUNT(*) AS total FROM service_requests GROUP BY status;

CREATE OR REPLACE VIEW `vw_clients_activity` AS SELECT c.id,c.client_code,c.name,c.company,COUNT(DISTINCT r.id) AS requests_count,COUNT(DISTINCT q.id) AS quotes_count FROM clients c LEFT JOIN service_requests r ON r.client_id=c.id LEFT JOIN quotes q ON q.client_id=c.id GROUP BY c.id,c.client_code,c.name,c.company;

CREATE OR REPLACE VIEW `vw_communication_stats` AS SELECT (SELECT COUNT(*) FROM publications) AS publications_total,(SELECT COUNT(*) FROM publications WHERE status='publié') AS publications_published,(SELECT COUNT(*) FROM campaigns WHERE status='active') AS campaigns_active,(SELECT COUNT(*) FROM communication_requests WHERE status NOT IN ('terminée','annulée')) AS requests_open;

CREATE OR REPLACE VIEW `vw_campaign_performance` AS SELECT c.id,c.campaign_code,c.name,c.channel,c.status,COALESCE(SUM(m.impressions),0) AS impressions,COALESCE(SUM(m.clicks),0) AS clicks,COALESCE(SUM(m.conversions),0) AS conversions,COALESCE(SUM(m.spend),0) AS spent FROM campaigns c LEFT JOIN campaign_metrics m ON m.campaign_id=c.id GROUP BY c.id,c.campaign_code,c.name,c.channel,c.status;

CREATE OR REPLACE VIEW `vw_invoice_balances` AS SELECT i.id,i.invoice_code,c.name AS client_name,i.total_amount,i.paid_amount,(i.total_amount-i.paid_amount) AS balance,i.status,i.due_date FROM invoices i LEFT JOIN clients c ON c.id=i.client_id;

CREATE OR REPLACE VIEW `vw_publication_calendar` AS SELECT p.id,p.publication_code,p.title,p.status,p.scheduled_at,c.name AS category_name FROM publications p LEFT JOIN categories c ON c.id=p.category_id;

CREATE OR REPLACE VIEW `vw_service_demands` AS SELECT s.id,s.title AS service_name,COUNT(r.id) AS request_count FROM services s LEFT JOIN service_requests r ON r.service_id=s.id GROUP BY s.id,s.title;

CREATE OR REPLACE VIEW `vw_monthly_requests` AS SELECT DATE_FORMAT(created_at,'%Y-%m') AS month,COUNT(*) AS total FROM service_requests GROUP BY DATE_FORMAT(created_at,'%Y-%m');

CREATE OR REPLACE VIEW `vw_site_traffic` AS SELECT visit_date,SUM(sessions) AS sessions FROM site_visits GROUP BY visit_date;
