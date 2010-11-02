class MerchantController < ApplicationController

  include AuthenticatedSystemMerchant
  include Geokit::Geocoders
  layout 'application_merchant'
  
  protect_from_forgery :only => [:destroy]
  before_filter :login_required , :only => [:deals_of_mine, :redeem_deals,:deals_on_demand,:location_deals]
  
  def index
    @page = "Welcome #{current_merchant.merchant_profile.first_name}"
  end

  def new
     @page = 'Merchant Signup'
    @merchant = Merchant.new
  end

  def deals_of_mine
    @page = 'My Deals'
    @deals = Deal.merchants_deals(current_merchant.id)
  end

  def create
    logout_keeping_session!
    #@merchant =  Merchant.new(params[:merchant])
    #success = @merchant && @merchant.save
    @merchant_profile = MerchantProfile.new(params[:merchant_profile])
    #@merchant_profile.merchant = @merchant
    success = @merchant_profile &&  @merchant_profile.save

    if success && @merchant_profile.errors.empty?
      @merchant_company = Company.new(params[:company])
      @merchant_company.merchant_profile = @merchant_profile
      @merchant_company.save
      CustomerMailer.deliver_merchant_registration(@merchant_profile,@merchant_company )
      redirect_back_or_default('/')
      flash[:notice] = "Thank You for Signing Up with us, we will get back to you after our verification."
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end

  def authenticate_merchant
    merchant_profile = MerchantProfile.find(params[:id])
    password = newpass(8)
    @merchant = Merchant.new( :login => merchant_profile.email_address, :email => merchant_profile.email_address, :password => password,
      :password_confirmation => password)

    @merchant.time_created = Time.now.to_i
    @merchant.save!

    merchant_profile.update_attributes(:merchant_id => @merchant.id, :status => "active")
    flash[:notice] = "Merchant: #{merchant_profile.first_name} #{merchant_profile.last_name} has been activated!  An email has been sent to #{merchant_profile.email_address}."
    redirect_to "/admins/all_merchants"    
  end

  def forgot_password    
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
        if flag
          flash[:notice] = "Your password has been reset and send to your mail"
          redirect_to "/"
        else
          flash[:notice] = "Your Password could not be changed."
          redirect_to :action =>"forgot_password", :controller => "merchant"
        end
      else
        flash[:notice] = "Email-id doesnt exists"
        render :controller => 'merchant',:action => 'forgot_password'
      end    
    end
  end

  def redeem_deals
    @page = 'Redeem Deals'
    flash[:notice] = nil
  end

  def verify_deal
    flash[:notice] = nil
    customer = Customer.verify_customer(params[:customer_pin])
    if !customer.blank?
      if !customer.id.blank?
        @customer = Customer.find(customer.id)
        @customer_profile = @customer.customer_profile
        @customer_deal = CustomerDeal.verify_customer_deal(params[:code], @customer.id)
        if @customer_deal.blank?
          flash[:notice] = "Invalid Code"
        else
          @deal = Deal.find(@customer_deal.deal_id)
          if @deal.merchant_id.to_s != current_merchant.id.to_s
            @deal = nil
            flash[:notice] = "This Deal Code does not belong to this merchant."
          end
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
            page.replace_html 'redeem_deal',:partial => "redeem_deal"
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
      new_status = (quantity_left > 0)? "available" : "used"
      @redeem_deal.update_attributes(:status => new_status, :quantity_left => quantity_left)
      @deal_redemption = CustomerDealRedemption.create(:customer_deal_id =>@redeem_deal.id, :redeemed_time => Time.now.to_i, :redeemed_quantity =>params[:deal][:quantity]  )
      flash[:notice] = "Deal Redeemed Successfully."
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
      :highlights => params[:highlights], :bid_time => Time.now.to_i, :deal_end_date => Time.parse(params[:expiry_date]).to_i, :status => "closed")

    demand_deal = @bid_deal.customer_demand_deal
    demand_deal.update_attributes(:status => "offered")
    
    redirect_to "/deals_on_demand"
  end

  def keupoint_deals
    @page = "Kupoint Deals"
    if request.post?
      merchant_profile = current_merchant.merchant_profile
      deal = Deal.new(:name => params[:name], :value => params[:actual_value], :discount => params[:discount], :rules => params[:rules], :highlights => params[:highlights], :status => "open", :expiry_date => Time.parse("#{params[:expiry_date]} 23:59:59").to_i.to_s, :deal_type_id => 4, :merchant_id => current_merchant.id, :deal_category_id => merchant_profile.deal_category_id, :deal_sub_category_id => merchant_profile.deal_sub_category_id, :keupoints_required => params[:keupoints])      
      deal.buy = params[:actual_value].to_f*params[:discount].to_f/100
      deal.save_amount = deal.value.to_f - deal.buy.to_f
      deal.deal_photo = params[:deal_photo]  
      deal.save!    
    end
    @deals = Deal.keupoint_deals(current_merchant.id)
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
  
  def update_keupoint_deal
    @deal = Deal.find(params[:id])
    buy = params[:actual_value].to_f*params[:discount].to_f/100
    save_amount = params[:actual_value].to_f - buy.to_f
    @deal.update_attributes(:name => params[:name],:buy => buy, :save_amount => save_amount, :value => params[:actual_value], :discount => params[:discount], :rules => params[:rules], :highlights => params[:highlights], :expiry_date => Time.parse("#{params[:expiry_date]} 23:59:59").to_i.to_s, :keupoints_required => params[:keupoints])      
    redirect_to "/keupoint_deals"  
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

end
