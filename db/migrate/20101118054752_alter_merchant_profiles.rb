class AlterMerchantProfiles < ActiveRecord::Migration
  def self.up
   add_column :merchant_profiles,:merchant_pin,:string
  end

  def self.down
   remove_column :merchant_profiles,:merchant_pin
  end
end
