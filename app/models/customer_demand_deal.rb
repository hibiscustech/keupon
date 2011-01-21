class CustomerDemandDeal < ActiveRecord::Base
  belongs_to :customer
  belongs_to :deal_category
  belongs_to :deal_sub_category
  
  has_many :customer_demand_deal_biddings
  has_many :customer_accepted_demand_deal_biddings

  def self.customer_demand_deals_summary(customer_id)
    query = %Q{ select cdd.id,deal_category_id,description, expected_value, cdd.number, deadline, cdd.status, deal_id, sum(case when cddb.status='closed' then 1 else 0 end) offerings, cdd.deal_id
                from customer_demand_deals cdd
                left outer join customer_demand_deal_biddings cddb on cddb.customer_demand_deal_id = cdd.id
                where customer_id = #{customer_id}
                group by cdd.id
                order by cdd.time_created desc}
    find_by_sql(query)
  end
  def self.customer_demand_deals_confirmed_summary(customer_id)
    query = %Q{ select cdd.id,deal_category_id,description, expected_value, cdd.number, deadline, cdd.status, deal_id, sum(case when cddb.status='closed' then 1 else 0 end) offerings, cdd.deal_id
                from customer_demand_deals cdd
                left outer join customer_demand_deal_biddings cddb on cddb.customer_demand_deal_id = cdd.id
                where customer_id = #{customer_id} and cdd.status='confirmed'
                group by cdd.id
                order by cdd.time_created desc}
    find_by_sql(query)
  end
  def self.customer_demand_deals_offered_summary(customer_id)
    query = %Q{ select cdd.id,deal_category_id,description, expected_value, cdd.number, deadline, cdd.status, deal_id, sum(case when cddb.status='closed' then 1 else 0 end) offerings, cdd.deal_id
                from customer_demand_deals cdd
                left outer join customer_demand_deal_biddings cddb on cddb.customer_demand_deal_id = cdd.id
                where customer_id = #{customer_id} and cdd.status='offered'
                group by cdd.id
                order by cdd.time_created desc}
    find_by_sql(query)
  end
  def self.customer_demand_deals_accepted_summary(customer_id)
    query = %Q{ select cdd.id,deal_category_id,description, expected_value, cdd.number, deadline, cdd.status, deal_id, sum(case when cddb.status='closed' then 1 else 0 end) offerings, cdd.deal_id
                from customer_demand_deals cdd
                left outer join customer_demand_deal_biddings cddb on cddb.customer_demand_deal_id = cdd.id
                where customer_id = #{customer_id} and cdd.status='accepted'
                group by cdd.id
                order by cdd.time_created desc}
    find_by_sql(query)
  end
  def self.customer_demand_deals_new_summary(customer_id)
    query = %Q{ select cdd.id,deal_category_id,description, expected_value, cdd.number, deadline, cdd.status, deal_id, sum(case when cddb.status='closed' then 1 else 0 end) offerings, cdd.deal_id
                from customer_demand_deals cdd
                left outer join customer_demand_deal_biddings cddb on cddb.customer_demand_deal_id = cdd.id
                where customer_id = #{customer_id} and cdd.status='new'
                group by cdd.id
                order by cdd.time_created desc}
    find_by_sql(query)
  end
end
