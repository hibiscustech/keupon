class AddQuantityLeftToCustomerDeal < ActiveRecord::Migration
  def self.up
      execute %Q{ ALTER TABLE `customer_deals` ADD `quantity_left` INT( 11 ) NULL AFTER `quantity` }
  end

  def self.down
  end
end
