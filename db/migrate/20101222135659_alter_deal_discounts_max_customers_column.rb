class AlterDealDiscountsMaxCustomersColumn < ActiveRecord::Migration
  def self.up
    execute %Q{ALTER TABLE `deal_discounts` MODIFY COLUMN `max_customers` INT(11) UNSIGNED DEFAULT NULL}
  end

  def self.down
  end
end
