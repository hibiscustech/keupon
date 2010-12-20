class AlterCustomerDealCatTable < ActiveRecord::Migration
  def self.up
    execute %Q{ALTER TABLE `customer_favourite_deals` MODIFY COLUMN `deal_sub_category_id` INT(11) UNSIGNED DEFAULT NULL}
  end

  def self.down
  end
end
