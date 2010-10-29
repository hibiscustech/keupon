class Constant < ActiveRecord::Base
  def self.dollar_to_keupoint_convertion
    query = %Q{ select value from constants where name = 'keupoint'}
    find_by_sql(query)[0].value.to_f
  end
end
