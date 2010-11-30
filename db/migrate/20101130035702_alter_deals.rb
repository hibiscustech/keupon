class AlterDeals < ActiveRecord::Migration
  def self.up
    execute %Q{ ALTER TABLE `deals` ADD COLUMN `confirm` ENUM('1','0') NOT NULL DEFAULT '0' AFTER `preferred`}
    execute %Q{ ALTER TABLE `deals` ADD COLUMN `activated` ENUM('1','0') NOT NULL DEFAULT '0' AFTER `preferred`}
  end

  def self.down
#   remove_column :deals,:confirm
#   remove_column :deals,:activated
  end
end
