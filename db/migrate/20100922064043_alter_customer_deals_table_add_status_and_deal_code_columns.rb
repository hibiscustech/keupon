class AlterCustomerDealsTableAddStatusAndDealCodeColumns < ActiveRecord::Migration
  def self.up
    #execute %Q{ ALTER TABLE `deals` MODIFY COLUMN `name` TEXT CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL }

    execute %Q{ ALTER TABLE `customer_deals` ADD COLUMN `status` ENUM('new','available','used','expired','failed') NOT NULL DEFAULT 'new' AFTER `quantity`,
                ADD COLUMN `deal_code` VARCHAR(25) NOT NULL AFTER `status` }
  end

  def self.down
  end
end
