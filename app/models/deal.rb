class Deal < ActiveRecord::Base
  
  belongs_to :merchant
  belongs_to :deal_type
  belongs_to :deal_category
  belongs_to :deal_sub_category
  
  has_one :deal_schedule
  has_one :deal_location_detail

  has_many :customer_deals
  has_many :customers, :through => :customer_deals

end
