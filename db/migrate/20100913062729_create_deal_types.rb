class CreateDealTypes < ActiveRecord::Migration
  def self.up

    execute %Q(
           CREATE TABLE `deal_types` (
          `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
          `name` varchar(50) NOT NULL,
           PRIMARY KEY (`id`)
          ) ENGINE=InnoDB;
    )
    execute %Q{ insert into deal_types(name) values('Day'),('Location'),('Demand'),('Kupoint')}

  end

  def self.down
    drop_table :deal_types
  end
end
