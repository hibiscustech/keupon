class DealsController < ApplicationController

  include AuthenticatedSystemMerchant
  layout 'application_merchant'

  before_filter :login_required , :only => [:index, :active_deal, :activate]

  def active_deal
    id=params[:id]
    @page = "Deal activation & Preview "
    @deal=Deal.find(params[:id])
    ds = @deal.deal_schedule
    start_time = ds.start_time
    @end_time = ds.end_time
    st_arr = Time.at(start_time).strftime("%Y-%m-%d").split("-")
    et_arr = Time.at(@end_time).strftime("%Y-%m-%d").split("-")
    @days_left = (Date.new(et_arr[0].to_i,et_arr[1].to_i,et_arr[2].to_i)-Date.new(st_arr[0].to_i,st_arr[1].to_i,st_arr[2].to_i)).to_i+1
    @company = @deal.merchant.merchant_profile.company if !@deal.blank?
    @map = GMap.new("map")
    @map.control_init(:large_map => true, :map_type => true)
    @map.center_zoom_init([@deal.deal_location_detail.longitude,@deal.deal_location_detail.latitude],8)
    @map.overlay_init(GMarker.new([@deal.deal_location_detail.longitude,@deal.deal_location_detail.latitude] ))
    @deal_scale_xml = Deal.deal_scale_graph(@deal.deal_discounts, Deal.deals_bought(@deal.id), "price_black_bg")
    #render :layout => 'activation'
  end

  def activate
    id=params[:id]
    @deal = Deal.find(params[:id])
    @deal.update_attributes(:activated => "1")
    flash[:notice] = "Your Deal is now Active and will be Opened on #{Time.at(@deal.deal_schedule.start_time).strftime("%d-%m-%Y")}"
    redirect_to '/index'
  end

  def save_commission
    deal = Deal.find(params[:id])

    params[:commission].each_pair do |key,value|
      discount=DealDiscount.find(key)
      discount.update_attribute(:commission,value[0])
    end
  end

  def get_deal_details
    deal_id=params[:id]
    @flag=true
    @discount_details=DealDiscount.find_all_by_deal_id(deal_id)
  end

  def get_by_email
  end

  def get_deals_by_email
   keupon_subscriber=KeuponSubscribers.create(params[:keupon_subscribers])
   if params[:category]
    params[:category].each do |cat|
     SubscribedDeals.create(:keupon_subscriber_id=>keupon_subscriber.id,:deal_category_id=>cat)
    end
   end
   flash[:notice]='Your request has been submitted to site admin'
   redirect_to "/"
  end

  def index
    @page = 'New Deal'
    @deal = (params[:id].blank?)? Deal.new : Deal.find(params[:id])
    @categories = DealCategory.find(:all)
    session[:deal_discounts] = Hash.new
  end
  def edit
    @page = 'Edit Deal'
    @deal = (params[:id].blank?)? Deal.new : Deal.find(params[:id])
    @deal_location=DealLocationDetail.find_by_deal_id(@deal.id)
    @deal_discounts=DealDiscount.find_all_by_deal_id(@deal.id)
    @categories = DealCategory.find(:all)
  #  session[:deal_discounts] = 
  end

  
  def new_discount_customers
    if request.xml_http_request?
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'discount_summary',:partial => "new_deal_discount"
          end
        }
      end
    end
  end

  def add_new_deal_discount
    discount = params[:discount]
    customers = params[:customer]
    max_customers = params[:max_customer]
    session[:deal_discounts][discount.to_f] = [customers, max_customers]
    @deal_scale_xml = deal_scale_graph(session[:deal_discounts].sort)
    if request.xml_http_request?
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'dd_check', "&nbsp;<input type='hidden' name='ddcheckdis' value='abcdef' id='ddcheckdis' />"
            page.replace_html 'minimum_customer', "<input type='text' name='customer1' value='#{(max_customers.to_i+1).to_s}' disabled/><input type='hidden' name='customer' id='customer' value='#{(max_customers.to_i+1).to_s}'/>"
            page.replace_html 'maximum_customer', "<input type='text' name='max_customer' id='max_customer' />"
            page.replace_html 'disc', "<input type='text' name='discount' id='discount' />"
            page.replace_html 'min_discount', "<input type='hidden' name='minimum_discount' id='minimum_discount' value='#{discount}'/>"
            page.replace_html 'minimum_customer_heading', "Minimum Customers"
            page.replace_html 'dd_operator', :partial => "deal_discount_form"
            page.replace_html 'dd_form_create', "<a href='#dd_table' onclick='return form_validator1(#{discount});return false;'><img src='/images/create1.jpg' border='0'/></a>"
            if params["operator"] == "greater"
              page.replace_html 'dd_table', "<input type='hidden' name='no_of_discounts' id='no_of_discounts' value='#{session[:deal_discounts].length}' />"
            end
            page.replace_html 'discount_summary',:partial => "deal_discount_summary"            
          end
        }
      end
    end
  end

  def deal_discount_operator
    if request.xml_http_request?
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            if params[:operator] == "lesser"
              page.replace_html 'minimum_customer', "<input type='hidden' name='customer' id='customer' value='0'/>"
              page.replace_html 'minimum_customer_heading', ""
              page.replace_html 'maximum_customer', "<input type='text' name='max_customer' id='max_customer' />"
            elsif params[:operator] == "greater"
              page.replace_html 'minimum_customer', "<input type='text' name='customer' id='customer' />"
              page.replace_html 'minimum_customer_heading', "Minimum Customers"
              page.replace_html 'maximum_customer', "<input type='text' name='max_customer_a' id='max_customer_a' value='Any Number' disabled/><input type='hidden' name='max_customer' id='max_customer' value='' /> "
            else
              page.replace_html 'minimum_customer', "<input type='text' name='customer' id='customer' />"
              page.replace_html 'minimum_customer_heading', "Minimum Customers"
              page.replace_html 'maximum_customer', "<input type='text' name='max_customer' id='max_customer' />"
            end
          end
        }
      end
    end
    return nil
  end

  def deal_discount_operator1
    if request.xml_http_request?
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            if params[:operator] == "greater"
              page.replace_html 'maximum_customer', "<input type='text' name='max_customer_a' id='max_customer_a' value='Any Number' disabled/><input type='hidden' name='max_customer' id='max_customer' value='' /> "
            else
              page.replace_html 'maximum_customer', "<input type='text' name='max_customer' id='max_customer' />"
            end
          end
        }
      end
    end
    return nil
  end

  def deal_scale_graph(deal_discounts)
    minimum = deal_discounts[0][1][0]
    deals_bought = minimum
    maximum = (deal_discounts[deal_discounts.length-1][1][1].blank?)? (deal_discounts[deal_discounts.length-2][1][1].to_i)+20 : deal_discounts[deal_discounts.length-1][1][1]
    maximum_text = (deal_discounts[deal_discounts.length-1][1][1].blank?)? "Any" : deal_discounts[deal_discounts.length-1][1][1]
    customers_discount_ranges = "<colorRange>"
    prev_max_customers = nil
    for dd in deal_discounts
      min_customers = dd[1][0]
      max_customers = (dd[1][1].blank?)? min_customers.to_i+20 : dd[1][1]
      discount = dd[0]
      current_min_customers = (prev_max_customers.blank?)? min_customers : prev_max_customers
      customers_discount_ranges += "<color minValue='#{current_min_customers}' maxValue='#{max_customers}' code='c41111' borderColor='ffffff' label='#{discount}%'/>"
      prev_max_customers = max_customers
    end
    customers_discount_ranges += "</colorRange><pointers><pointer value='#{deals_bought}' bgColor='FFFFFF' radius='5' toolText='Keupons Bought: #{deals_bought}'/></pointers>"
    return "<chart bgSWF='/images/gray_bg.jpg' borderColor='DCCEA1' chartTopMargin='0' chartBottomMargin='0' ticksBelowGauge='1' tickMarkDistance='3' valuePadding='-2' majorTMColor='000000' majorTMNumber='3' minorTMNumber='4' minorTMHeight='4' majorTMHeight='8' showShadow='0' gaugeBorderThickness='3' baseFontColor='000000' gaugeFillMix='{color},{FFFFFF}' gaugeFillRatio='50,50' upperLimitDisplay='#{maximum_text}' upperLimit='#{maximum}' lowerLimit='#{minimum}'>#{customers_discount_ranges}<styles><definition><style name='limitFont' type='Font' bold='1'/><style name='labelFont' type='Font' bold='1' size='10' color='FFFFFF'/><style name='TTipFont' type='Font' color='FFFFFF' bgColor='000000' borderColor='000000'/></definition><application><apply toObject='GAUGELABELS' styles='labelFont'/><apply toObject='LIMITVALUES' styles='limitFont'/><apply toObject='TOOLTIP' styles='TTipFont'/></application></styles></chart>"
  end

  def cancel_new_discount_customers
    if request.xml_http_request?
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'discount_summary',:partial => "deal_discount_summary"
          end
        }
      end
    end
  end

  def create_step2
    deal_discounts = session[:deal_discounts].sort
    @deal = Deal.find(params[:deal_id])
    min_customers = nil
    max_customers = nil
    buy = nil
    save_amount = nil
    discount = nil

    for dd in deal_discounts
      buy = @deal.value.to_f - @deal.value.to_f*dd[0].to_f/100
      save_amount = @deal.value.to_f - buy.to_f
      discount = dd[0]
      min_customers = dd[1][0]
      max_customers = dd[1][1]
      DealDiscount.create(:deal_id => params[:deal_id], :discount => discount, :customers => min_customers, :max_customers => max_customers, :buy_value => buy, :save_amount => save_amount)
    end
    @deal.update_attributes(:minimum_number => min_customers, :number => max_customers, :buy => buy, :save_amount => save_amount, :discount => discount)
    session[:deal_discounts] = nil
    redirect_to "/deals_of_mine"
  end

  def new
    @deal = Deal.new
  end

  def create
    merchant_profile = current_merchant.merchant_profile
    @deal = Deal.new(params[:deal])
    @deal.expiry_date = Time.parse(params[:deal][:expiry_date]).to_i
    @deal.deal_category_id = merchant_profile.deal_category_id
    @deal.deal_sub_category_id = merchant_profile.deal_sub_category_id
    if params[:deal][:deal_type_id]
      @deal.deal_type_id = params[:deal][:deal_type_id]
    else
      @deal.deal_type_id = 1
    end

    if @deal.save!
      deal_location = DealLocationDetail.new(:deal_id => @deal.id, :address1 => params[:address1], :address2 => params[:address2], :state => params[:country], :city => params[:country], :zipcode => params[:zipcode])
      get_lat_lng(deal_location)
      deal_location.save!
      deal_schedule = DealSchedule.new(:deal_id => @deal.id, :start_time => Time.parse("#{params[:start_date]} 00:00:00").to_i.to_s, :end_time => Time.parse("#{params[:end_date]} 23:59:59").to_i.to_s)
      deal_schedule.save!
      if @deal.preferred.to_s == "1"
        AdminMailer.deliver_merchant_created_preferred_deal(@deal, merchant_profile, merchant_profile.company)
      end

      deal_discounts = session[:deal_discounts].sort
      min_customers = nil
      max_customers = nil
      buy = nil
      save_amount = nil
      discount = nil

      for dd in deal_discounts
        buy = @deal.value.to_f - @deal.value.to_f*dd[0].to_f/100
        save_amount = @deal.value.to_f - buy.to_f
        discount = dd[0]
        min_customers = dd[1][0]
        max_customers = dd[1][1]
        DealDiscount.create(:deal_id => @deal.id, :discount => discount, :customers => min_customers, :max_customers => max_customers, :buy_value => buy, :save_amount => save_amount)
      end
      @deal.update_attributes(:minimum_number => min_customers, :number => max_customers, :buy => buy, :save_amount => save_amount, :discount => discount)
      session[:deal_discounts] = nil
      flash[:notice] = "Deal Created Successfully."
      redirect_to "/index"
    end
  end
 def update
    merchant_profile = current_merchant.merchant_profile
    @deal = Deal.find(params[:id])
    @deal.update_attribute(:expiry_date,Time.parse(params[:deal][:expiry_date]).to_i)
    @deal.deal_category_id = merchant_profile.deal_category_id
    @deal.deal_sub_category_id = merchant_profile.deal_sub_category_id
    @deal.update_attributes(:name=>params[:deal][:name],:rules=>params[:deal][:rules],:highlights=>params[:deal][:highlights],:value=>params[:deal][:value])
    if params[:deal][:deal_type_id]
      @deal.deal_type_id = params[:deal][:deal_type_id]
    else
      @deal.deal_type_id = 1
    end

      deal_location = DealLocationDetail.find_by_deal_id(@deal.id)
      deal_location.update_attributes(:deal_id => @deal.id, :address1 => params[:address1], :address2 => params[:address2], :state => params[:country], :city => params[:country], :zipcode => params[:zipcode])
      get_lat_lng(deal_location)
      deal_schedule = DealSchedule.find_by_deal_id(@deal.id)
      deal_schedule.update_attributes(:deal_id => @deal.id, :start_time => Time.parse("#{params[:start_date]} 00:00:00").to_i.to_s, :end_time => Time.parse("#{params[:end_date]} 23:59:59").to_i.to_s)
      if @deal.preferred.to_s == "1"
        AdminMailer.deliver_merchant_created_preferred_deal(@deal, merchant_profile, merchant_profile.company)
      end
      redirect_to "/index"
  end


  def view_basic_info
    @deal = Deal.find(params[:deal])
    #@deal = {"name" => deal.name, "highlights" => deal.highlights, "rules" => deal.rules}
    @deal_category = Deal.category_name(@deal.id)
    if request.xml_http_request?
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'view_deal',:partial => "deal_info"
          end
        }
      end
    end
  end

  def view_create_deal
    @deal = Deal.new
    @categories = DealCategory.find(:all)
    if request.xml_http_request?
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'create_deal',:partial => "create_deal"
          end
        }
      end
    end
  end

  def sub_categories
    @sub_categories = DealSubCategory.find_by_sql("select * from deal_sub_categories where deal_category_id = '#{params[:category]}'")
    if request.xml_http_request?
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'sub_cats',:partial => "deal_sub_categories"
          end
        }
      end
    end
  end

  

  private

  def all_merchants_result(merchants)
    result = Hash.new
    for merchant in merchants
      year, month, day = Time.at(merchant.start_time.to_i).strftime("%Y-%m-%d").split("-")
      result[day.to_i.to_s] = {"company_name" => merchant.company_name, "deal_id" => merchant.deal_id}
    end
    return result
  end
end
