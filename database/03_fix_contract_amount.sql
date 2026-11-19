-- Correctif du schéma Contracts : ajoute la colonne attendue aux bases existantes.
SET @amani_contract_amount_exists = (
  SELECT COUNT(*) FROM information_schema.columns
  WHERE table_schema = DATABASE() AND table_name = 'contracts' AND column_name = 'amount'
);
SET @amani_contract_malformed_exists = (
  SELECT COUNT(*) FROM information_schema.columns
  WHERE table_schema = DATABASE() AND table_name = 'contracts' AND column_name = 'amouaussi nt'
);

SET @amani_contract_amount_sql = IF(
  @amani_contract_amount_exists = 0 AND @amani_contract_malformed_exists > 0,
  'ALTER TABLE contracts CHANGE COLUMN `amouaussi nt` amount DECIMAL(13,2) DEFAULT 0',
  IF(
    @amani_contract_amount_exists = 0,
    'ALTER TABLE contracts ADD COLUMN amount DECIMAL(13,2) DEFAULT 0 AFTER end_date',
    'SELECT 1'
  )
);
PREPARE amani_contract_amount FROM @amani_contract_amount_sql;
EXECUTE amani_contract_amount;
DEALLOCATE PREPARE amani_contract_amount;
