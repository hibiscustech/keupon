class CreateCustomerFriends < ActiveRecord::Migration
  def self.up
    create_table :customer_friends do |t|
      t.integer :customer_id
      t.string :friend_email
      t.timestamps
    end
  end

  def self.down
    drop_table :customer_friends
  end
end
