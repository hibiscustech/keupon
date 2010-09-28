class CreateCustomerDealRedemptions < ActiveRecord::Migration
  def self.up
    execute %Q{ ALTER TABLE `customer_deals` DROP COLUMN `quantity_used`}

    execute %Q(
          CREATE TABLE `customer_deal_redemptions` (
          `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
          `customer_deal_id` int(11) unsigned NOT NULL,
          `redeemed_time` int(11) unsigned NOT NULL,
          `redeemed_quantity` int(11) unsigned NOT NULL,
          PRIMARY KEY (`id`),
          KEY `customer_deal_id` (`customer_deal_id`),
          CONSTRAINT `cdrs_ibfk_1` FOREIGN KEY (`customer_deal_id`) REFERENCES `customer_deals` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
          ) ENGINE=InnoDB
    )
  end

  def self.down
    drop_table :customer_deal_redemptions
  end
end
