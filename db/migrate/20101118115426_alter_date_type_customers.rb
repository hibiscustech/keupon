class AlterDateTypeCustomers < ActiveRecord::Migration
  def self.up
   change_column :customer_profiles,:dob,:date
  end

  def self.down
   change_column :customer_profiles,:dob,:integer
  end
end
