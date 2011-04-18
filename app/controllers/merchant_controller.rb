class MerchantController < ApplicationController

  include AuthenticatedSystemMerchant
  include Geokit::Geocoders
  layout 'application_merchant'
  
  protect_from_forgery :only => [:destroy]
  before_filter :login_required , :only => [:index, :deals_of_mine, :redeem_deals,:deals_on_demand,:location_deals,:my_profile,
                                            :my_company,:password_change,:keupoint_deals,:gift_deals]
  def my_profile
    @page='Update Profile'
    @merchant = Merchant.find(current_merchant.id)
    @merchant_profile = @merchant.merchant_profile
 end
 
  def profile_update
    @merchant_profile = MerchantProfile.find_by_merchant_id(current_merchant.id)
    merchant = Merchant.find_by_id(current_merchant.id)
    if @merchant_profile.update_attributes(:gender => params[:merchant_profile][:gender],:first_name => params[:merchant_profile][:first_name],:merchant_pin=> params[:merchant_profile][:merchant_pin],:last_name => params[:merchant_profile][:last_name])
    end
      flash[:notice] = "Thank you for your valuable information. Please sign in to continue."
      redirect_to '/profile'
  end
  
  def contact_details
    @merchant_profile = MerchantProfile.find_by_merchant_id(current_merchant.id)
    @merchant_profile.update_attributes(params[:merchant_profile])
    flash[:notice] = "Thank you for your valuable information. Please sign in to continue."
    redirect_to '/profile'
  end

   def merchant_profile_update
    @merchant_profile = MerchantProfile.find(params[:merchant_profile_id][:merchant_profile_id])
    @merchant_profile.update_attributes(params[:merchant_profile])
    flash[:notice] = "Your Successfully Update"
    redirect_to '/profile'
  end

  def my_company
    @page='My Company'
    @merchant_profile = MerchantProfile.find_by_merchant_id(current_merchant.id)
    @company=@merchant_profile.company
    if request.put?
    @company.update_attributes(params[:company])
    flash[:notice] = "Thank you for your valuable information"
    redirect_to '/company'
    end
  end
  def password_change
    p params
    @page='Change password'
    @merchant = Merchant.find_by_id(current_merchant.id)
   if request.post?
        new_pwd = params[:user][:password]
        logger.info "----------------------------------------------------------"
        logger.info "#{new_pwd}"
        passphrase_digest = encrypted_password(new_pwd,@merchant.salt)
        @merchant.crypted_password = passphrase_digest
        @merchant.password = new_pwd
        @merchant.password_confirmation = new_pwd
        flag = @merchant.save!
        if flag
          flash[:notice] = "Your password has been reset"
          redirect_to "/profile"
        else
          flash[:notice] = "Something went wrong while resetting password."
          redirect_to '/profile'
        end

  end 
  end 
  def index
    @new_deal = Deal.find_recent_add(current_merchant.id)
    if !@new_deal.blank?
      discounts = @new_deal.deal_discounts
      @discounts = [discounts[0].discount, discounts[discounts.length-1].discount]
    end
    @deal_discounts, @deals = Deal.merchants_deals(current_merchant.id)
  end

  def new
    @merchant = Merchant.new
    @categories = DealCategory.find(:all)
    #render :layout =>'signup_merchant'
  end
  def preview
   
  end
  def company_sub_categories
    if params[:category] != "none"
      @sub_categories = DealSubCategory.find_by_sql("select * from deal_sub_categories where deal_category_id = #{params[:category]}")
      if request.xml_http_request?
       # respond_to do |format|
        #  format.js {
         #   render :update do |page|
             render :action => :preview
              #page.replace_html 'company_new_category', ""
              #page.replace_html 'company_sub_categories', :partial => "company_sub_categories"
          #  end
          #}
       # end
      end
    else
      if request.xml_http_request?
         render :action => :none
      #  respond_to do |format|
       #   format.html
        #  format.js {
         #   render :update do |page|
          #    page.replace_html 'company_new_category', :partial => "company_new_category"
           #   page.replace_html 'company_sub_categories', :partial => "company_new_sub_category"
           # end
         # }
        #end
      end
    end
  end

  def company_none_subcategories
    p "Divya"
    if params[:sub_category] == "none"
      if request.xml_http_request?
         render :action => :none_sub_category
        #respond_to do |format|
         # format.html
          #format.js {
           # render :update do |page|
            #  page.replace_html 'company_new_subcategory', :partial => "company_new_subcategory"
            #end
         # }
        #end
      end
    end
  end

  def deals_of_mine
    @page = 'My Deals'
    @deal_discounts, @deals = Deal.merchants_deals(current_merchant.id)
  end

  def create
    logout_keeping_session!
    @merchant_profile = MerchantProfile.new(params[:merchant_profile])
    success = @merchant_profile &&  @merchant_profile.save

    if success && @merchant_profile.errors.empty?
      @merchant_company = Company.new(params[:company])
      @merchant_company.merchant_profile = @merchant_profile
      @merchant_company.save

      res = MultiGeocoder.geocode("#{@merchant_company.address1},#{@merchant_company.address2},#{@merchant_company.city},#{@merchant_company.zipcode}")
      @merchant_company.update_attributes(:latitude => res.lat, :longitude => res.lng)

      if params[:category] != "none"
        if params[:sub_category] != "none"
          @merchant_profile.update_attributes(:deal_category_id => params[:company][:deal_category_id], :deal_sub_category_id => params[:sub_category])
        else
          @new_sub_category = DealSubCategory.create(:name => params[:new_subcategory], :deal_category_id => params[:category])
          @merchant_profile.update_attributes(:deal_category_id => params[:category], :deal_sub_category_id => @new_sub_category.id)
        end
      else
        @new_category = DealCategory.create(:name => params[:new_category])
        @new_sub_category = DealSubCategory.create(:name => params[:new_subcategory], :deal_category_id => @new_category.id)
        @merchant_profile.update_attributes(:deal_category_id => @new_category.id, :deal_sub_category_id => @new_sub_category.id)
      end
      
      MerchantMailer.deliver_merchant_registration(@merchant_profile,@merchant_company )
      AdminMailer.deliver_merchant_registration_notification(@merchant_profile,@merchant_company )

      redirect_back_or_default('/')
      flash[:notice] = "Thank You for Signing Up with us, we will get back to you after our verification."
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end

  def invalid_merchant
    merchant_profile = MerchantProfile.find(params[:id])
    merchant_profile.update_attributes(:status => "invalid")
    flash[:notice] = "Merchant: #{merchant_profile.first_name} #{merchant_profile.last_name} is Invalid!"
    redirect_to "/admins/all_merchants"
  end

  def authenticate_merchant
    merchant_profile = MerchantProfile.find(params[:id])
    password = newpass(8)
    @merchant = Merchant.new( :login => merchant_profile.email_address, :email => merchant_profile.email_address, :password => password,
      :password_confirmation => password)

    @merchant.time_created = Time.now.to_i
    @merchant.save!

    merchant_profile.update_attributes(:merchant_id => @merchant.id, :status => "active")

    MerchantMailer.deliver_merchant_authenticated(merchant_profile,@merchant, password, merchant_profile.company)    

    flash[:notice] = "Merchant: #{merchant_profile.first_name} #{merchant_profile.last_name} has been activated!  An email has been sent to #{merchant_profile.email_address}."
    redirect_to "/admins/all_merchants"    
  end

  def forgot_password
    @page = 'Forgot Password'
    if request.post?
      merchant = Merchant.find_by_email(params[:email])
      if !merchant.nil?
        new_pwd = newpass(8)
        logger.info "----------------------------------------------------------"
        logger.info "#{new_pwd}"
        passphrase_digest = encrypted_password(new_pwd,merchant.salt)        
        merchant.crypted_password = passphrase_digest
        merchant.password = new_pwd
        merchant.password_confirmation = new_pwd
        flag = merchant.save!
        CustomerMailer.deliver_forgot_password(merchant, new_pwd)
        if flag
          flash[:notice] = "Your password has been reset and send to your mail"
          redirect_to "/"
        else
          flash[:notice] = "Your Password could not be changed."
           redirect_to "/"
        end
      else
        flash[:notice] = "Email-id doesnt exists"
        redirect_to "/"
      end    
    end
  end

  def redeem_deals
    @page = 'Redeem Deals'
    flash[:notice] = nil
    @deal_code_visibility = Constant.get_show_deal_code.to_s
  end

  def verify_deal
    flash[:notice] = nil
    customer = Customer.verify_customer(params[:customer_pin])
    deal_code_visibility = Constant.get_show_deal_code.to_s
    if !customer.blank?
      if !customer.id.blank?
        @customer = Customer.find(customer.id)
        @customer_profile = @customer.customer_profile
        if deal_code_visibility == "1"
          @customer_deals = CustomerDeal.customer_deals_from_merchant(current_merchant.id.to_s, params[:code])
        else
          @customer_deals = CustomerDeal.customer_deals_from_merchant(current_merchant.id.to_s, nil)
        end
        if @customer_deals.blank?
          flash[:notice] = "No Deals brought from this Merchant"
        end
      else
        flash[:notice] = "Invalid Customer"
      end
    else
      flash[:notice] = "Invalid Customer"
    end
    if request.xml_http_request?
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'redeem_deal',:partial => "view_deals_to_redeem"
          end
        }
      end
    end
  end

  def redeem_this_deal
    deal_code_visibility = Constant.get_show_deal_code.to_s
    @customer_deal = CustomerDeal.find(params[:id])
    if request.xml_http_request?
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'redeem_deal',:partial => "redeem_this_deal"
          end
        }
      end
    end
  end

  def redeem_deal
    @redeem_deal = CustomerDeal.find(params[:id])
    if !@redeem_deal.nil?
      #equal = @redeem_deal.quantity.to_i == @redeem_deal.quantity_left.to_i
      quantity_left = (@redeem_deal.quantity_left.to_i -  params[:deal][:quantity].to_i)
      if quantity_left >= 0
        new_status = (quantity_left > 0)? "available" : "used"
        @redeem_deal.update_attributes(:status => new_status, :quantity_left => quantity_left)
        @deal_redemption = CustomerDealRedemption.create(:customer_deal_id =>@redeem_deal.id, :redeemed_time => Time.now.to_i, :redeemed_quantity =>params[:deal][:quantity]  )

        CustomerMailer.deliver_deal_redemption_notification(@redeem_deal.customer, @redeem_deal.customer.customer_profile, @deal_redemption, @redeem_deal.deal)
        flash[:notice] = "Deal Redeemed Successfully."
      else
        flash[:notice] = "You have already redeemed all the deals."
      end
                 
      if request.xml_http_request?
        respond_to do |format|
          format.html
          format.js {
            render :update do |page|
              page.replace_html 'redeem_deal',:partial => "redeem_deal"
            end
          }
        end
      end
    end
  end

  def location_deals
    @page = 'Location Deals'
    @location_deals = DealLocationDetail.all_deals
  end


  def new_location_deal
    @deal = Deal.new
    if request.xml_http_request?
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'location_deal',:partial => "new_location_deal"
          end
        }
      end
    end
  end


  def deals_on_demand
    @page = "Deals on Demand"
    @demand_deals = MerchantProfile.all_my_demand_deals(current_merchant.id)
  end

  def view_create_demand_deal
    @bid_deal = CustomerDemandDealBidding.find(params[:id])
    @demand_deal = @bid_deal.customer_demand_deal
    if request.xml_http_request?
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'create_demand_deal',:partial => "create_demand_deal"
          end
        }
      end
    end
  end

  def view_demand_deal_info
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

  def create_demand_deal
    @bid_deal = CustomerDemandDealBidding.find(params[:bid_id])
    buy = params[:actual_value].to_f*params[:discount].to_f/100
    save_amount = params[:actual_value].to_f - buy.to_f
    @bid_deal.update_attributes(:name => params[:name], :actual_value => params[:actual_value], :buy_value => buy, :savings => save_amount, 
      :discount => params[:discount], :number => params[:number], :demand_deal_photo => params[:demand_deal_photo], :rules => params[:rules],
      :highlights => params[:highlights], :bid_time => Time.now.to_i, :deal_end_date => Time.parse(params[:expiry_date].gsub('/','-')).to_i, :status => "closed")

    demand_deal = @bid_deal.customer_demand_deal
    demand_deal.update_attributes(:status => "offered")
    
    redirect_to "/deals_on_demand"
  end

  def keupoint_deals
    @page = "Keupoint Deals"
    if request.post?
      merchant_profile = current_merchant.merchant_profile
      deal = Deal.new(:name => params[:name], :value => params[:actual_value], :discount => params[:discount], :rules => params[:rules], :highlights => params[:highlights], :status => "open", :expiry_date => Time.parse("#{params[:expiry_date].gsub('/','-')} 23:59:59").to_i.to_s, :deal_type_id => 4, :merchant_id => current_merchant.id, :deal_category_id => merchant_profile.deal_category_id, :deal_sub_category_id => merchant_profile.deal_sub_category_id, :keupoints_required => params[:keupoints])
      deal.buy = params[:actual_value].to_f*params[:discount].to_f/100
      deal.save_amount = deal.value.to_f - deal.buy.to_f
      deal.deal_photo = params[:deal_photo]  
      deal.save!    
    end
    @deals = Deal.keupoint_deals(current_merchant.id)
  end

  def gift_deals
    @page = "Gift Deals"
    if request.post?
      merchant_profile = current_merchant.merchant_profile
      deal = Deal.new(:name => params[:name], :value => params[:actual_value], :discount => params[:discount], :rules => params[:rules], :highlights => params[:highlights], :status => "open", :expiry_date => Time.parse("#{params[:expiry_date].gsub('/','-')} 23:59:59").to_i.to_s, :deal_type_id => 4, :merchant_id => current_merchant.id, :deal_category_id => merchant_profile.deal_category_id, :deal_sub_category_id => merchant_profile.deal_sub_category_id)
      deal.buy = params[:actual_value].to_f*params[:discount].to_f/100
      deal.save_amount = deal.value.to_f - deal.buy.to_f
      deal.deal_photo = params[:deal_photo]
      deal.save!
    end
    @deals = Deal.gift_deals(current_merchant.id)
  end
  
  def edit_keupoint_deal
    @deal = Deal.find(params[:id])
    if request.xml_http_request?
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'create_edit_keupoint_deal',:partial => "edit_keupoint_deal"
          end
        }
      end
    end
  end

  def edit_gift_deal
    @deal = Deal.find(params[:id])
    if request.xml_http_request?
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'create_edit_gift_deal',:partial => "edit_gift_deal"
          end
        }
      end
    end
  end

  def edit_open_deal
    @deal = Deal.find(params[:id])
    @schedule = @deal.deal_schedule
    if request.xml_http_request?
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'create_edit_open_deal',:partial => "edit_open_deal"
          end
        }
      end
    end
  end
  
  def update_keupoint_deal
    @deal = Deal.find(params[:id])
    buy = params[:actual_value].to_f*params[:discount].to_f/100
    save_amount = params[:actual_value].to_f - buy.to_f
    @deal.update_attributes(:name => params[:name],:buy => buy, :save_amount => save_amount, :value => params[:actual_value], :discount => params[:discount], :rules => params[:rules], :highlights => params[:highlights], :expiry_date => Time.parse("#{params[:expiry_date].gsub('/','-')} 23:59:59").to_i.to_s, :keupoints_required => params[:keupoints])
    redirect_to "/keupoint_deals"  
  end

  def update_gift_deal
    @deal = Deal.find(params[:id])
    buy = params[:actual_value].to_f*params[:discount].to_f/100
    save_amount = params[:actual_value].to_f - buy.to_f
    @deal.update_attributes(:name => params[:name],:buy => buy, :save_amount => save_amount, :value => params[:actual_value], :discount => params[:discount], :rules => params[:rules], :highlights => params[:highlights], :expiry_date => Time.parse("#{params[:expiry_date].gsub('/','-')} 23:59:59").to_i.to_s)
    redirect_to "/gift_deals"
  end

  def update_open_deal
    @deal = Deal.find(params[:id])
    schedule = @deal.deal_schedule
    preference = ((@deal.preferred.blank? || @deal.preferred.to_s == "0") && params[:preferred] == "1")? true : false
    un_preference = (@deal.preferred.to_s == "1" && (@deal.admin_preferred.blank? || @deal.admin_preferred.to_s == '0') && params[:preferred] != "1")? true : false
    @deal.update_attributes(:name => params[:name], :value => params[:actual_value], :rules => params[:rules], :highlights => params[:highlights], :expiry_date => Time.parse("#{params[:expiry_date].gsub('/','-')} 23:59:59").to_i.to_s)
    schedule.update_attributes(:start_time => Time.parse("#{params[:start_date].gsub('/','-')} 00:00:00").to_i.to_s, :end_time => Time.parse("#{params[:close_date].gsub('/','-')} 23:59:59").to_i.to_s)
    if preference
      @deal.update_attributes(:preferred => params[:preferred])
      merchant_profile = @deal.merchant.merchant_profile
      AdminMailer.deliver_merchant_created_preferred_deal(@deal, merchant_profile, merchant_profile.company)
    end
    if un_preference
      @deal.update_attributes(:preferred => '0')
    end
    redirect_to "/deals_of_mine"
  end
  
  def cancel_keupoint_deal
    @deal = Deal.find(params[:id])
    @deal.update_attributes(:status => "cancelled")
    @deals = Deal.keupoint_deals(current_merchant.id)
    if request.xml_http_request?
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'summary',:partial => "keupoint_deals_summary"
          end
        }
      end
    end
  end
  
  def view_keupoint_deal
    @deal = Deal.find(params[:id])
    if request.xml_http_request?
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'view_keupoint_deal',:partial => "view_keupoint_deal"
          end
        }
      end
    end
  end

  def view_gift_deal
    @deal = Deal.find(params[:id])
    if request.xml_http_request?
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'view_gift_deal',:partial => "view_gift_deal"
          end
        }
      end
    end
  end

  def view_open_deal
    @deal = Deal.find(params[:id])
    if request.xml_http_request?
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'view_open_deal',:partial => "view_open_deal"
          end
        }
      end
    end
  end

end
