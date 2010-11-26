class AddNewColumnToDealDiscounts < ActiveRecord::Migration
  def self.up
    execute %Q{ ALTER TABLE `deal_discounts` ADD COLUMN `max_customers` INT(11) UNSIGNED AFTER `customers`}

    execute %Q{ ALTER TABLE `deals` ADD COLUMN `minimum_number` INT(11) UNSIGNED AFTER `save_amount`}
  end

  def self.down
  end
end
