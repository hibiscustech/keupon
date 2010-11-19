class CreateEmailDeals < ActiveRecord::Migration
  def self.up
    create_table :email_deals do |t|
      t.integer :deal_category_id,:user_id
      t.string :email,:location
      t.timestamps
    end
  end

  def self.down
    drop_table :email_deals
  end
end
