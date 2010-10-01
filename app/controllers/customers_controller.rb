class CustomersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
 
  include AuthenticatedSystem
 
  before_filter :login_required, :only => [:transaction_details,:save_transaction_details]

  def index
    
  end

  def deal_of_the_day
    #@deal_schedule = DealSchedule.deal_schedule
    @deal = Deal.todays_deal
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
      customer.activate!
      flash[:notice] = "Signup complete! Please sign in to continue."
      redirect_to '/login'
    when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default('/')
    else 
      flash[:error]  = "We couldn't find a customer with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default('/')
    end
  end

  def location_deals

    @deals = DealLocationDetail.find(:all)

    if @deals.blank?
    @map = GMap.new("map")
    @map.control_init(:large_map => true, :map_type => true)
    @map.center_zoom_init([1.3666667,103.8],12)
    @map.overlay_init(GMarker.new([1.3666667,103.8],:title =>"Singapore", :info_window =>"Singapore" ))

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
    @map.overlay_init(GMarker.new([@deals[0].longitude,@deals[0].latitude],:title =>"#{@deals[0].deal.name}", :info_window =>"Deal Name :#{@deals[0].deal.name}  <br/><br/>Description :#{@deals[0].deal.rules} <br/><br/>Value  :#{@deals[0].deal.value}, Discount  :#{@deals[0].deal.discount} <br/><br/>Start Date  :#{@deals[0].deal.start_date} Expiry Date  :#{@deals[0].deal.expiry_date} <br/> <br/> Address <br/>#{@deals[0].address1},<br/> #{@deals[0].address2},<br/> #{@deals[0].city}" ))
    reminding.each do |deal|
    @map.record_init @map.add_overlay(GMarker.new([deal.longitude,deal.latitude],:title => "#{deal.deal.name}",:info_window => "Deal Name :#{deal.deal.name}  <br/><br/>Description :#{deal.deal.rules} <br/><br/>Value  :#{deal.deal.value}, Discount  :#{deal.deal.discount} <br/> <br/>Start Date  :#{@deals[0].deal.start_date} Expiry Date  :#{@deals[0].deal.expiry_date} <br/><br/> Address <br/>#{deal.address1},<br/> #{deal.address2},<br/> #{deal.city}"))
    end
    
end


  end

end
