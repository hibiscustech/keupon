class AlterDiscountTable < ActiveRecord::Migration
  def self.up
   add_column :deal_discounts,:commission,:double
  end

  def self.down
   remove_column :deal_discounts,:commission
  end
end
