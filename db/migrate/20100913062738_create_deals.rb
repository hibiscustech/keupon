class CreateDeals < ActiveRecord::Migration
  def self.up
   
     execute %Q(

            CREATE TABLE `deals` (
            `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
            `name` varchar(50) NOT NULL,
            `buy` double not null,
            `value` double not null,
            `discount` double not null,
            `save` double not null,
            `number` int(11),
            `rules` varchar(255),
            `highlights` varchar(255),
            `status` enum('new','open','cancelled','tipped','expired') not null default 'new',
            `expiry_date` int(11) not null,
            `deal_type_id` int(11) unsigned NOT NULL,
            `merchant_id` int(11) unsigned NOT NULL,
            `deal_category_id` int(11) unsigned NOT NULL,
            `deal_sub_category_id` int(11) unsigned NOT NULL,
            PRIMARY KEY (`id`),
            KEY `deal_category_id` (`deal_category_id`),
            KEY `deal_sub_category_id` (`deal_sub_category_id`),
            KEY `merchant_id` (`merchant_id`),
            KEY `deal_type_id` (`deal_type_id`),
            CONSTRAINT `deal_ibfk_1` FOREIGN KEY (`merchant_id`) REFERENCES `merchants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
            CONSTRAINT `deal_ibfk_2` FOREIGN KEY (`deal_type_id`) REFERENCES `deal_types` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
            CONSTRAINT `deal_ibfk_3` FOREIGN KEY (`deal_category_id`) REFERENCES `deal_categories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
            CONSTRAINT `deal_ibfk_4` FOREIGN KEY (`deal_sub_category_id`) REFERENCES `deal_sub_categories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
            ) ENGINE=InnoDB;


      )


  end

  def self.down
    drop_table :deals
  end
end
