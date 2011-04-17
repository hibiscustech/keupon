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

  def self.customer_deals_from_merchant(merchant_id, deal_code)
    conditions = ""
    if !deal_code.blank?
      conditions += " and deal_code = '#{deal_code}'"
    end
    query = %Q{ select deal_id, quantity, quantity_left, deal_code, purchase_date
                from customer_deals cd
                join deals d on d.id = cd.deal_id
                where status = 'available' and d.merchant_id = '#{merchant_id}' #{conditions}}

    find_by_sql(query)
  end

end
