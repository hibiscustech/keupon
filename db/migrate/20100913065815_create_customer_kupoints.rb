class CreateCustomerKupoints < ActiveRecord::Migration
  def self.up

   execute %Q(

          CREATE TABLE `customer_kupoints` (
          `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
          `customer_deal_id` int(11) unsigned NOT NULL,
          `kupoints` int(11) unsigned NOT NULL,
          `time_created` int(11) unsigned NOT NULL,
          `status` enum('pending','earned','redeemed') not null default 'pending',
           PRIMARY KEY (`id`),
          KEY `customer_deal_id` (`customer_deal_id`),
          CONSTRAINT `cps _ibfk_1` FOREIGN KEY (`customer_deal_id`) REFERENCES `customer_deals` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
          ) ENGINE=InnoDB;
  )

  end

  def self.down
    drop_table :customer_kupoints
  end
end
