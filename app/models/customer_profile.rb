class CustomerProfile < ActiveRecord::Base
  belongs_to :customer
  belongs_to :industry_sector
  REGION = ['North Singapore', 'South Singapore','East Singapore','West Singapore' ]

  RELATIONSHIP = ['Single','Married','Living with partner','Separated','Divorced','Widowed','Prefer not to share']

  INCOME = ['Under $20,000','$20,000 to 29,999','$30,000 to 39,999','$40,000 to 49,999','$50,000 to 69,999','$70,000 to 99,999','$100,000 to 149,999','$150,000 or more','Prefer not to share']

  def self.my_demand_deal_offerings(deal)
    query = %Q{ select * from customer_demand_deal_biddings where customer_demand_deal_id = #{deal} and status = 'closed'}
    find_by_sql(query)
  end
end
