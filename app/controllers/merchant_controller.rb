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

end
