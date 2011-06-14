class MerchantProfile < ActiveRecord::Base
    belongs_to :merchant
    belongs_to :deal_category
    belongs_to :deal_sub_category
    has_one :company

  def self.all_active_merchants
    query = %Q{ select mp.id, c.name as company_name, c.website, concat(mp.first_name,' ',mp.last_name) as merchant_name, contact_number, email_address
                from merchant_profiles mp
                join companies c on c.merchant_profile_id = mp.id
                where mp.merchant_id is not null and status = 'active' }
    find_by_sql(query)
  end

  def self.all_new_merchants
    query = %Q{ select mp.id, c.name as company_name, c.website, concat(mp.first_name,' ',mp.last_name) as merchant_name, contact_number, email_address
                from merchant_profiles mp
                join companies c on c.merchant_profile_id = mp.id
                where mp.merchant_id is null and status = 'new' }
    find_by_sql(query)
  end

  def self.merchant_counts
    query = %Q{ select
                sum(case when mp.status = 'active' then 1 else 0 end) active_merchants,
                sum(case when mp.status = 'new' then 1 else 0 end) new_merchants
                from merchant_profiles mp }
    result = find_by_sql(query)[0]
    return {"active" => result["active_merchants"], "new" => result["new_merchants"]}
  end

  def self.all_merchants_for_my_demand_deal(category, sub_category)
    query = %Q{ select merchant_id from merchant_profiles where deal_category_id = '#{category}' }
    find_by_sql(query)
  end

  def self.all_my_demand_deals(merchant)
    query = %Q{ SELECT cdd.id, cddb.id as bid_id, cdd.description, cdd.expected_value, cdd.number, cdd.deadline, cddb.status as bidding_status
                FROM customer_demand_deal_biddings cddb
                join customer_demand_deals cdd on cdd.id = cddb.customer_demand_deal_id
                where cddb.merchant_id = #{merchant} }

    find_by_sql(query)
  end

  def self.merchants_for_categories(categories)
    query = %Q{ select merchant_id from merchant_profiles where deal_category_id in (#{categories}) and status = 'active'}
    result = find_by_sql(query)
    return result.collect{|res| res.merchant_id}
  end
end
