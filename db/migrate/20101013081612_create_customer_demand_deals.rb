class CreateCustomerDemandDeals < ActiveRecord::Migration
  def self.up
    execute %Q{
            CREATE TABLE `customer_demand_deals` (
            `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
            `expected_value` double not null,
            `number` int(11) not null,
            `deadline` int(11) not null,
            `description` text,
            `status` enum('new','offered','cancelled','accepted') not null default 'new',
            `time_created` int(11) not null,
            `customer_id` int(11) unsigned NOT NULL,
            `deal_category_id` int(11) unsigned NOT NULL,
            `deal_sub_category_id` int(11) unsigned NOT NULL,
            `deal_id` int(11) unsigned default null,
            PRIMARY KEY (`id`),
            KEY `deal_category_id` (`deal_category_id`),
            KEY `deal_sub_category_id` (`deal_sub_category_id`),
            KEY `customer_id` (`customer_id`),
            KEY `deal_id` (`deal_id`),
            CONSTRAINT `cd_deal_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
            CONSTRAINT `cd_deal_ibfk_2` FOREIGN KEY (`deal_id`) REFERENCES `deals` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
            CONSTRAINT `cd_deal_ibfk_3` FOREIGN KEY (`deal_category_id`) REFERENCES `deal_categories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
            CONSTRAINT `cd_deal_ibfk_4` FOREIGN KEY (`deal_sub_category_id`) REFERENCES `deal_sub_categories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
            ) ENGINE=InnoDB
      }
  end

  def self.down
    drop_table :customer_demand_deals
  end
end
