class AddPhotoCustomers < ActiveRecord::Migration
  def self.up
     execute %Q{ ALTER TABLE `customers`
                 ADD COLUMN `customer_photo_file_name` VARCHAR(255) AFTER `activated_at`,
                 ADD COLUMN `customer_photo_content_type` VARCHAR(255) AFTER `customer_photo_file_name`,
                 ADD COLUMN `customer_photo_file_size` INT(11) UNSIGNED AFTER `customer_photo_content_type` }
  end

  def self.down
  end
end
