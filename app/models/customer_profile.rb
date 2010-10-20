class CustomerProfile < ActiveRecord::Base
  belongs_to :customer
  belongs_to :industry_sector
  REGION = ['North Singapore', 'South Singapore','East Singapore','West Singapore' ]

  RELATIONSHIP = ['Single','Married','Living with partner','Separated','Divorced','Widowed','Prefer not to share']

  INCOME = ['Under $20,000','$20,000 – 29,999','$30,000 – 39,999','$40,000 – 49,999','$50,000 – 69,999','$70,000 – 99,999','$100,000 – 149,999','$150,000 or more','Prefer not to share']
end
