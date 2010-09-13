class CustomerDealTransaction < ActiveRecord::Base

  belongs_to :customer_credit_card
  belongs_to :customer_deal
end
