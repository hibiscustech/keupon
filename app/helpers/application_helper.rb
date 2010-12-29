# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def author(id)
   customer=Customer.find(id)
   customer.customer_profile.first_name
  end
  def confirmed_deal(id)
   deal=Deal.find(id)
   if deal.confirm!='1'
    true
   else
    false
   end
  end
  def get_marketing_message
    messages=MarketingMessage.find(:all).collect{|mar| mar.message}
    return messages[rand(messages.length)]
  end

  def deal_details(deal_id)
    @discount_details=DealDiscount.find_all_by_deal_id(deal_id)
  end

  def deal_current_discount(deal_id, no_of_customers)
    return DealDiscount.deal_current_discount(deal_id, no_of_customers)
  end

  def current_deal_discount_for_deal(deal_id)
    return DealDiscount.current_deal_discount_for_deal(deal_id)
  end

  def sort_td_class_helper(param)
    result = "<img src='/images/up_arrow.png' width='15' height='8' />'" if params[:sort] == param
    result = "<img src='/images/down_arrow.png' width='15' height='8' />'" if params[:sort] == param + "_reverse"
    return result
  end

  def sort_table_header(text, param, action, page)
    key = param
    key += "_reverse" if params[:sort] == param
    options = {
        :url => {:action => action, :params => params.merge({:sort => key, :page => page})}
    }
    html_options = {
      :title => "Sort by #{text}",
      :href => url_for(:action => action, :params => params.merge({:sort => key, :page => page}))
    }
    link_to_remote(text, options, html_options)
  end

  def my_age(dob)
    return (dob.blank?or(dob='0000-00-00'))? "-" : Customer.birthdate_to_age(Time.parse(dob)).to_s
  end
  
  def state_select_for(model)
    states = %w(AL AR AZ CA CO CT DC DE FL GA HI IA ID IL IN KS KY LA MA MD ME
                MI MN MO MS MT NC ND NE NH NJ NM NV NY OH OK OR PA RI SC SD TN
                TX UT VA VT WA WI WV WY AA AE AP AS FM GU MH MP PR PW VI)
    select(model, :state, states.map { |state| [state, state] }, {:selected => 'CA'})
  end
  
  def year_select_for(model)
    years = %w(2009 2010 2011 2012 2013 2014 2015 2016)
    select(model, :expDateYear, years.map { |expDateYear| [expDateYear, expDateYear] }, {:selected => '2012'})  
  end
  
  def month_select_for(model)
    months = %w(01 02 03 04 05 06 07 08 09 10 11 12)
    select(model, :expDateMonth, months.map { |expDateMonth| [expDateMonth, expDateMonth] }, {:selected => '01'})            
  end
  
    def start_year_select_for(model)
    years = %w(2009 2010 2011 2012 2013 2014 2015 2016)
    select(model, :startDateYear, years.map { |startDateYear| [startDateYear, startDateYear] }, {:selected => '2009'})  
  end
  
  def start_month_select_for(model)
    months = %w(01 02 03 04 05 06 07 08 09 10 11 12)
    select(model, :startDateMonth, months.map { |startDateMonth| [startDateMonth, startDateMonth] }, {:selected => '01'})            
  end
  
   def day_select_for(model)
    day = %w(01 02 03 04 05 06 07 08 09 10 11 12 13 14 15
                   16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31)
    select(model, :expDateDay, day.map { |expDateDay| [expDateDay, expDateDay] }, {:selected => '01'})            
  end
  
  def currency_select_for(model)
    currencies = %w(USD SGD)
    select(model, :currency, currencies.map { |currency| [currency, currency] }, {:selected => 'USD'})     
  end
end
