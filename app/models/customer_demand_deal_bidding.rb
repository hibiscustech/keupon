class CustomerDemandDealBidding < ActiveRecord::Base
  belongs_to :customer_demand_deal
  belongs_to :merchant
end
