class CustomerCreditCard < ActiveRecord::Base
  belongs_to :customer

  has_many :customer_deal_transaction
end
