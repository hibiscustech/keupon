class DealsController < ApplicationController

  include AuthenticatedSystemMerchant
  include Geokit::Geocoders
  layout 'application_merchant'

  before_filter :login_required , :only => [:index]

  def get_by_email
  end

  def get_deals_by_email
   email_deal=EmailDeal.create(params[:email_deal])
   flash[:message]='Your request has been submitted to site admin'
   redirect_to "/"
  end

  def index
    @page = 'New Deal'
    @deal = Deal.new
    @categories = DealCategory.find(:all)    
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
    session[:deal_discounts][discount.to_i] = customers
    if request.xml_http_request?
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'discount_summary',:partial => "deal_discount_summary"
            if !session[:deal_discounts].blank?
              page.replace_html 'ds_form',:partial => "deal_discount_form"
            end
          end
        }
      end
    end
  end

  def cancel_new_discount_customers
    if request.xml_http_request?
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'deal_summary',:partial => "deal_discount_summary"
          end
        }
      end
    end
  end

  def create_step2
    deal_discounts = session[:deal_discounts].sort
    for dd in deal_discounts
      DealDiscount.create(:deal_id => params[:deal_id], :discount => dd[0], :customers => dd[1])
    end
    redirect_to "/deals_of_mine"
  end

  def new
    @deal = Deal.new
  end

  def create
    merchant_profile = current_merchant.merchant_profile
    deal = Deal.new(params[:deal])
    deal.expiry_date = Time.parse(params[:deal][:expiry_date].gsub('/','-')).to_i
    deal.deal_category_id = merchant_profile.deal_category_id
    deal.deal_sub_category_id = merchant_profile.deal_sub_category_id
    if params[:deal][:deal_type_id]
      deal.deal_type_id = params[:deal][:deal_type_id]
    else
      deal.deal_type_id = 1
    end
    deal.buy = deal.value.to_f*deal.discount.to_f/100
    deal.save_amount = deal.value.to_f - deal.buy.to_f
    if deal.save!
      deal_location = DealLocationDetail.new(params[:deal_location_detail])
      deal_location.deal_id = deal.id
      get_lat_lng(deal_location,params[:deal_location_detail])
      deal_location.save!
      deal_schedule = DealSchedule.new(:deal_id => deal.id, :start_time => Time.parse("#{params[:start_date].gsub('/','-')} 00:00:00").to_i.to_s, :end_time => Time.parse("#{params[:end_date].gsub('/','-')} 23:59:59").to_i.to_s)
      deal_schedule.save!
      session[:deal_discounts] = Hash.new
      redirect_to "/deals/index"
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

  def get_lat_lng(location,deal_location_detail)
    puts "***********************For getting lat and long for address**************"
    if !params[:chk1].nil?
      res = MultiGeocoder.geocode("#{current_merchant.merchant_profile.address1},#{current_merchant.merchant_profile.address2},#{current_merchant.merchant_profile.city},#{current_merchant.merchant_profile.state},#{current_merchant.merchant_profile.country}")
    else
      res = MultiGeocoder.geocode("#{deal_location_detail[:address1]},#{deal_location_detail[:address2]},#{deal_location_detail[:city]}")
    end
    location.longitude = res.lat
    location.latitude = res.lng
  end
end
