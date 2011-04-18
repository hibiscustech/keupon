class AlterDealsRulesAndHighlights < ActiveRecord::Migration
  def self.up
    execute %Q{ ALTER TABLE `deals` MODIFY COLUMN `rules` TEXT CHARACTER SET latin1 COLLATE latin1_swedish_ci,
		 MODIFY COLUMN `highlights` TEXT CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL}
  end

  def self.down
  end
end
