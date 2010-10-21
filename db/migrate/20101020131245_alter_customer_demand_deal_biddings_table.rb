class AlterCustomerDemandDealBiddingsTable < ActiveRecord::Migration
  def self.up
    execute %Q{  ALTER TABLE `customer_demand_deal_biddings` MODIFY COLUMN `name` VARCHAR(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
                 MODIFY COLUMN `actual_value` DOUBLE DEFAULT NULL,
                 MODIFY COLUMN `buy_value` DOUBLE DEFAULT NULL,
                 MODIFY COLUMN `savings` DOUBLE DEFAULT NULL,
                 MODIFY COLUMN `discount` INT(11) DEFAULT NULL,
                 MODIFY COLUMN `number` INT(11) DEFAULT NULL,
                 MODIFY COLUMN `customer_demand_deal_id` INT(11) UNSIGNED NOT NULL,
                 ADD COLUMN `status` ENUM('new','closed','expired','cancelled') NOT NULL DEFAULT 'new' AFTER `customer_demand_deal_id`}

    execute %Q{  ALTER TABLE `customer_demand_deal_biddings` CHANGE COLUMN `deal_photo_file_name` `demand_deal_photo_file_name` VARCHAR(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
                 CHANGE COLUMN `deal_photo_content_type` `demand_deal_photo_content_type` VARCHAR(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
                 CHANGE COLUMN `deal_photo_file_size` `demand_deal_photo_file_size` INT(11) DEFAULT NULL;}
  end

  def self.down
  end
end
