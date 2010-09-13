class CreateCustomerDeals < ActiveRecord::Migration
  def self.up
   execute %Q(
          CREATE TABLE `customer_deals` (
          `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
          `customer_id` int(11) unsigned NOT NULL,
          `deal_id` int(11) unsigned NOT NULL,
          `quantity` int(11) unsigned NOT NULL,
 PRIMARY KEY (`id`),
          KEY `deal_id` (`deal_id`),
          KEY `customer_id` (`customer_id`),
          CONSTRAINT `cds _ibfk_1` FOREIGN KEY (`deal_id`) REFERENCES `deals` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
          CONSTRAINT `cds _ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
          ) ENGINE=InnoDB;
    )
  end

  def self.down
    drop_table :customer_deals
  end
end
