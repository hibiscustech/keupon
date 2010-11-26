class AlterDealsTableAddAdminPreferred < ActiveRecord::Migration
  def self.up
    execute %Q{ ALTER TABLE `deals` ADD COLUMN `admin_preferred` ENUM('1','0') NOT NULL DEFAULT '0' AFTER `preferred`}
  end

  def self.down
  end
end
