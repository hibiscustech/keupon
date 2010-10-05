class CreateMerchantsCustomers < ActiveRecord::Migration
  def self.up
    execute %Q{ CREATE TABLE `merchants_customers` (
                `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
                `merchant_id` int(11) unsigned NOT NULL,
                `customer_id` int(11) unsigned NOT NULL,
                `first_time` int(11) unsigned NOT NULL,
                `recent_time` int(11) unsigned NOT NULL,
                `first_deal` int(11) unsigned NOT NULL,
                `recent_deal` int(11) unsigned NOT NULL,
                `frequency` int(11) unsigned NOT NULL,
                PRIMARY KEY (`id`),
                KEY `merchant_id` (`merchant_id`),
                KEY `customer_id` (`customer_id`),
                KEY `first_deal` (`first_deal`),
                KEY `recent_deal` (`recent_deal`),
                CONSTRAINT `mscs_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
                CONSTRAINT `mscs_ibfk_2` FOREIGN KEY (`merchant_id`) REFERENCES `merchants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
                CONSTRAINT `mscs_ibfk_3` FOREIGN KEY (`first_deal`) REFERENCES `deals` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
                CONSTRAINT `mscs_ibfk_4` FOREIGN KEY (`recent_deal`) REFERENCES `deals` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
                ) ENGINE=InnoDB
              }
  end

  def self.down
    drop_table :merchants_customers
  end
end
