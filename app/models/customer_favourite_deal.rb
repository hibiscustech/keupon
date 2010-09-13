class CustomerFavouriteDeal < ActiveRecord::Base
  belongs_to :customer
  belongs_to :deal_category
  belongs_to :deal_sub_category
end
