class CreateCustomerCreditCards < ActiveRecord::Migration
  def self.up
  execute %Q(
          CREATE TABLE `customer_credit_cards` (
          `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
          `time_created` int(11) NOT NULL,
          `time_modified` int(11) NOT NULL,
          `deleted` enum('Yes','No') NOT NULL default 'No',
          `customer_id` int(11) unsigned NOT NULL,
          `credit_card_number` varchar(50) NOT NULL,
          `expiration_month` int(11) NOT NULL,
          `expiration_year` int(11) NOT NULL,
          `card_type` varchar(25) NOT NULL,
          `address1` varchar(50) default NULL,
          `address2` varchar(50) default NULL,
          `city` varchar(50) default NULL,
          `state` varchar(50) default NULL,
          `zipcode` varchar(25) default NULL,
          `phone` varchar(25) default NULL,
          `country` varchar(50) default NULL,
          `first_name` varchar(50) default NULL,
          `last_name` varchar(50) default NULL,
          `cvv2` varchar(25) default NULL,
          PRIMARY KEY  (`id`),
          KEY `customer_id` (`customer_id`),
          CONSTRAINT `customer_credit_cards_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
        ) ENGINE=InnoDB;
    )
  end

  def self.down
    drop_table :customer_credit_cards
  end
end
