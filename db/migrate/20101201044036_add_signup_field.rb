class AddSignupField < ActiveRecord::Migration
  def self.up
    execute %Q{ ALTER TABLE `customer_friends` ADD COLUMN `signed_up?` ENUM('1','0') NOT NULL DEFAULT '0'}

  end

  def self.down
  end
end
