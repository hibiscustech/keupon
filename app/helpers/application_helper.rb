# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def deal_details(deal_id)
    @discount_details=DealDiscount.find_all_by_deal_id(deal_id)
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
