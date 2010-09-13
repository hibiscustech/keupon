class CreateCustomerDealTransactions < ActiveRecord::Migration
  def self.up
    execute %Q(
            CREATE TABLE `customer_deal_transactions` (
            `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
            `time_created` int(11) NOT NULL,
            `transaction_type` enum('Preauth','Postauth') NOT NULL,
            `customer_credit_card_id` int(11) unsigned NOT NULL,
            `amount` double NOT NULL,
            `customer_deal_id` int(11) unsigned NOT NULL,
            `error_message` text,
            `message` text,
            `status` enum('success','failure'),
            `transaction_key` varchar(255) default NULL,
            `payment_type` enum('Direct','Reference') not null default 'Reference',
            PRIMARY KEY  (`id`),
            KEY `customer_credit_card_id` (`customer_credit_card_id`),
            KEY `customer_deal_id` (`customer_deal_id`),
            CONSTRAINT `cdt_ibfk_1` FOREIGN KEY (`customer_credit_card_id`) REFERENCES `customer_credit_cards` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
            CONSTRAINT `cdt_ibfk_2` FOREIGN KEY (`customer_deal_id`) REFERENCES `customer_deals` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
          ) ENGINE=InnoDB ;
    )
  end

  def self.down
    drop_table :customer_deal_transactions
  end
end
