class AlterCustomerProfilesForAnalytics < ActiveRecord::Migration
  def self.up
    execute %Q{  ALTER TABLE `customer_profiles` ADD COLUMN `region` VARCHAR(25) AFTER `industry_sector_id`,
                 ADD COLUMN `relationship` ENUM('single', 'married', 'partner', 'separated', 'divorced', 'widowed') AFTER `region`,
                 ADD COLUMN `income` DOUBLE AFTER `relationship` }
  end

  def self.down
  end
end
