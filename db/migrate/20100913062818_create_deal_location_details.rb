class CreateDealLocationDetails < ActiveRecord::Migration
  def self.up
  execute %Q(

          CREATE TABLE `deal_location_details` (
          `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
          `deal_id` int(11) unsigned NOT NULL,
          KEY `deal_id` (`deal_id`),
          `address1` varchar(50),
          `address2` varchar(50),
          `city` varchar(30),
          `state` varchar(30) ,
          `zipcode` varchar(10),
          `latitude` varchar(50),
          `longitude` varchar(50),
           PRIMARY KEY (`id`),
          CONSTRAINT `dld _ibfk_1` FOREIGN KEY (`deal_id`) REFERENCES `deals` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
          ) ENGINE=InnoDB;

 )
  end

  def self.down
    drop_table :deal_location_details
  end
end
