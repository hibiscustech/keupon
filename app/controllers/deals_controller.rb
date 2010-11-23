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

  def new
    @deal = Deal.new
  end

  def create
    merchant_profile = current_merchant.merchant_profile
    deal = Deal.new(params[:deal])
    deal.expiry_date = Time.parse(params[:deal][:expiry_date].gsub('/','-')).to_i
    deal.start_date = Time.parse(params[:deal][:start_date].gsub('/','-')).to_i  if params[:deal][:start_date]
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
      if params[:deal][:deal_type_id] 
        deal_location = DealLocationDetail.new(params[:deal_location_detail])
        deal_location.deal_id = deal.id
        get_lat_lng(deal_location,params[:deal_location_detail])
        deal_location.save!
      else
        deal_schedule = DealSchedule.new(:deal_id => deal.id, :start_time => Time.parse("#{params[:start_time]} 00:00:00").to_i.to_s, :end_time => Time.parse("#{params[:start_time]} 23:59:59").to_i.to_s)
        deal_schedule.save!
      end
      if params[:deal][:deal_type_id]
        redirect_to "/location_deals"
      else
        redirect_to "/deals/index"
      end
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
