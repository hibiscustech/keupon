class CustomersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
 
  include AuthenticatedSystem
  protect_from_forgery :only => [:destroy]
  before_filter :login_required, :only => [:transaction_details,:save_transaction_details,:get_location_deal,:want_a_deal]
  layout 'application'

  def index
    
  end

  def deal_of_the_day
    @page = "Today's Hot Deal"
    #@deal_schedule = DealSchedule.deal_schedule
    @deal = Deal.todays_deal
    puts
  end

  def recent_deals
     @page = "Recent Deals"
    #@deal_schedule = DealSchedule.deal_schedule
    @deals = Deal.recents_deal#.paginate :page => params['page'], :per_page => 6
  end

  def want_a_deal
     @page = "I Want a Deal"
     @categories = DealCategory.find(:all)
     @demand_deals_summary = CustomerDemandDeal.customer_demand_deals_summary(current_customer.id)
     if request.xml_http_request?
       CustomerDemandDeal.create(:expected_value => params[:price], :number => params[:quantity], :deadline => Time.parse(params[:deadline]+" 23:59:59"), :description => params[:description], :status => "new", :time_created => Time.now.to_i, :customer_id => current_customer.id, :deal_category_id => params[:category], :deal_sub_category_id => params[:sub_category])
       @demand_deals_summary = CustomerDemandDeal.customer_demand_deals_summary(current_customer.id)
       flash[:msg] = "The Deal that you demanded has been created. Keep Checking the 'Deals that You Demanded section' to view your deal offers."
       respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'userform', :partial => "i_want_deal_form"
            page.replace_html 'userform2', :partial => "my_demand_deals_summary"
          end
        }
      end
     end
  end

   def offered_deals
    @page = "Offered Deals"
  end

  def deal_sub_categories
    @sub_categories = DealSubCategory.find_by_sql("select * from deal_sub_categories where deal_category_id = #{params[:category]}")
    if request.xml_http_request?
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'cid_7', :partial => "deal_sub_categories"
          end
        }
      end
    end
  end

  def transaction_details
    @billing_information = CustomerCreditCard.new
    @deal = Deal.find(params[:id])
  end

  def check_transaction_quantity
    @deal = Deal.find(params[:id])
    if params[:quantity].to_i > 0
      total = @deal.buy.to_f * params[:quantity].to_f
      if request.xml_http_request?
        respond_to do |format|
          format.html
          format.js {
            render :update do |page|
              page.replace_html 'total', "$#{total}"
            end
          }
        end
      end
    else
      flash[:msg] = "Quantity cannot be 0"
      if request.xml_http_request?
        respond_to do |format|
          format.html
          format.js {
            render :update do |page|
              page.replace_html 'purchase', :partial => "purchase_detail"
            end
          }
        end
      end
    end
  end

  def save_transaction_details
    customer_card_inform = CustomerCreditCard.new(params[:customer_credit_card])
    customer_card_inform.time_created = Time.now.to_i
    customer_card_inform.time_modified = Time.now.to_i
    customer_card_inform.expiration_year = params[:date][:year]
    customer_card_inform.expiration_month = params[:date][:month]
    customer_card_inform.card_type = 'Visa'
    if customer_card_inform.save!
      customer_deal = CustomerDeal.new(:deal_id =>params[:customer_deal][:deal_id], :customer_id => params[:customer_credit_card][:customer_id], :quantity => '1')
      customer_deal.save!
      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
      redirect_to '/deal_of_the_day'
    else
      render :action => 'transaction_details'
    end
  end

  # render new.rhtml
  def new
    @customer = Customer.new
  end

  def create
    logout_keeping_session!
    @customer = Customer.new(params[:customer])
    @customer.kupoints = 0
    @customer.time_created = Time.now
    @customer.login = @customer.email
    success = @customer && @customer.save
    if success && @customer.errors.empty?
      @profile = CustomerProfile.new(params[:customer_profile])
      @profile.email_address = @customer.email
      @profile.customer = @customer
      @profile.save
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end

  def forgot_password
    if request.post?
      customer = Customer.find_by_email(params[:email])
      if !customer.nil?
        new_pwd = newpass(8)
        logger.info "----------------------------------------------------------"
        logger.info "#{new_pwd}"
        passphrase_digest = encrypted_password(new_pwd,customer.salt)
        customer.crypted_password = passphrase_digest
        customer.password = new_pwd
        customer.password_confirmation = new_pwd
        flag = customer.save!
        if flag
          flash[:notice] = "Your password has been reset and send to your mail"
          redirect_to "/"
        else
          flash[:notice] = "Your Password could not be changed."
          redirect_to :action =>"forgot_password", :controller => "customers"
        end
      else
        flash[:notice] = "Email-id doesnt exists"
        render :controller => 'customers',:action => 'forgot_password'
      end
    end
  end 

  def activate
    logout_keeping_session!
    customer = Customer.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && customer && !customer.active?
      #customer.activate!
      flash[:notice] = "Signup complete! Please sign in to continue."
      redirect_to :action => 'my_profile', :id => customer.id
    when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default('/')
    else 
      flash[:error]  = "We couldn't find a customer with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default('/')
    end
  end

  def location_deals
    @page = "Location Deals"
    @deals = DealLocationDetail.find(:all)

    if @deals.blank?
      @map = GMap.new("map")
      @map.control_init(:large_map => true, :map_type => true)
      @map.center_zoom_init([1.30426,103.85134],12)
      @map.overlay_init(GMarker.new([1.30426,103.85134],:title =>"Singapore", :info_window => "Singapore" ))
    else
      first_deal =[]
      first = first_deal.push(@deals[0])
      reminding = @deals-first
      @map = GMap.new("map")
      @map.control_init(:large_map => true, :map_type => true)
      ################## first ##########################
      #markers = [GMarker.new([1.298732,103.859501],:info_window => "152 Beach Rd.,<br/> #16-00 Gateway East,<br/> Singapore",:title => "Toshiba Asia Pacific Pte., Ltd"),
      #GMarker.new([12.9715987,77.5945627],:info_window => "Namaste",:description => "Chopoto" , :title => "Ay"),
      #GMarker.new([37.83,-90.456619],:info_window => "Bonjour",:title => "Third"),
      #]
      #markers.each do |s|
      #@map.center_zoom_init(coordinates, 4)
      #marker = GMarker.new(s)
      #@map.overlay_init(marker)
      ###################################################
      @map.center_zoom_init([@deals[0].longitude,@deals[0].latitude],12)
      @map.overlay_init(GMarker.new([@deals[0].longitude,@deals[0].latitude],:title =>"#{@deals[0].deal.name}", :info_window =>"<div style='font-size:13px;font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;'><div style='color:red;'>Deal Name :</div>#{@deals[0].deal.name}  <br/><div style='color:red;'>Description </div>:#{@deals[0].deal.rules} <div style='color:red;'>Value &nbsp;  Discount  &nbsp;  Start_date  &nbsp;  Expiry_date  </div> <div>  &nbsp; #{@deals[0].deal.value}  &nbsp;&nbsp;&nbsp; #{@deals[0].deal.discount} &nbsp;&nbsp;&nbsp;&nbsp;  #{@deals[0].deal.start_date} &nbsp;&nbsp; #{@deals[0].deal.expiry_date} </div> <br/><div style='color:red;'> Address </div>#{@deals[0].address1},#{@deals[0].address2},<br/> #{@deals[0].city} <br/><br/> <a href='/get_location_deal?id=#{@deals[0].deal_id}&lon=#{@deals[0].longitude}&lat=#{@deals[0].latitude}'><img src='/images/buy.jpg' border ='0' /></a>&nbsp;&nbsp;<a href='/'><img src='/images/cancel.jpg' border ='0' /></a></div>" ))
      reminding.each do |deal|
        @map.record_init @map.add_overlay(GMarker.new([deal.longitude,deal.latitude],:title => "#{deal.deal.name}",:info_window => "<div style='font-size:13px;font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;'><div style='color:red;'>Deal Name :</div>#{deal.deal.name}  <br/><div style='color:red;'>Description </div>:#{deal.deal.rules} <div style='color:red;'>Value &nbsp;  Discount  &nbsp;  Start_date  &nbsp;  Expiry_date  </div> <div>  &nbsp; #{deal.deal.value}, &nbsp;&nbsp;&nbsp; #{deal.deal.discount} &nbsp;&nbsp;&nbsp;&nbsp;  #{@deals[0].deal.start_date} &nbsp;&nbsp; #{@deals[0].deal.expiry_date} </div> <br/><div style='color:red;'> Address </div>#{deal.address1},#{deal.address2},<br/> #{deal.city}<br/><br/> <a href='/get_location_deal?id=#{deal.deal_id}&lon=#{deal.longitude}&lat=#{deal.latitude}'><img src='/images/buy.jpg' border ='0' /></a>&nbsp;&nbsp;<a href='/'><img src='/images/cancel.jpg' border ='0' /></a></div>"))
      end
    
    end
  end

  def get_location_deal
    @deal = Deal.find(params[:id])
    @billing_information  = CustomerCreditCard.new
    @latest_billing_information  = CustomerCreditCard.find_by_customer_id(current_customer ,:order => 'time_created DESC')
    @map = GMap.new("map")
    @map.control_init(:large_map => true, :map_type => true)
    @map.center_zoom_init([ params[:lon],params[:lat]],14)
    @map.overlay_init(GMarker.new([params[:lon],params[:lat]] ))
  end


  def check_transaction_details
    customer_card_inform = CustomerCreditCard.find_by_cvv2_and_customer_id(params[:billing_information][:cvv2],params[:customer_credit_card][:customer_id])
    if !customer_card_inform.blank?
      customer_deal = CustomerDeal.new(:deal_id =>params[:customer_deal][:deal_id], :customer_id => params[:customer_credit_card][:customer_id], :quantity => '1')
      customer_deal.save!
      flash[:notice] = "Signup complete! Please sign in to continue."
      redirect_to '/customers/location_deals'
    else
      flash[:notice] = "Please enter Correct CVV2 number"
      redirect_to "/get_location_deal?id=#{params[:customer_deal][:deal_id]}&lon=#{params[:map][:lon]}&lat=#{params[:map][:lat]}"
    end
  end


  def my_profile
    @customer_profile = CustomerProfile.find_by_customer_id(params[:id])
  end


  def profile_update
    @customer_profile = CustomerProfile.find_by_customer_id(params[:customer_favourite][:customer_id])
    customer = Customer.find_by_id(params[:customer_favourite][:customer_id])
    if @customer_profile.update_attributes(:dob => params[:customer_profile][:dob], :region => params[:customer_profile][:region],:relationship => params[:customer_profile][:relationship],
        :gender => params[:customer_profile][:gender],:income => params[:customer_profile][:income],:industry_sector_id => params[:customer_profile][:industry_sector_id])
      customer.activate!
    end
    if params[:customer_favourite_deal]
      params[:customer_favourite_deal][:deal_sub_category_id].map { |i| i.split(/:|;/) }.each do |d|
        @cus_favourite = CustomerFavouriteDeal.create(:customer_id => params[:customer_favourite][:customer_id], :deal_category_id => d[0].to_s, :deal_sub_category_id => d[1].to_s )
      end
    end
    flash[:notice] = "Thank you for your valuable information. Please sign in to continue."
    redirect_to '/'
  end

end
