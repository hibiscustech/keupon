class AlterMerchantProfilesNullValues < ActiveRecord::Migration
  def self.up
     execute %Q{  ALTER TABLE `merchant_profiles` MODIFY COLUMN `gender` ENUM('m','f') CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT 'm',
 MODIFY COLUMN `address1` VARCHAR(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
 MODIFY COLUMN `city` VARCHAR(30) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
 MODIFY COLUMN `state` VARCHAR(30) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
 MODIFY COLUMN `zipcode` VARCHAR(10) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL; }
    
    execute %Q{ ALTER TABLE `companies` MODIFY COLUMN `detail` TEXT CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL; }

    execute %Q{ALTER TABLE `merchant_profiles` ADD COLUMN `status` ENUM('new','active','invalid') NOT NULL DEFAULT 'new' AFTER `country`;}
  end

  def self.down
  end
end
