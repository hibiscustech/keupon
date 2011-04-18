class InsertIntoConstantsForEarnMoney < ActiveRecord::Migration
  def self.up
    execute %Q{ insert into constants(name,value) values('earn',20),('invitees',5) }
  end

  def self.down
  end
end
