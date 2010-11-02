class CreateCustomerAcceptedDemandDealBiddingsTable < ActiveRecord::Migration
  def self.up
    execute %Q{ CREATE TABLE `customer_accepted_demand_deal_biddings` (
                `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
                `customer_demand_deal_id` INT(11) UNSIGNED NOT NULL,
                `customer_demand_deal_bidding_id` INT(11) UNSIGNED NOT NULL,
                `deal_id` INT(11) UNSIGNED NOT NULL,
                PRIMARY KEY (`id`),
                INDEX `caddb_Index_2`(`customer_demand_deal_id`),
                INDEX `caddb_Index_3`(`customer_demand_deal_bidding_id`),
                INDEX `caddb_Index_4`(`deal_id`),
                CONSTRAINT `FK_customer_accepted_demand_deal_biddings_1` FOREIGN KEY `FK_customer_accepted_demand_deal_biddings_1` (`customer_demand_deal_id`)
                  REFERENCES `customer_demand_deals` (`id`)
                  ON DELETE CASCADE
                  ON UPDATE CASCADE,
                CONSTRAINT `FK_customer_accepted_demand_deal_biddings_2` FOREIGN KEY `FK_customer_accepted_demand_deal_biddings_2` (`customer_demand_deal_bidding_id`)
                  REFERENCES `customer_demand_deal_biddings` (`id`)
                  ON DELETE CASCADE
                  ON UPDATE CASCADE,
                CONSTRAINT `FK_customer_accepted_demand_deal_biddings_3` FOREIGN KEY `FK_customer_accepted_demand_deal_biddings_3` (`deal_id`)
                  REFERENCES `deals` (`id`)
                  ON DELETE CASCADE
                  ON UPDATE CASCADE
              )
              ENGINE = InnoDB }

    execute %Q{ ALTER TABLE `customer_demand_deals` DROP COLUMN `deal_id`}

    execute %Q{ insert into deal_types(name) values('Gift') }

    execute %Q{ ALTER TABLE `customer_deals` ADD COLUMN `purchase_date` INT(11) UNSIGNED AFTER `deal_code`;}
  end

  def self.down
  end
end
