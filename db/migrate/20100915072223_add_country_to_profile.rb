class AddCountryToProfile < ActiveRecord::Migration
  def self.up
    add_column :customer_profiles, :country,    :string
    add_column :merchant_profiles, :country,    :string
  end

  def self.down
    remove_column :customer_profiles, :country
    remove_column :merchant_profiles, :country
 end
end
