class AlterCustomersAndCustomerFriends < ActiveRecord::Migration
  def self.up
    execute %Q{ ALTER TABLE `customer_friends` ADD COLUMN `used` ENUM('1','0') DEFAULT 0 }
    execute %Q{ ALTER TABLE `customers` ADD COLUMN `balance_credit` INT(11) UNSIGNED }
  end

  def self.down
  end
end
