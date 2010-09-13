class CreateCustomerFavouriteDeals < ActiveRecord::Migration
  def self.up
    execute %Q(
            CREATE TABLE `customer_favourite_deals` (
            `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
            `customer_id` int(11) unsigned NOT NULL,
            `deal_category_id` int(11) unsigned NOT NULL,
            `deal_sub_category_id` int(11) unsigned NOT NULL,
            PRIMARY KEY (`id`),
            KEY `customer_id` (`customer_id`),
            KEY `deal_category_id` (`deal_category_id`),
            KEY `deal_sub_category_id` (`deal_category_id`),
            CONSTRAINT `cfd _ibfk_3` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
            CONSTRAINT `cfd _ibfk_1` FOREIGN KEY (`deal_category_id`) REFERENCES `deal_categories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
            CONSTRAINT `cfd _ibfk_2` FOREIGN KEY (`deal_sub_category_id`) REFERENCES `deal_sub_categories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
            ) ENGINE=InnoDB;
    )
  end

  def self.down
    drop_table :customer_favourite_deals
  end
end
