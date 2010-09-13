class DealCategory < ActiveRecord::Base
  has_many :deal, :dependent => :destroy
  has_one :customer_favourite_deal, :dependent => :destroy
  has_many :deal_sub_category
end
