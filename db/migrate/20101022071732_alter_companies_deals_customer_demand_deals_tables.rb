class AlterCompaniesDealsCustomerDemandDealsTables < ActiveRecord::Migration
  def self.up
    execute %Q{ ALTER TABLE `customer_demand_deals` MODIFY COLUMN `status` ENUM('new','offered','cancelled','accepted','confirmed') NOT NULL DEFAULT 'new'}

    execute %Q{ ALTER TABLE `deals` ADD COLUMN `keupoints_required` INT(11) UNSIGNED AFTER `deal_photo_file_size` }

    execute %Q{ ALTER TABLE `companies` DROP COLUMN `logo`,
                 ADD COLUMN `company_photo_file_name` VARCHAR(255) AFTER `merchant_profile_id`,
                 ADD COLUMN `company_photo_content_type` VARCHAR(255) AFTER `company_photo_file_name`,
                 ADD COLUMN `company_photo_file_size` INT(11) UNSIGNED AFTER `company_photo_content_type` }
  end

  def self.down
  end
end
