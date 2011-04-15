class AlterCustomerDealsForShowingDealCode < ActiveRecord::Migration
  def self.up
    execute %Q{ALTER TABLE `customer_deals` ADD COLUMN `show_deal_code` ENUM('1','0') DEFAULT 0 AFTER `invitee`}
  end

  def self.down
  end
end
