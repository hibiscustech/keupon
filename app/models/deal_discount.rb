class DealDiscount < ActiveRecord::Base
  belongs_to :deal

  def self.deal_current_discount(deal_id, no_of_customers)
    query = %Q{ select discount from deal_discounts where deal_id = #{deal_id} and #{no_of_customers} between customers and max_customers }
    dd = find_by_sql(query)[0]
    return (dd.blank?)? "0" : dd.discount
  end
end