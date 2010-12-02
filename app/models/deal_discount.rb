class DealDiscount < ActiveRecord::Base
  belongs_to :deal

  def self.deal_current_discount(deal_id, no_of_customers)
    query = %Q{ select discount from deal_discounts where deal_id = #{deal_id} and #{no_of_customers} between customers and max_customers }
    dd = find_by_sql(query)[0]
    return (dd.blank?)? "0" : dd.discount
  end

  def self.current_deal_discount_for_deal(deal_id)
    query = %Q{ select dd.discount
                from deal_discounts dd
                where dd.deal_id = #{deal_id} and
                (select count(cd.id) as no_of_customers from deals d left outer join customer_deals cd on cd.deal_id = d.id where d.id = #{deal_id}) between customers and max_customers }
    dd = find_by_sql(query)[0]
    return (dd.blank?)? "0" : dd.discount
  end
end