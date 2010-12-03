class AlterCustomerFriends < ActiveRecord::Migration
  def self.up
	execute %Q{ALTER TABLE `customer_friends` CHANGE COLUMN `signed_up?` `signed_up` enum('1','0') collate utf8_unicode_ci NOT NULL default '0'}
  end

  def self.down
  end
end
