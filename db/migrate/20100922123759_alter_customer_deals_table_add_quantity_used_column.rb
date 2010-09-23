class AlterCustomerDealsTableAddQuantityUsedColumn < ActiveRecord::Migration
  def self.up
    execute %Q{ ALTER TABLE `customer_deals` ADD COLUMN `quantity_used` INT(11) UNSIGNED NOT NULL DEFAULT 0 AFTER `deal_code`}
  end

  def self.down
  end
end
