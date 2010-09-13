class CreateDealSubCategories < ActiveRecord::Migration
  def self.up
   execute %Q(
          CREATE TABLE `deal_sub_categories` (
         `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
         `name` varchar(50) NOT NULL,
         `deal_category_id` int(11) unsigned NOT NULL,
         PRIMARY KEY (`id`),
         KEY `deal_category_id` (`deal_category_id`),
         CONSTRAINT `deal_sub_categories _ibfk_1` FOREIGN KEY (`deal_category_id`) REFERENCES `deal_categories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
         ) ENGINE=InnoDB;
  )
  end

  def self.down
    drop_table :deal_sub_categories
  end
end
