class AlterMerchantAndCustomerProfileTables < ActiveRecord::Migration
  def self.up
    execute %Q{  ALTER TABLE `customer_profiles` ADD COLUMN `customer_pin` VARCHAR(45) AFTER `income` }

    execute %Q{  ALTER TABLE `merchant_profiles` ADD COLUMN `deal_category_id` INT(11) UNSIGNED AFTER `status`,
                 ADD COLUMN `deal_sub_category_id` INT(11) UNSIGNED AFTER `deal_category_id`,
                 ADD INDEX `deal_category_id`(`deal_category_id`),
                 ADD INDEX `deal_sub_category_id`(`deal_sub_category_id`),
                 ADD CONSTRAINT `merchant_profiles_ibfk_2` FOREIGN KEY `merchant_profiles_ibfk_2` (`deal_category_id`)
                    REFERENCES `deal_categories` (`id`)
                    ON DELETE CASCADE
                    ON UPDATE CASCADE,
                 ADD CONSTRAINT `merchant_profiles_ibfk_3` FOREIGN KEY `merchant_profiles_ibfk_3` (`deal_sub_category_id`)
                    REFERENCES `deal_sub_categories` (`id`)
                    ON DELETE CASCADE
                    ON UPDATE CASCADE }
  end

  def self.down
  end
end
