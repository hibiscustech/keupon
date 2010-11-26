class AddNewColumnToDealDiscounts < ActiveRecord::Migration
  def self.up
    execute %Q{ ALTER TABLE `deal_discounts` ADD COLUMN `max_customers` INT(11) UNSIGNED AFTER `customers`}

    execute %Q{ ALTER TABLE `deals` ADD COLUMN `minimum_number` INT(11) UNSIGNED AFTER `save_amount`}

    execute %Q{ ALTER TABLE `deals` DROP COLUMN `commission`,
                ADD COLUMN `preferred` ENUM('1','0') NOT NULL DEFAULT '0' AFTER `keupoints_required`}
  end

  def self.down
  end
end
