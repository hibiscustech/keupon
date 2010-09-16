class MerchantController < ApplicationController

  def new
    @merchant = Merchant.new
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
    password = [Array.new(6){rand(256).chr}.join].pack("m").chomp
    @merchant = Merchant.new( :login => merchant_profile.email_address, :email => merchant_profile.email_address, :password => password,
                              :password_confirmation => password)

    @merchant.time_created = Time.now.to_i
    @merchant.save!

    merchant_profile.update_attributes(:merchant_id => @merchant.id, :status => "active")
    flash[:notice] = "Merchant: #{merchant_profile.first_name} #{merchant_profile.last_name} has been activated!  An email has been sent to #{merchant_profile.email_address}."
    redirect_to "/admins/all_merchants"    
  end

end
