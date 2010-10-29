class AddValuesConstant < ActiveRecord::Migration
  def self.up
         execute %Q{ INSERT INTO constants (name,value) VALUES ('admin_email_id', 'akshay@keupons.com'),('keupoint','1'); }
  end

  def self.down
  end
end
