class AddColumnCountryToCompanies < ActiveRecord::Migration
  def self.up
    execute %Q{ ALTER TABLE `companies` ADD COLUMN `country` VARCHAR(50) AFTER `company_photo_file_size`}
  end

  def self.down
  end
end
