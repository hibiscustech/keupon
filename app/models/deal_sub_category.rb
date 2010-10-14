class DealSubCategory < ActiveRecord::Base
  has_many :deals
  has_many :customer_favourite_deals, :dependent => :destroy
  has_many :customer_demand_deals
  has_many :merchant_profiles

  belongs_to :deal_category
  
  def self.all_deal_sub_categories
    DealSubCategory.find(:all)
  end
end
