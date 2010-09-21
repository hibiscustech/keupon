class DealSchedule < ActiveRecord::Base
  belongs_to :deal

  def self.view_all_merchants_providing_deals_this_month(month, year)
    no_of_days = (Date.new(year.to_i,12,31).to_date<<(12-month.to_i)).day
    sdate = Time.parse("#{year}-#{month}-1 00:00:00").to_i.to_s
    edate = Time.parse("#{year}-#{month}-#{no_of_days} 23:59:00").to_i.to_s

    query = %Q{ select c.name as company_name, ds.deal_id, ds.start_time
                from deal_schedules ds
                join deals d on ds.deal_id = d.id
                join merchant_profiles mp on d.merchant_id = mp.merchant_id
                join companies c on c.merchant_profile_id = mp.id
                where ds.start_time between '#{sdate}' and '#{edate}'}
    find_by_sql(query)
  end

  def self.deal_schedule
    
  end
  
end
