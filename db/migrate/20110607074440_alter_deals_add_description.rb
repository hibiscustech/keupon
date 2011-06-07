class AlterDealsAddDescription < ActiveRecord::Migration
  def self.up
    execute %Q{ALTER TABLE `deals` ADD COLUMN `description` TEXT}
  end

  def self.down
  end
end
