class DealCategory < ActiveRecord::Base
  has_many :deal, :dependent => :destroy
  has_one :customer_favourite_deal, :dependent => :destroy
  has_many :deal_sub_category

  def self.all_deal_categories
    DealCategory.find(:all)
  end
end
