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
end
