class AlterCustomerDeals < ActiveRecord::Migration
  def self.up
        execute %Q{ ALTER TABLE `customer_deals` ADD COLUMN `invitee` ENUM('1','0') NOT NULL DEFAULT '0'}
  end

  def self.down
  end
end
