class AlterTablesForStateAndCityNullable < ActiveRecord::Migration
  def self.up
    execute %Q{ ALTER TABLE `companies` MODIFY COLUMN `city` VARCHAR(30) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
 MODIFY COLUMN `state` VARCHAR(30) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL}

    execute %Q{ ALTER TABLE `customer_profiles` MODIFY COLUMN `city` VARCHAR(30) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
 MODIFY COLUMN `state` VARCHAR(30) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL}
  end

  def self.down
  end
end
