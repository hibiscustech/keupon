class AlterDealDiscounts < ActiveRecord::Migration
  def self.up
    execute %Q{ ALTER TABLE `deals` MODIFY COLUMN `buy` DOUBLE DEFAULT NULL}
    execute %Q{ ALTER TABLE `deals` MODIFY COLUMN `save_amount` DOUBLE DEFAULT NULL}
    execute %Q{ ALTER TABLE `deal_discounts` ADD COLUMN `buy_value` DOUBLE NOT NULL AFTER `customers`}
    execute %Q{ ALTER TABLE `deal_discounts` ADD COLUMN `save_amount` DOUBLE NOT NULL AFTER `customers`}
  end

  def self.down
  end
end
