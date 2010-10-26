class DealLocationDetail < ActiveRecord::Base
  belongs_to :deal



  def self.all_deals
   find(:all)
  end

  def self.available_location_deals
    query = %Q{ select d.id, d.start_date, d.expiry_date, dld.address1, dld.address2, dld.city, dld.zipcode, dld.latitude, dld.longitude, d.name, rules, highlights, buy, discount, save_amount, c.id as company_id, c.name as company_name, c.website
                from deal_location_details dld
                join deals d on d.id = dld.deal_id
                join merchant_profiles mp on mp.merchant_id = d.merchant_id
                join companies c on c.merchant_profile_id = mp.id
                where d.expiry_date > #{Time.now.to_i}
                order by d.expiry_date }
    find_by_sql(query)
  end
end
