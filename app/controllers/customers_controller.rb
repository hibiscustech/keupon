class CustomersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  

  # render new.rhtml
  def new
    @customer = Customer.new
  end

  def create
    logout_keeping_session!
    @customer = Customer.new(params[:customer])
    @customer.kupoints = 0
    @customer.time_created = Time.now
    success = @customer && @customer.save
    if success && @customer.errors.empty?
      @profile = CustomerProfile.new(params[:customer_profile])
      @profile.customer = @customer
      @profile.save
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
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
