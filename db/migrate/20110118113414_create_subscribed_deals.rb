class CreateSubscribedDeals < ActiveRecord::Migration
  def self.up
    create_table :subscribed_deals do |t|
      t.integer :keupon_subscriber_id
      t.integer :deal_category_id
      t.integer :deal_sub_category_id

      t.timestamps
    end
  end

  def self.down
    drop_table :subscribed_deals
  end
end
