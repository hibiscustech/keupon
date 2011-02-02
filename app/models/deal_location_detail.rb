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

  def self.location_deal(id)
    query = %Q{ select d.id, d.start_date, d.expiry_date, dld.address1, dld.address2, dld.city, dld.zipcode, dld.latitude, dld.longitude, d.name, rules, highlights, buy, discount, save_amount, c.id as company_id, c.name as company_name, c.website
                from deal_location_details dld
                join deals d on d.id = dld.deal_id
                join merchant_profiles mp on mp.merchant_id = d.merchant_id
                join companies c on c.merchant_profile_id = mp.id
                where d.id = #{id} }
    find_by_sql(query)[0]
  end

  def self.near_by_deals(latitude, longitude, max_kms)
    query = %Q{
      select d.id,dld.deal_id,d.name, c.name as company_name, dld.address1,dld.latitude, dld.longitude,dld.address2, dld.city, dld.zipcode, (6371*(2*(atan2(sqrt(sin(radians(dld.latitude-#{latitude})/2) * sin(radians(dld.latitude-#{latitude})/2) + cos(radians(#{latitude})) * cos(radians(dld.latitude)) * sin(radians(dld.longitude-#{longitude})/2) * sin(radians(dld.longitude-#{longitude})/2)), sqrt(1-(sin(radians(dld.latitude-#{latitude})/2) * sin(radians(dld.latitude-#{latitude})/2) + cos(radians(#{latitude})) * cos(radians(dld.latitude)) * sin(radians(dld.longitude-#{longitude})/2) * sin(radians(dld.longitude-#{longitude})/2))))))) as distance
      from deal_location_details dld
      join deals d on dld.deal_id = d.id
      join merchant_profiles mp on mp.merchant_id = d.merchant_id
      join companies c on c.merchant_profile_id = mp.id
      having  distance > 0 and distance <= #{max_kms}
    }
    find_by_sql(query)
  end
end
