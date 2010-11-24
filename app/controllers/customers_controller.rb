class CustomersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
 
  include AuthenticatedSystem
  protect_from_forgery :only => [:destroy]
  before_filter :login_required, :only => [:transaction_details,:save_transaction_details,:get_location_deal,:want_a_deal, :my_keupons]
  before_filter :my_keupons_stats, :except => [:new, :create]
  layout 'application'

  def index
    
  end

  def deal_of_the_day
    @page = "Hot Deals"
    @hot_deals = Deal.all_hot_deals
    @open_deals = Deal.all_open_deals
    @recent_deals = Deal.all_recent_deals
    render :layout => 'application_home'
  end

  def deal_details
    @deal, @end_time = Deal.find(params[:id])
    @company = @deal.merchant.merchant_profile.company if !@deal.blank?
    @page = "#{@deal.name}"
    render :layout => 'application_home'
  end

  def keupoint_deal
    @page = "Purchase Deal"
    @deal = Deal.find(params[:id])
    @company = @deal.merchant.merchant_profile.company if !@deal.blank?
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
       if params[:id].blank?
         @demand_deal = CustomerDemandDeal.create(:expected_value => params[:price], :number => params[:quantity], :deadline => Time.parse(params[:deadline].gsub('/','-')+" 23:59:59").to_i, :description => params[:description], :status => "new", :time_created => Time.now.to_i, :customer_id => current_customer.id, :deal_category_id => params[:category], :deal_sub_category_id => params[:sub_category])
         @demand_deals_summary = CustomerDemandDeal.customer_demand_deals_summary(current_customer.id)
         @sub_categories = DealSubCategory.find_by_sql("select * from deal_sub_categories where deal_category_id = #{@demand_deal.deal_category_id}")
         flash[:msg] = "The New Deal that you demanded has been created. 'Update' the new Deal with changes or 'Confirm' in order to receive Offerings."
         respond_to do |format|
          format.html
          format.js {
            render :update do |page|
              page.replace_html 'userform', :partial => "edit_i_want_deal_form"
              page.replace_html 'userform2', :partial => "my_demand_deals_summary"
            end
          }
         end
       else
         @demand_deal = CustomerDemandDeal.find(params[:id])
         @sub_categories = DealSubCategory.find_by_sql("select * from deal_sub_categories where deal_category_id = #{@demand_deal.deal_category_id}")
         if @demand_deal.status == "new"
           flash[:msg] = "'Update' this Demand Deal with changes or 'Confirm' in order to start receiving Offerings."
         else
           flash[:msg] = "Your Demand Deal will receive offers soon."
         end
         respond_to do |format|
          format.html
          format.js {
            render :update do |page|
              page.replace_html 'userform', :partial => "edit_i_want_deal_form"
            end
          }
         end
       end
     end
  end

  def update_or_confirm_want_a_deal
    @demand_deal = CustomerDemandDeal.find(params[:demand_deal])
    @categories = DealCategory.find(:all)
    @sub_categories = DealSubCategory.find_by_sql("select * from deal_sub_categories where deal_category_id = #{@demand_deal.deal_category_id}")
    if request.xml_http_request?
      flash[:msg] = "You have 'Updated' this demand deal request. Click on 'Confirm' to receive Offers soon."
      @demand_deal.update_attributes(:expected_value => params[:price], :number => params[:quantity], :deadline => Time.parse(params[:deadline].gsub('/','-')+" 23:59:59"), :description => params[:description], :deal_category_id => params[:category], :deal_sub_category_id => params[:sub_category])
      if params[:button_status] == "confirm"
        merchants = MerchantProfile.all_merchants_for_my_demand_deal(@demand_deal.deal_category_id, @demand_deal.deal_sub_category_id)
        for merchant in merchants
          CustomerDemandDealBidding.create(:time_created => Time.now.to_i, :merchant_id => merchant.merchant_id, :customer_demand_deal_id => @demand_deal.id)
        end
        @demand_deal.update_attributes(:status => "confirmed")
        @demand_deals_summary = CustomerDemandDeal.customer_demand_deals_summary(current_customer.id)
        flash[:msg] = "You have 'Confirmed' this demand deal request.You will receive Offers soon."
      end
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            if params[:button_status] == "confirm"
              page.replace_html 'userform2', :partial => "my_demand_deals_summary"
            end
            page.replace_html 'userform', :partial => "edit_i_want_deal_form"
          end
        }
      end
    end
  end 

  def offered_deals
    @page = "Offered Deals"
    @offerings = CustomerProfile.my_demand_deal_offerings(params[:deal])
  end

  def view_demand_deal_offer
    @bid_deal = CustomerDemandDealBidding.find(params[:id])
    if request.xml_http_request?
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'view_demand_deal',:partial => "view_demand_deal"
          end
        }
      end
    end
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
    @page = "Billing Information"
    @billing_information = CustomerCreditCard.new
    @deal = Deal.find(params[:id])
    @cards = current_customer.customer_credit_cards
  end

  def demand_deal_transaction_details
    @page = "Billing Information"
    @billing_information = CustomerCreditCard.new
    @deal = CustomerDemandDealBidding.find(params[:id])
    @cards = current_customer.customer_credit_cards
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

  def save_keupoint_deal_transaction_details
    deal = Deal.find(params[:id])

    deal_code = rand(36 ** 4 - 1).to_s(36).rjust(4, "0")+current_customer.id.to_s+deal.id.to_s+deal.merchant_id.to_s
    customer_deal = CustomerDeal.new(:deal_id =>deal.id, :customer_id => current_customer.id, :quantity => 1, :quantity_left => 1, :status => "available", :deal_code => deal_code, :purchase_date => Time.now.to_i)
    customer_deal.save!

    current_customer.kupoints = current_customer.kupoints.to_f - deal.keupoints_required
    current_customer.save!

    flash[:notice] = "Thanks for Purchasing the Deal!"
    redirect_to "/my_keupons"
  end

  def save_demand_deal_transaction_details
    demand_deal_bidding = CustomerDemandDealBidding.find(params[:customer_deal][:deal_id])
    demand_deal = demand_deal_bidding.customer_demand_deal
    customer_card_inform = nil
    if !params[:new_card].blank?
      customer_card_inform = CustomerCreditCard.new(params[:customer_credit_card])
      customer_card_inform.time_created = Time.now.to_i
      customer_card_inform.time_modified = Time.now.to_i
      customer_card_inform.expiration_year = params[:date][:year]
      customer_card_inform.expiration_month = params[:date][:month]
      customer_card_inform.save!
    else
      customer_card_inform = CustomerCreditCard.find(params[:customer_creditcard])
    end
    if customer_card_inform.save!
      deal = Deal.new(:name => demand_deal_bidding.name, :buy => demand_deal_bidding.buy_value, :value => demand_deal_bidding.actual_value,
        :discount => demand_deal_bidding.discount, :save_amount => demand_deal_bidding.savings, :number => demand_deal_bidding.number, :rules => demand_deal_bidding.rules, :highlights => demand_deal_bidding.highlights,
        :status => "new", :expiry_date => demand_deal_bidding.deal_end_date, :deal_type_id => 3, :merchant_id => demand_deal_bidding.merchant_id,
                      :deal_category_id => demand_deal.deal_category_id, :deal_sub_category_id => demand_deal.deal_sub_category_id)

      #deal.deal_photo = demand_deal_bidding.demand_deal_photo.url

      deal.save!

      total_price = deal.buy.to_f*deal.number.to_f
      deal_code = rand(36 ** 4 - 1).to_s(36).rjust(4, "0")+current_customer.id.to_s+deal.id.to_s+deal.merchant_id.to_s
      customer_deal = CustomerDeal.new(:deal_id => deal.id, :customer_id => params[:customer_credit_card][:customer_id], :quantity => deal.number, :quantity_left => deal.number, :status => "available", :deal_code => deal_code, :purchase_date => Time.now.to_i)
      customer_deal.save!

      customer_transaction = CustomerDealTransaction.new(:time_created => Time.now.to_i, :transaction_type => "Preauth", :customer_credit_card_id => customer_card_inform.id, :amount => total_price, :customer_deal_id => customer_deal.id, :payment_type => "Direct")
      customer_transaction.save!

      points_earned = Constant.dollar_to_keupoint_convertion*total_price
      CustomerKupoint.create(:customer_deal_id => customer_deal.id, :kupoints => points_earned, :time_created => Time.now.to_i, :status => "earned")
      current_customer.kupoints = current_customer.kupoints.to_f + points_earned
      current_customer.save!

      demand_deal.update_attributes(:status => "accepted")
      CustomerAcceptedDemandDealBidding.create(:customer_demand_deal_id => demand_deal.id, :customer_demand_deal_bidding_id => demand_deal_bidding.id, :deal_id => deal.id)

      flash[:notice] = "Thanks for Purchasing the Deal!"
      redirect_to "#{params[:return_to]}"
    else
      render :action => 'demand_deal_transaction_details', :id => demand_deal_bidding.id
    end
  end

  def save_transaction_details
    deal = Deal.find(params[:customer_deal][:deal_id])
    customer_card_inform = nil
    if !params[:new_card].blank?
      customer_card_inform = CustomerCreditCard.new(params[:customer_credit_card])
      customer_card_inform.time_created = Time.now.to_i
      customer_card_inform.time_modified = Time.now.to_i
      customer_card_inform.expiration_year = params[:date][:year]
      customer_card_inform.expiration_month = params[:date][:month]
      customer_card_inform.save!
    else
      customer_card_inform = CustomerCreditCard.find(params[:customer_creditcard])
    end
    if customer_card_inform.save!      
      total_price = deal.buy.to_f*params[:quantity].to_f

      customer_deal = CustomerDeal.new(:deal_id =>params[:customer_deal][:deal_id], :customer_id => params[:customer_credit_card][:customer_id], :quantity => params[:quantity], :quantity_left => params[:quantity], :purchase_date => Time.now.to_i)
      customer_deal.save!

      customer_transaction = CustomerDealTransaction.new(:time_created => Time.now.to_i, :transaction_type => "Preauth", :customer_credit_card_id => customer_card_inform.id, :amount => total_price, :customer_deal_id => customer_deal.id, :payment_type => "Direct")
      customer_transaction.save!

      if deal.deal_type_id == 2 || deal.deal_type_id == 3
        deal_code = rand(36 ** 4 - 1).to_s(36).rjust(4, "0")+current_customer.id.to_s+deal.id.to_s+deal.merchant_id.to_s
        customer_deal.update_attributes(:status => "available", :deal_code => deal_code)

        points_earned = Constant.dollar_to_keupoint_convertion*total_price
        CustomerKupoint.create(:customer_deal_id => customer_deal.id, :kupoints => points_earned, :time_created => Time.now.to_i, :status => "earned")

        current_customer.kupoints = current_customer.kupoints.to_f + points_earned
        current_customer.save!
      end

      flash[:notice] = "Thanks for Purchasing the Deal!"
      redirect_to "#{params[:return_to]}"
    else
      render :action => 'transaction_details', :id => deal.id
    end
  end

  # render new.rhtml
  def new
    @page = 'Registration'
    @customer = Customer.new
    render :layout => 'signup'
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
      render :action => 'new', :layout=> 'signup'
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
      flash[:notice] = "The Activation Process will be successfully completed only after this Profile Creation."
      redirect_to :action => 'about_me', :id => customer.id
    when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default('/')
    else 
      flash[:error]  = "We couldn't find a customer with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default('/')
    end
  end

  def location_deals
    @page = "Open Deals"
    @deals = DealLocationDetail.available_location_deals

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
      first = first[0]
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
      @map.center_zoom_init([first.longitude,first.latitude],12)
      first_deal = Deal.find(first.id)
      first_company = Company.find(first.company_id)
      @map.overlay_init(GMarker.new([first.longitude,first.latitude],:title =>"#{first.name}", 
          :info_window => %Q{ <span style='color:#FF0000;font-family:Georgia,'Times New Roman',Times,serif;font-size:18px;font-weight: normal;'>#{first.name}</span><br/><br/>
                              <div style='max-height: 50px;color:#000000;font-family:Georgia,'Times New Roman',Times,serif;font-size:18px;font-weight: normal;'>#{first.highlights}</div>
                              <div style='height: 400px; width: 690px; align: center;'>
                              <div id='user1' style='width: 530px; height: 355px; margin-left: 70px;'>
                                  <table align='left' width='100px'><tr><td>
                                  <div class='user2IMG' style='margin-top: 10px;'>
                                  <p class='for_PW' style='font-size:20px;'>#{first.company_name}</p>
                                  <p><a href='#{first.website}'><img src='#{first_company.company_photo.url}' style='width: 155px; height: 103px;'/></a></p>
                                  <p class='for_PW'><br/>#{first.address1} #{first.address2}<br />#{first.city}</p>                                      
                                  </div>
                                  </td></tr>
                                  <tr><td align='center' style='color:#FF0000;font-family:Georgia,'Times New Roman',Times,serif;font-size:18px;font-weight: normal;'>Offer only till #{Time.at(first.expiry_date.to_i).strftime('%b %d, %Y')}</td></tr>
                                  <tr>
                                  <td align='center'><a href='/get_location_deal?id=#{first.id}&lon=#{first.longitude}&lat=#{first.latitude}'><img src='/images/buy_now.jpg' style='border: 0;' /></a></td>
                                  </tr></table>
                                  <div class='cont3'>
                                      <p><img src='#{first_deal.deal_photo.url}' border='0px' style='width:304px;height:285px;'/></p>
                                      <div class='priseDisco'> &nbsp;&nbsp;S$#{first.buy} &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; #{first.discount}% &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;S$#{first.save_amount}</div>
                                  </div>
                              </div></div>} ))
      reminding.each do |deal|
        loc_deal = Deal.find(deal.id)
        loc_company = Company.find(deal.company_id)
        @map.record_init @map.add_overlay(GMarker.new([deal.longitude,deal.latitude],:title =>"#{deal.name}",
            :info_window => %Q{ <span style='color:#FF0000;font-family:Georgia,'Times New Roman',Times,serif;font-size:18px;font-weight: normal;'>#{deal.name}</span><br/><br/>
                                <div style='max-height: 50px;color:#000000;font-family:Georgia,'Times New Roman',Times,serif;font-size:18px;font-weight: normal;'>#{deal.highlights}</div>
                                <div style='height: 400px; width: 690px; align: center;'>
                                <div id='user1' style='width: 530px; height: 355px; margin-left: 70px;'>
                                  <table align='left' width='100px'><tr><td>
                                  <div class='user2IMG' style='margin-top: 10px;'>
                                  <p class='for_PW' style='font-size:20px;'>#{deal.company_name}</p>
                                  <p><a href='#{deal.website}'><img src='#{loc_company.company_photo.url}' style='width: 155px; height: 103px;'/></a></p>
                                  <p class='for_PW'><br/>#{deal.address1} #{deal.address2}<br />#{deal.city}</p>                                      
                                  </div></td></tr>
                                  <tr><td align='center' style='color:#FF0000;font-family:Georgia,'Times New Roman',Times,serif;font-size:18px;font-weight: normal;'>Offer only till #{Time.at(deal.expiry_date.to_i).strftime('%b %d, %Y')}</td></tr>
                                  <tr>
                                  <td align='center'><a href='/get_location_deal?id=#{deal.id}&lon=#{deal.longitude}&lat=#{deal.latitude}'><img src='/images/buy_now.jpg' style='border: 0;' /></a></td></tr></table>
                                  <div class='cont3'>
                                      <p><img src='#{loc_deal.deal_photo.url}' border='0px' style='width:304px;height:285px;'/></p>
                                      <div class='priseDisco'> &nbsp;&nbsp;S$#{deal.buy} &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; #{deal.discount}% &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;S$#{deal.save_amount}</div>
                                  </div>                                  
                              </div></div>} ))
      end
    
    end
  end

  def view_location_deal_info
    @deal = DealLocationDetail.location_deal(params[:id])
    @loc_deal = Deal.find(params[:id])
    @company = Company.find(@deal.company_id)
    if request.xml_http_request?
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'view_location_deal',:partial => "view_location_deal"
          end
        }
      end
    end
  end 

  def get_location_deal
    @page = 'Billing Information'
    @billing_information = CustomerCreditCard.new
    @deal = Deal.find(params[:id])
    @cards = current_customer.customer_credit_cards
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


  def about_me
    @page = 'My Profile'
    @customer_profile = CustomerProfile.find_by_customer_id(params[:id])
  end


  def my_profile
    @page = 'My Settings'
    @customer = Customer.find(current_customer.id)
    @customer_profile = @customer.customer_profile
    @cus_favourite=CustomerFavouriteDeal.find_all_by_customer_id(current_customer.id)
 end


  def settings
    @customer = Customer.find(params[:id])
    if !params[:customer].nil?
      if !params[:customer][:customer_photo].nil?
        @customer.customer_photo = params[:customer][:customer_photo]
        @customer.save
      end
     end
    @customer.update_attributes(params[:customer]) if !params[:customer].blank?
    @customer.customer_profile.update_attributes(params[:customer_profile]) if !params[:customer_profile].blank?
     redirect_to '/my_profile'
  end
  
  def profile_update
    @customer_profile = CustomerProfile.find_by_customer_id(params[:customer_favourite][:customer_id])
    customer = Customer.find_by_id(params[:customer_favourite][:customer_id])
    if @customer_profile.update_attributes(:dob => params[:customer_profile][:dob], :region => params[:customer_profile][:region],:relationship => params[:customer_profile][:relationship],
        :gender => params[:customer_profile][:gender],:income => params[:customer_profile][:income],:industry_sector_id => params[:customer_profile][:industry_sector_id],:customer_pin=> params[:customer_profile][:customer_pin])
    end
    if params[:customer_favourite_deal]
        existing_deal_categories=CustomerFavouriteDeal.find_all_by_customer_id(current_customer.id)
        existing_deal_categories.each do |cfd|
          cfd.destroy
        end
      params[:customer_favourite_deal][:deal_sub_category_id].map { |i| i.split(/:|;/) }.each do |d|
        @cus_favourite = CustomerFavouriteDeal.create(:customer_id => params[:customer_favourite][:customer_id], :deal_category_id => d[0].to_s, :deal_sub_category_id => d[1].to_s )
      end
    end
    if params[:my_profile].nil?
      customer.activate!
      flash[:notice] = "Thank you for your valuable information. Please sign in to continue."
      redirect_to '/'
    else
      flash[:notice] = "Thank you for your valuable information. Please sign in to continue."
      redirect_to '/my_profile'
    end
  end

  def my_keupons
   @page = 'My Keupons'
   @keupoint_deals = Deal.available_keupoint_deals(current_customer.kupoints)
   @my_keupons = Deal.my_keupons(current_customer.id)
  end

end
