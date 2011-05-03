class AddBuyUrlToDeals < ActiveRecord::Migration
  def self.up
    execute %Q{ ALTER TABLE `deals` ADD COLUMN `buy_url` VARCHAR(255) }
  end

  def self.down
  end
end
