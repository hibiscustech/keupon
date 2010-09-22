class Deal < ActiveRecord::Base


  has_many :customer_deals
  has_many :customers, :through => :customer_deals


  belongs_to :merchant
  belongs_to :deal_type
  belongs_to :deal_category
  belongs_to :deal_sub_category
  
  has_one :deal_schedule
  has_one :deal_location_detail

  has_attached_file :deal_photo,
    :styles => {
      :thumb=> "100x100#",
      :small  => "150x150>" }


  DISCOUNTS = {"80 %" => "80",
    "70 %" => "70",
    "60 %" => "60",
    "50 %" => '50'}

  def self.category_name(deal_id)
    query = %Q{ SELECT concat(dc.name,'(',ds.name,')') as category
                from deals d
                join deal_sub_categories ds on d.deal_sub_category_id = ds.id
                join deal_categories dc on dc.id = ds.deal_category_id
                where d.id = #{deal_id} }
    find_by_sql(query)[0].category
  end

  def self.todays_deal
    sdate = Time.parse("#{Time.now.year}-#{Time.now.month}-#{Time.now.day} 00:00:00").to_i.to_s

    query = %Q{ select deal_id from deal_schedules where start_time = '#{sdate}'}
    deal = find_by_sql(query)[0]
    return (deal.blank?)? nil : Deal.find(deal.deal_id)
  end
end
