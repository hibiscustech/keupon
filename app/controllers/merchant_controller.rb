class MerchantController < ApplicationController

  include AuthenticatedSystemMerchant
  
  protect_from_forgery :only => [:destroy]
  before_filter :login_required , :only => [:deals_of_mine]
  
  def index
    
  end

  def new
    @merchant = Merchant.new
  end

  def deals_of_mine
    @merchant = Merchant.find(current_merchant.id)
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
      flash[:notice] = "We have receive your application. It will take 7-10 days for our staff to verify authenticity."
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

end
