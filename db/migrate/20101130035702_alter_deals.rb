class AlterDeals < ActiveRecord::Migration
  def self.up
    add_column :deals,:confirm,:integer,:default =>0
  end

  def self.down
   remove_column :deals,:confirm
  end
end
