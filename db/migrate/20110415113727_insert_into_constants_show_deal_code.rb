class InsertIntoConstantsShowDealCode < ActiveRecord::Migration
  def self.up
    execute %Q{insert into constants(name,value) values('show_deal_code',0)}
  end

  def self.down
  end
end
