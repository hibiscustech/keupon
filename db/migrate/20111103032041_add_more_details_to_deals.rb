class AddMoreDetailsToDeals < ActiveRecord::Migration
  def self.up
    add_column :deals, :more_details, :text
  end

  def self.down
    remove_column :deals, :more_details
  end
end
