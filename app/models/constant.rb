class Constant < ActiveRecord::Base
  
  def self.dollar_to_keupoint_convertion
    query = %Q{ select value from constants where name = 'keupoint'}
    find_by_sql(query)[0].value.to_f
  end

  def self.get_admin_email_id
    query = %Q{select value from constants where name = 'support_email_id'}
    find_by_sql(query)[0].value
  end

  def self.get_show_deal_code
    query = %Q{select value from constants where name = 'show_deal_code'}
    find_by_sql(query)[0].value
  end

  def self.get_earn_value
    query = %Q{select value from constants where name = 'earn'}
    find_by_sql(query)[0].value
  end

  def self.get_invitees
    query = %Q{select value from constants where name = 'invitees'}
    find_by_sql(query)[0].value
  end
end
