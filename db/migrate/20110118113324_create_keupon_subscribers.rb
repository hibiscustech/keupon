class CreateKeuponSubscribers < ActiveRecord::Migration
  def self.up
    create_table :keupon_subscribers do |t|
      t.string :email

      t.timestamps
    end
    drop_table :email_deals
  end

  def self.down
    drop_table :keupon_subscribers
  end
end
