class DealCategory < ActiveRecord::Base
  has_many :deals, :dependent => :destroy
  has_many :customer_favourite_deals, :dependent => :destroy
  has_many :deal_sub_category
  has_many :customer_demand_deals
  has_many :merchant_profiles

  def self.all_deal_categories
    DealCategory.find(:all)
  end
end
