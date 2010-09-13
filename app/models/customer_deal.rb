class CustomerDeal < ActiveRecord::Base

  belongs_to :deal  
  belongs_to :customer   

  has_one :customer_kupoint

  has_many :customer_deal_transaction


  

end
