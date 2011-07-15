class Deal < ActiveRecord::Base

  has_many :customer_deals
  has_many :deal_discounts
  has_one :customer_accepted_demand_deal_bidding
  has_many :customers, :through => :customer_deals
  has_many :first_customers, :class_name => 'MerchantsCustomer', :foreign_key => 'first_deal'
  has_many :recent_customers, :class_name => 'MerchantsCustomer', :foreign_key => 'recent_deal'

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


  DISCOUNTS = ["50", "55", "60", "65", "70", "75", "80", "85", "90", "95"]

  def self.deals_bought(deal_id)
    query = %Q{ select sum(case when cd.quantity is null then 0 else cd.quantity end) no_of_customers from deals d left outer join customer_deals cd on cd.deal_id = d.id where d.id = #{deal_id}}
    no_of_customers = find_by_sql(query)[0]
    return (no_of_customers.blank?)? 0 : no_of_customers.no_of_customers
  end

  def self.deals_to_open
    query = %Q{ select d.id, ds.start_time
                from deals d
                join deal_schedules ds on ds.deal_id = d.id
                where d.status = 'new' and d.activated = '1' and d.confirm = '1'}

    return find_by_sql(query)
  end
  
  def self.all_hot_deals
    query = %Q{ select d.id, d.name, sum(case when cd.quantity is null then 0 else cd.quantity end) no_of_customers, d.discount, d.value as actual_value, d.save_amount, ds.end_time
                from deals d
                join deal_schedules ds on ds.deal_id = d.id
                left outer join customer_deals cd on cd.deal_id = d.id
                where d.status = 'open' and preferred = '1' and admin_preferred = '1'
                group by d.id
                order by no_of_customers desc}
    resultset = find_by_sql(query)
    resultset_hashed = convert_into_hash(resultset)
    deal_discounts = deals_and_current_discounts(resultset)
    return deal_discounts, resultset_hashed
  end

  def self.hottest_deal_of_today
    query = %Q{ select d.id, d.name, sum(case when cd.quantity is null then 0 else cd.quantity end) no_of_customers, d.discount, d.buy
                from deals d
                left outer join customer_deals cd on cd.deal_id = d.id
                where d.status = 'open' and preferred = '1' and admin_preferred = '1'
                group by d.id
                order by no_of_customers desc limit 1}
    hotest_deal = find_by_sql(query)[0]
    if !hotest_deal.blank?
      deal_discount_details = DealDiscount.deal_current_discount_details(hotest_deal.id, hotest_deal.no_of_customers)
      hotest_deal.discount = deal_discount_details.discount
      hotest_deal.buy = deal_discount_details.buy_value
    end
    return hotest_deal
  end

  def self.all_hot_and_open_deals_for_summary(conditions)
    query = %Q{ select d.id, d.name, d.status, d.value as actual_value, ds.end_time, sum(case when cd.quantity is null then 0 else cd.quantity end) no_of_customers, dld.address1, dld.address2, dld.city, dld.state, dld.zipcode, d.discount, d.value as actual_value, d.save_amount
                from deals d
                join deal_schedules ds on ds.deal_id = d.id
                join deal_location_details dld on dld.deal_id = d.id
                left outer join customer_deals cd on cd.deal_id = d.id
                where d.status = 'open' #{conditions}
                group by d.id
                order by ds.start_time }
    resultset = find_by_sql(query)
    resultset_hashed = convert_into_hash(resultset)
    deal_discounts = deals_and_current_discounts(resultset)
    return deal_discounts, resultset_hashed
  end

  def self.all_hot_and_open_deals_for_subscribers(merchant_ids)
    query = %Q{ select d.id, d.name, d.status, d.value as actual_value, ds.end_time, sum(case when cd.quantity is null then 0 else cd.quantity end) no_of_customers, dld.address1, dld.address2, dld.city, dld.state, dld.zipcode, d.discount, d.value as actual_value, d.save_amount
                from deals d
                join deal_schedules ds on ds.deal_id = d.id
                join deal_location_details dld on dld.deal_id = d.id
                left outer join customer_deals cd on cd.deal_id = d.id
                where d.status = 'open' and d.merchant_id in (#{merchant_ids})
                group by d.id
                order by ds.start_time }
    resultset = find_by_sql(query)
    resultset_hashed = convert_into_hash(resultset)
    deal_discounts = deals_and_current_discounts(resultset)
    return deal_discounts, resultset_hashed
  end

  def self.all_hot_and_open_deals
    query = %Q{ select d.id, d.name, d.status, d.value as actual_value, ds.end_time, sum(case when cd.quantity is null then 0 else cd.quantity end) no_of_customers, dld.address1, dld.address2, dld.city, dld.state, dld.zipcode, d.discount, d.value as actual_value, d.save_amount
                from deals d
                join deal_schedules ds on ds.deal_id = d.id
                join deal_location_details dld on dld.deal_id = d.id
                left outer join customer_deals cd on cd.deal_id = d.id
                where d.status = 'open'
                group by d.id
                order by ds.start_time }
    resultset = find_by_sql(query)
    resultset_hashed = convert_into_hash(resultset)
    deal_discounts = deals_and_current_discounts(resultset)
    return deal_discounts, resultset_hashed
  end


  def self.all_and_open_deals
    query = %Q{ select d.id, d.name, d.status, d.value as actual_value, ds.end_time, sum(case when cd.quantity is null then 0 else cd.quantity end) no_of_customers, dld.address1, dld.address2, dld.city, dld.state, dld.zipcode, d.discount, d.value as actual_value, d.save_amount
                from deals d
                join deal_schedules ds on ds.deal_id = d.id
                join deal_location_details dld on dld.deal_id = d.id
                left outer join customer_deals cd on cd.deal_id = d.id
                where d.status = 'open'
                group by d.id
                order by ds.start_time LIMIT 5}
    resultset = find_by_sql(query)
    resultset_hashed = convert_into_hash(resultset)
    deal_discounts = deals_and_current_discounts(resultset)
    return deal_discounts, resultset_hashed
  end

  def self.all_activated_deals
    query = %Q{ select d.id, d.name, d.status, d.value as actual_value,ds.start_time, ds.end_time, sum(case when cd.quantity is null then 0 else cd.quantity end) no_of_customers, dld.address1, dld.address2, dld.city, dld.state, dld.zipcode, d.discount, d.value as actual_value, d.save_amount, d.preferred, d.admin_preferred, d.confirm 
                from deals d
                join deal_schedules ds on ds.deal_id = d.id
                join deal_location_details dld on dld.deal_id = d.id
                left outer join customer_deals cd on cd.deal_id = d.id
                where d.activated = '1'
                group by d.id
                order by ds.start_time }
    resultset = find_by_sql(query)
    resultset_hashed = convert_into_hash(resultset)
    deal_discounts = deals_and_current_discounts(resultset)
    return deal_discounts, resultset_hashed
  end

  def self.all_deals
    query = %Q{ select d.id, d.activated,d.name, d.status, d.value as actual_value,ds.start_time, ds.end_time, sum(case when cd.quantity is null then 0 else cd.quantity end) no_of_customers, dld.address1, dld.address2, dld.city, dld.state, dld.zipcode, d.discount, d.value as actual_value, d.save_amount, d.preferred, d.admin_preferred, d.confirm
                from deals d
                join deal_schedules ds on ds.deal_id = d.id
                join deal_location_details dld on dld.deal_id = d.id
                left outer join customer_deals cd on cd.deal_id = d.id
                group by d.id
                order by ds.start_time }
    resultset = find_by_sql(query)
    resultset_hashed = convert_into_hash(resultset)
    deal_discounts = deals_and_current_discounts(resultset)
    return deal_discounts, resultset_hashed
  end

  def self.all_open_deals
    query = %Q{ select d.id, d.name, d.value as actual_value, ds.end_time, sum(case when cd.quantity is null then 0 else cd.quantity end) no_of_customers, d.discount, d.value as actual_value, d.save_amount
                from deals d
                join deal_schedules ds on ds.deal_id = d.id
                left outer join customer_deals cd on cd.deal_id = d.id
                where d.status = 'open' and admin_preferred != '1'
                group by d.id
                order by ds.start_time }
    resultset = find_by_sql(query)
    resultset_hashed = convert_into_hash(resultset)
    deal_discounts = deals_and_current_discounts(resultset)
    return deal_discounts, resultset_hashed
  end

  def self.all_recent_deals
    query = %Q{ select id from deals where status = 'tipped'}
    find_by_sql(query)
  end

  def self.category_name(deal_id)
    query = %Q{ SELECT concat(dc.name,'(',ds.name,')') as category
                from deals d
                join deal_sub_categories ds on d.deal_sub_category_id = ds.id
                join deal_categories dc on dc.id = ds.deal_category_id
                where d.id = #{deal_id} }
    find_by_sql(query)[0].category
  end

  def self.todays_deal
    sdate = Time.parse("#{Time.zone.now.year}-#{Time.zone.now.month}-#{Time.zone.now.day} 00:00:00").to_i.to_s

    query = %Q{ select end_time, deal_id from deal_schedules where start_time = '#{sdate}'}
    deal = find_by_sql(query)[0]
    return (deal.blank?)? nil : [Deal.find(deal.deal_id), deal.end_time]
  end


  def self.recents_deal
    sdate = Time.parse("#{Time.zone.now.year}-#{Time.zone.now.month}-#{Time.zone.now.day} 00:00:00").to_i.to_s
    query_schedule = DealSchedule.find :all, :conditions => ["start_time < ?", sdate ]
    query = Deal.find(:all , :conditions => ["id in(?)", query_schedule.collect{|x|x.deal_id} ] )
    return query
  end

  def self.merchants_deals(merchant_id)
    query = %Q{ select d.activated, d.id, d.discount, d.value as actual_value, d.save_amount, d.name, d.buy, d.status, ds.start_time, ds.end_time, d.expiry_date, sum(case when cd.quantity is null then 0 else cd.quantity end) no_of_customers, dld.address1, dld.address2, dld.city, dld.state, dld.zipcode
                from merchants m
                join deals d on d.merchant_id = m.id
                join deal_types dt on dt.id = d.deal_type_id
                join deal_schedules ds on ds.deal_id = d.id
                join deal_location_details dld on dld.deal_id = d.id
                left outer join customer_deals cd on cd.deal_id = d.id
                where merchant_id = #{merchant_id} and d.deal_type_id = 1
                group by d.id
                order by ds.start_time }
    resultset = find_by_sql(query)
    resultset_hashed = convert_into_hash(resultset)
    deal_discounts = deals_and_scales(resultset)
    return deal_discounts, resultset_hashed
  end
  
  def self.keupoint_deals(merchant_id)
    query = %Q{ select d.id, d.name, d.buy, d.value, d.discount, d.status, d.expiry_date, sum(case when cd.quantity is null then 0 else cd.quantity end) no_of_customers, d.keupoints_required
                from merchants m
                join deals d on d.merchant_id = m.id
                left outer join customer_deals cd on cd.deal_id = d.id
                where merchant_id = #{merchant_id} and d.deal_type_id = 4
                group by d.id }
                
    find_by_sql(query)                
  end

  def self.gift_deals(merchant_id)
    query = %Q{ select d.id, d.name, d.buy, d.value, d.discount, d.status, d.expiry_date, sum(case when cd.quantity is null then 0 else cd.quantity end) no_of_customers
                from merchants m
                join deals d on d.merchant_id = m.id
                left outer join customer_deals cd on cd.deal_id = d.id
                where merchant_id = #{merchant_id} and d.deal_type_id = 5
                group by d.id }

    find_by_sql(query)
  end
  
  def self.available_keupoint_deals(keupoints)
    query = %Q{ select d.id, d.name
                from deals d 
                where d.deal_type_id = 4 and d.keupoints_required <= #{keupoints} and status = 'open' and expiry_date > #{Time.zone.now.to_i} }
                
    find_by_sql(query)
  end

  def self.keupoint_deal(id)
    query = %Q{ select d.id, d.start_date, d.expiry_date, c.address1, c.address2, c.city, c.zipcode, d.name, rules, highlights, buy, discount, save_amount, c.id as company_id, c.name as company_name, c.website
                from deals d
                join merchant_profiles mp on mp.merchant_id = d.merchant_id
                join companies c on c.merchant_profile_id = mp.id
                where d.id = #{id} }
    find_by_sql(query)[0]
  end

  def self.my_keupons(customer)
    query = %Q{ SELECT d.id,d.name, cd.purchase_date, d.expiry_date, deal_code, cd.status, cd.id as customer_deal_id
                FROM customer_deals cd
                join deals d on d.id = cd.deal_id
                where cd.customer_id = #{customer} }
    find_by_sql(query)
  end

  def self.my_keupons_statistics(customer)
    query1 = %Q{ select count(*) as available from customer_deals where customer_id = #{customer} and status = 'available'}
    available = find_by_sql(query1)[0].available

    query2 = %Q{ select count(*) as used from customer_deals where customer_id = #{customer} and status = 'used'}
    used = find_by_sql(query2)[0].used

    query3 = %Q{ select count(*) as expired from customer_deals cd join deals d on d.id = cd.deal_id where customer_id = #{customer} and d.expiry_date < #{Time.zone.now.to_i}}
    expired = find_by_sql(query3)[0].expired

    return {"available" => available, "used" => used, "expired" => expired, "keupoints" => nil, "all" => (available.to_i+used.to_i+expired.to_i)}
  end

  def self.accounting
    query = %Q{ select d.id, d.expiry_date, ds.start_time as posting_date, ds.end_time as closing_date, c.name as merchant_name, d.name as title, d.value as actual_price, sum(case when cd.quantity is null then 0 else cd.quantity end) purchased
                from deals d
                join deal_schedules ds on ds.deal_id = d.id
                join merchant_profiles mp on mp.merchant_id = d.merchant_id
                join companies c on c.merchant_profile_id = mp.id
                left outer join customer_deals cd on cd.deal_id = d.id
                group by d.id }
    resultset = find_by_sql(query)
    result = Hash.new

    for res in resultset
      deal_discount_details = DealDiscount.deal_current_discount_details(res.id, res.purchased)
      discount = 0.0
      commission = 0.0
      sales = 0.0
      net_sales = 0.0
      if !deal_discount_details.blank?
        discount = deal_discount_details.discount.to_f
        commission = deal_discount_details.commission.to_f
        sales = res.actual_price.to_f*res.purchased.to_f
        net_sales = sales*(1.0-(discount.to_f/100.to_f))*(1.0-(commission.to_f/100.to_f))
      end
      result[res.id.to_s] = {"expiry_date" => res.expiry_date.to_i, "posting_date" => res.posting_date.to_i, "closing_date" => res.closing_date.to_i,
                              "merchant_name" => res.merchant_name, "title" => res.title, "actual_price" => res.actual_price.to_f, "purchased" => res.purchased.to_i,
                              "discount" => discount, "commission" => commission, "sales" => sales, "net_sales" => net_sales}
    end
    return result
  end

  def self.accounting_for_merchant(merchant_id)
    query = %Q{ select d.id, d.expiry_date, ds.start_time as posting_date, ds.end_time as closing_date, c.name as merchant_name, d.name as title, d.value as actual_price, sum(case when cd.quantity is null then 0 else cd.quantity end) purchased
                from deals d
                join deal_schedules ds on ds.deal_id = d.id
                join merchant_profiles mp on mp.merchant_id = d.merchant_id
                join companies c on c.merchant_profile_id = mp.id
                left outer join customer_deals cd on cd.deal_id = d.id
                where d.merchant_id = #{merchant_id}
                group by d.id }
    resultset = find_by_sql(query)
    result = Hash.new

    for res in resultset
      deal_discount_details = DealDiscount.deal_current_discount_details(res.id, res.purchased)
      discount = 0.0
      commission = 0.0
      sales = 0.0
      net_sales = 0.0
      if !deal_discount_details.blank?
        discount = deal_discount_details.discount.to_f
        commission = deal_discount_details.commission.to_f
        sales = res.actual_price.to_f*res.purchased.to_f
        net_sales = sales*(1.0-(discount.to_f/100.to_f))*(1.0-(commission.to_f/100.to_f))
      end
      result[res.id.to_s] = {"expiry_date" => res.expiry_date.to_i, "posting_date" => res.posting_date.to_i, "closing_date" => res.closing_date.to_i,
                              "merchant_name" => res.merchant_name, "title" => res.title, "actual_price" => res.actual_price.to_f, "purchased" => res.purchased.to_i,
                              "discount" => discount, "commission" => commission, "sales" => sales, "net_sales" => net_sales}
    end
    return result
  end

  def self.convert_into_hash(resultset)
    result = Hash.new
    for res in resultset
      result[res.id.to_s] = res
    end
    return result
  end

  def self.deals_and_current_discounts(resultset)
    result = Hash.new
    for res in resultset
      discount = DealDiscount.deal_current_discount(res.id, res.no_of_customers)
      result[res.id.to_s] = discount.to_f
    end
    return result.sort{|l,r| r[1]<=>l[1]}
  end
  
  def self.deals_and_scales(resultset)
    result = Hash.new
    for res in resultset
      deal_discounts = DealDiscount.find_by_sql("select * from deal_discounts where deal_id = #{res.id} order by discount")
      image = "gray_bg"
      dd_scale = deal_scale_graph(deal_discounts, res.no_of_customers, image)
      result[res.id.to_s] = dd_scale
    end
    return result
  end

  def self.deal_scale_graph(deal_discounts, deals_bought, image)
    minimum = deal_discounts[0].customers
    maximum = (deal_discounts[deal_discounts.length-1].max_customers.blank?)? (deal_discounts[deal_discounts.length-2].max_customers.to_i)+20 : deal_discounts[deal_discounts.length-1].max_customers
    maximum_text = (deal_discounts[deal_discounts.length-1].max_customers.blank?)? "Any" : deal_discounts[deal_discounts.length-1].max_customers
    customers_discount_ranges = "<colorRange>"
    prev_max_customers = nil
    for dd in deal_discounts
      min_customers = dd.customers
      max_customers = (dd.max_customers.blank?)? min_customers.to_i+20 : dd.max_customers
      discount = dd.discount
      current_min_customers = (prev_max_customers.blank?)? min_customers : prev_max_customers
      customers_discount_ranges += "<color minValue='#{current_min_customers}' maxValue='#{max_customers}' code='c41111' borderColor='ffffff' label='#{discount}%'/>"
      prev_max_customers = max_customers
    end
    customers_discount_ranges += "</colorRange><pointers><pointer value='#{deals_bought}' bgColor='FFFFFF' radius='5' toolText='Keupons Bought: #{deals_bought}'/></pointers>"
    return "<chart showValue='1' bgSWF='/images/#{image}.jpg' borderColor='DCCEA1' chartTopMargin='0' chartBottomMargin='0' ticksBelowGauge='1' valuePadding='-2' majorTMColor='000000' minorTMHeight='4' majorTMHeight='8' showShadow='0' gaugeBorderThickness='3' baseFontColor='000000' gaugeFillMix='{color},{FFFFFF}' gaugeFillRatio='50,50' upperLimitDisplay='#{maximum_text}' upperLimit='#{maximum}' lowerLimit='#{minimum}' lowerLimitDisplay='#{minimum}' forceTickValueDecimals='0'>#{customers_discount_ranges}<styles><definition><style name='limitFont' type='Font' bold='1'/><style name='labelFont' type='Font' bold='1' size='10' color='FFFFFF'/><style name='TTipFont' type='Font' color='FFFFFF' bgColor='000000' borderColor='000000'/></definition><application><apply toObject='GAUGELABELS' styles='labelFont'/><apply toObject='LIMITVALUES' styles='limitFont'/><apply toObject='TOOLTIP' styles='TTipFont'/></application></styles></chart>"
  end

  def self.find_recent_add(merchant_id)
    query = %Q{ select * from deals where merchant_id = #{merchant_id} order by id desc limit 1}
    return find_by_sql(query)[0]
  end

   def self.save_csv(upload)
    name =  upload['upfile']
    directory = "public"
    # create the file path
    path = File.join(directory, name)
    # write the file
    File.open(path, "wb") { |f| f.write(upload['upfile'].read) }
  end

end
