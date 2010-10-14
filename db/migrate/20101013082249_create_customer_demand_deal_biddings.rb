class CreateCustomerDemandDealBiddings < ActiveRecord::Migration
  def self.up
    execute %Q{
                  CREATE TABLE `customer_demand_deal_biddings` (
                  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
                  `name` varchar(255) NOT NULL,
                  `actual_value` double not null,
                  `buy_value` double not null,
                  `savings` double not null,
                  `discount` int(11) not null,
                  `number` int(11) not null,
                  `deal_photo_file_name` varchar(255),
                  `deal_photo_content_type` varchar(255),
                  `deal_photo_file_size` int(11),
                  `rules` varchar(255),
                  `highlights` varchar(255),
                  `time_created` int(11) not null,
                  `bid_time` int(11),
                  `deal_start_date` int(11),
                  `deal_end_date` int(11),
                  `merchant_id` int(11) unsigned NOT NULL,
                  `customer_demand_deal_id` int(11) unsigned default null,
                  PRIMARY KEY (`id`),
                  KEY `merchant_id` (`merchant_id`),
                  KEY `customer_demand_deal_id` (`customer_demand_deal_id`),
                  CONSTRAINT `cddb_deal_ibfk_1` FOREIGN KEY (`merchant_id`) REFERENCES `merchants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
                  CONSTRAINT `cddb_deal_ibfk_2` FOREIGN KEY (`customer_demand_deal_id`) REFERENCES `customer_demand_deals` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
                  ) ENGINE=InnoDB
            }
  end

  def self.down
    drop_table :customer_demand_deal_biddings
  end
end
