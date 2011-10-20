class AddPriorityToDealCategories < ActiveRecord::Migration
  def self.up
    add_column :deal_categories, :priority, :integer
  end

  def self.down
    remove_column :deal_categories, :priority
  end
end
