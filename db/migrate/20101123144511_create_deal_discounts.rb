class CreateDealDiscounts < ActiveRecord::Migration
  def self.up
    execute %Q{ CREATE TABLE `deal_discounts` (
                `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
                `deal_id` INT(11) UNSIGNED NOT NULL,
                `discount` INT(11) UNSIGNED NOT NULL,
                `customers` INT(11) UNSIGNED NOT NULL,
                PRIMARY KEY (`id`),
                INDEX `deal_discounts_Index_2`(`deal_id`),
                CONSTRAINT `FK_deal_discounts_1` FOREIGN KEY `FK_deal_discounts_1` (`deal_id`)
                  REFERENCES `deals` (`id`)
                  ON DELETE CASCADE
                  ON UPDATE CASCADE
              )
              ENGINE = InnoDB }

    execute %Q{ ALTER TABLE `deals` ADD COLUMN `commission` INT(11) UNSIGNED AFTER `keupoints_required`}

    execute %Q{ ALTER TABLE `deals` MODIFY COLUMN `discount` DOUBLE DEFAULT NULL;}
  end

  def self.down
  end
end
