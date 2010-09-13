class CreateDealTypes < ActiveRecord::Migration
  def self.up

    execute %Q(
           CREATE TABLE `deal_types` (
          `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
          `name` varchar(50) NOT NULL,
           PRIMARY KEY (`id`)
          ) ENGINE=InnoDB;
    )


  end

  def self.down
    drop_table :deal_types
  end
end
