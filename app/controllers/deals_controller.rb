class DealsController < ApplicationController

  include AuthenticatedSystemMerchant
  include Geokit::Geocoders
  layout 'application_merchant'

  before_filter :login_required , :only => [:index]
  def activate_the_deal
    id=params[:id]
    @page = "Deal activation & Preview "
    @deal=Deal.find(params[:id])
    @end_time = @deal.deal_schedule.end_time
    @company = @deal.merchant.merchant_profile.company if !@deal.blank?
    @map = GMap.new("map")
    @map.control_init(:large_map => true, :map_type => true)
    @map.center_zoom_init([@deal.deal_location_detail.longitude,@deal.deal_location_detail.latitude],8)
    @map.overlay_init(GMarker.new([@deal.deal_location_detail.longitude,@deal.deal_location_detail.latitude] ))
    render :layout => 'activation'
  end
  def activate
    id=params[:id]
    @deal=Deal.find(params[:id])
    @deal.update_attribute(:activated,1)
    redirect_to '/'
  end
  def save_commission
    params[:commission].each_pair do |key,value|
    discount=DealDiscount.find(key)
    discount.update_attribute(:commission,value[0])
    end
    redirect_to '/admins/view_all_deals'
  end
  def get_deal_details
    deal_id=params[:id]
    @flag=true
    @discount_details=DealDiscount.find_all_by_deal_id(deal_id)
  end

  def get_by_email
  end

  def get_deals_by_email
   email_deal=EmailDeal.create(params[:email_deal])
   flash[:notice]='Your request has been submitted to site admin'
   redirect_to "/"
  end

  def index
    @page = 'New Deal'
    @deal = (params[:id].blank?)? Deal.new : Deal.find(params[:id])
    @categories = DealCategory.find(:all)
    session[:deal_discounts] = Hash.new
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
            page.replace_html 'minimum_customer', "<input type='text' name='customer1' value='#{(max_customers.to_i+1).to_s}' disabled/><input type='hidden' name='customer' id='customer' value='#{(max_customers.to_i+1).to_s}'/>"
            page.replace_html 'maximum_customer', "<input type='text' name='max_customer' id='max_customer' />"
            page.replace_html 'disc', "<input type='text' name='discount' id='discount' />"
            page.replace_html 'discount_summary',:partial => "deal_discount_summary"            
          end
        }
      end
    end
  end

  def deal_scale_graph(deal_discounts)
    minimum = deal_discounts[0][1][0]
    deals_bought = minimum
    maximum = deal_discounts[deal_discounts.length-1][1][1]
    customers_discount_ranges = "<colorRange>"
    prev_max_customers = nil
    for dd in deal_discounts
      min_customers = dd[1][0]
      max_customers = dd[1][1]
      discount = dd[0]
      current_min_customers = (prev_max_customers.blank?)? min_customers : prev_max_customers
      customers_discount_ranges += "<color minValue='#{current_min_customers}' maxValue='#{max_customers}' code='c41111' borderColor='ffffff' label='#{discount}%'/>"
      prev_max_customers = max_customers
    end
    customers_discount_ranges += "</colorRange><pointers><pointer value='#{deals_bought}' bgColor='FFFFFF' radius='5' toolText='Keupons Bought: #{deals_bought}'/></pointers>"
    return "<chart bgSWF='/images/gray_bg.jpg' borderColor='DCCEA1' chartTopMargin='0' chartBottomMargin='0' ticksBelowGauge='1' tickMarkDistance='3' valuePadding='-2' majorTMColor='000000' majorTMNumber='3' minorTMNumber='4' minorTMHeight='4' majorTMHeight='8' showShadow='0' gaugeBorderThickness='3' baseFontColor='000000' gaugeFillMix='{color},{FFFFFF}' gaugeFillRatio='50,50' upperLimitDisplay='#{maximum}' lowerLimit='#{minimum}'>#{customers_discount_ranges}<styles><definition><style name='limitFont' type='Font' bold='1'/><style name='labelFont' type='Font' bold='1' size='10' color='FFFFFF'/><style name='TTipFont' type='Font' color='FFFFFF' bgColor='000000' borderColor='000000'/></definition><application><apply toObject='GAUGELABELS' styles='labelFont'/><apply toObject='LIMITVALUES' styles='limitFont'/><apply toObject='TOOLTIP' styles='TTipFont'/></application></styles></chart>"
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
    @deal.expiry_date = Time.parse(params[:deal][:expiry_date].gsub('/','-')).to_i
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
      deal_schedule = DealSchedule.new(:deal_id => @deal.id, :start_time => Time.parse("#{params[:start_date].gsub('/','-')} 00:00:00").to_i.to_s, :end_time => Time.parse("#{params[:end_date].gsub('/','-')} 23:59:59").to_i.to_s)
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
        DealDiscount.create(:deal_id => params[:deal_id], :discount => discount, :customers => min_customers, :max_customers => max_customers, :buy_value => buy, :save_amount => save_amount)
      end
      @deal.update_attributes(:minimum_number => min_customers, :number => max_customers, :buy => buy, :save_amount => save_amount, :discount => discount)
      session[:deal_discounts] = nil

      redirect_to "/index"
    end
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

  def get_lat_lng(location)
    res = MultiGeocoder.geocode("#{location.address1}, #{location.address2}, #{location.state}, #{location.zipcode}")
    location.longitude = res.lat
    location.latitude = res.lng
  end
end
