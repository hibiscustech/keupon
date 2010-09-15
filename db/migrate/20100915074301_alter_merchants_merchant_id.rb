class AlterMerchantsMerchantId < ActiveRecord::Migration
  def self.up
    execute %Q{ ALTER TABLE `merchant_profiles` MODIFY COLUMN `merchant_id` INT(11) UNSIGNED DEFAULT NULL }
  end

  def self.down
  end
end
