class DealSubCategory < ActiveRecord::Base
  has_one :deal
  has_one :customer_favourite_deal, :dependent => :destroy
  belongs_to :deal_category
end
