# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  include AuthenticatedSystemMerchant 
  protect_from_forgery :only => [:sample]
  # render new.rhtml
  def new
  end

  def create
    logout_keeping_session!
    if params[:login_user] == 'customer'
      customer
    else
     merchant
    end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end

  def forgot_password_for
    if request.xml_http_request?
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'forgot_pwd',:partial => "forgot_password"
          end
        }
      end
    end
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "Couldn't log you in as '#{params[:login]}'"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end

  def customer
    customer = Customer.authenticate(params[:login], params[:password])
    if customer
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_customer = customer
      new_cookie_flag = (params[:remember_me] == "1")
      #handle_remember_cookie! new_cookie_flag
      redirect_to :controller => 'customers',:action => "deal_of_the_day"
      flash[:notice] = "Logged in successfully"
    else
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end

  def merchant
      merchant = Merchant.authenticate(params[:login], params[:password])
    if merchant
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_merchant = merchant
      new_cookie_flag = (params[:remember_me] == "1")
      #handle_remember_cookie! new_cookie_flag
      redirect_to :controller => 'merchant',:action => 'index'
      flash[:notice] = "Logged in successfully"
       else
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end

  
end
