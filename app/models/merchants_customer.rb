class MerchantsCustomer < ActiveRecord::Base
  belongs_to :merchant
  belongs_to :customer
  belongs_to :first_deal, :class_name => "Deal", :foreign_key => 'first_deal'
  belongs_to :recent_deal, :class_name => "Deal", :foreign_key => 'recent_deal'
end
