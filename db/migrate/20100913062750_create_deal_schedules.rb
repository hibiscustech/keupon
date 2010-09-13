class CreateDealSchedules < ActiveRecord::Migration
  def self.up
   execute %Q(

          CREATE TABLE `deal_schedules` (
          `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
          `deal_id` int(11) unsigned NOT NULL,
          `start_time` int(11) unsigned NOT NULL,
          `end_time` int(11) unsigned NOT NULL,
          PRIMARY KEY (`id`),
          KEY `deal_id` (`deal_id`),
          CONSTRAINT `dealsch_ibfk_1` FOREIGN KEY (`deal_id`) REFERENCES `deals` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
          ) ENGINE=InnoDB;

    )
  end

  def self.down
    drop_table :deal_schedules
  end
end
