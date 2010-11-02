class CustomerDeal < ActiveRecord::Base

  belongs_to :deal  
  belongs_to :customer   

  has_one :customer_kupoint

  has_many :customer_deal_transactions
  has_many :customer_deal_redemptions


  def self.verify_customer_deal(code, customer)
    query = %Q{ select * from customer_deals where deal_code = '#{code}' and customer_id = '#{customer}'}
    find_by_sql(query)[0]
  end

end
