class Company < ActiveRecord::Base

   belongs_to :merchant_profile

   has_attached_file :company_photo,
    :styles => {
      :thumb=> "100x100#",
      :small  => "150x150>" }

  def self.merchants_for_new_deal
    query = %Q{ select c.name as company_name, dc.name as category_name, mp.merchant_id
                from companies c left outer join merchant_profiles mp on mp.id = c.merchant_profile_id
                left outer join deal_categories dc on dc.id = mp.deal_category_id
                where merchant_id is not null}
    return find_by_sql(query)
  end
end
