class DealsController < ApplicationController

  include AuthenticatedSystemMerchant
  include Geokit::Geocoders

  def index
    if request.get?
      @months = { "January" => 1, "February" => 2, "March" => 3, "April" => 4, "May" => 5, "June" => 6, "July" => 7, "August" => 8,
        "September" => 9, "October" => 10, "Nevember" => 11, "December" => 12 }
      @years = [2010, 2011]
      today = Time.now
      @month = today.month
      @year = today.year
      @month_name = today.strftime("%B")

      session[:month] = @month
      session[:year] = @year
      session[:month_name] = @month_name

      @schedules = all_merchants_result(DealSchedule.view_all_merchants_providing_deals_this_month(@month, @year))
    elsif request.xml_http_request?
      @month = (params[:month].blank?)? session[:month] : params[:month].to_i
      @year = (params[:year].blank?)? session[:year] : params[:year].to_i
      @month_name = (params[:month].blank?)? session[:month_name] : Time.parse("#{@year}-#{@month}-15").strftime("%B")

      session[:month] = @month
      session[:year] = @year
      session[:month_name] = @month_name

      @schedules = all_merchants_result(DealSchedule.view_all_merchants_providing_deals_this_month(@month, @year))

      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'calendar',:partial => "calendar_deals"
          end
        }
      end
    end
  end

  def new
    @deal = Deal.new
  end

  def create
    deal = Deal.new(params[:deal])
    deal.expiry_date = Time.parse(params[:deal][:expiry_date]).to_i
    deal.start_date = Time.parse(params[:deal][:start_date]).to_i  if params[:deal][:start_date] 
    deal.deal_category_id = params[:category]
    deal.deal_sub_category_id = params[:sub_category]
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
      res = MultiGeocoder.geocode("#{deal_location_detail[:address1]},#{deal_location_detail[:address2]},#{deal_location_detail[:city]},#{deal_location_detail[:state]},#{deal_location_detail[:country]}")
    end
    location.longitude = res.lat
    location.latitude = res.lng
  end
end
