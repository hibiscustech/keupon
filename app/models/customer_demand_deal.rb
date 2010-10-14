class CustomerDemandDeal < ActiveRecord::Base
  belongs_to :deal
  belongs_to :customer
  belongs_to :deal_category
  belongs_to :deal_sub_category
  
  has_many :customer_demand_deal_biddings
end
