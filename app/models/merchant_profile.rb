class MerchantProfile < ActiveRecord::Base
    belongs_to :merchant
    has_one :company

  def self.all_active_merchants
    query = %Q{ select c.name as company, c.website, c.logo, concat(mp.first_name,' ',mp.last_name) as merchant_name, contact_number, email_address
                from merchant_profiles mp
                join companies c on c.merchant_profile_id = mp.id
                where mp.merchant_id is not null and status = 'active' }
    find_by_sql(query)
  end

  def self.all_new_merchants
    query = %Q{ select c.name as company, c.website, c.logo, concat(mp.first_name,' ',mp.last_name) as merchant_name, contact_number, email_address
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
end
