class CreateMarketingMessages < ActiveRecord::Migration
  def self.up
    create_table :marketing_messages do |t|
      t.text :message
      t.boolean :display

      t.timestamps
    end
  end

  def self.down
    drop_table :marketing_messages
  end
end
