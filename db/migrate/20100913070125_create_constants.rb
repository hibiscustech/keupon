class CreateConstants < ActiveRecord::Migration
  def self.up
   execute %Q(
           CREATE TABLE `constants` (
          `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
          `name` varchar(30) not null,
          `value` varchar(255) not null,
 PRIMARY KEY (`id`)
          ) ENGINE=InnoDB ;
   )
  end

  def self.down
    drop_table :constants
  end
end
