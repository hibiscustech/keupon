class AlterMerchantProfile < ActiveRecord::Migration
  def self.up
   add_column :merchant_profiles,:referal_code,:string
   add_column :companies,:business_registration_number,:string
   add_column :companies,:deal_category_id,:integer
  end

  def self.down
   remove_column :merchant_profiles,:referal_code
   remove_column :companies,:business_registration_number
   remove_column :companies,:deal_category_id
  end
end
