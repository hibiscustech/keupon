class AddingStartDateToDeals < ActiveRecord::Migration
  def self.up
    execute %Q{ ALTER TABLE `deals` ADD `start_date` INT( 11 ) NULL AFTER `expiry_date` }
  end

  def self.down
  end
end
