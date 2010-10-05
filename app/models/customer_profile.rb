class CustomerProfile < ActiveRecord::Base
  belongs_to :customer
  belongs_to :industry_sector
  
end
