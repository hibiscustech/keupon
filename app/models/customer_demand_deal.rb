class CustomerDemandDeal < ActiveRecord::Base
  belongs_to :deal
  belongs_to :customer
  belongs_to :deal_category
  belongs_to :deal_sub_category
  
  has_many :customer_demand_deal_biddings

  def self.customer_demand_deals_summary(customer_id)
    query = %Q{ select cdd.id, description, expected_value, cdd.number, deadline, cdd.status, deal_id, sum(case when cddb.status='closed' then 1 else 0 end) offerings
                from customer_demand_deals cdd
                left outer join customer_demand_deal_biddings cddb on cddb.customer_demand_deal_id = cdd.id
                where customer_id = #{customer_id}
                group by cdd.id
                order by cdd.time_created desc}
    find_by_sql(query)
  end
end
