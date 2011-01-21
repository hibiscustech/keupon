# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  include AuthenticatedSystemMerchant 
  protect_from_forgery :only => [:sample]
  # render new.rhtml
  
  def check_user
   type=params[:user_type]
   if type=='As Customer'
    redirect_to "/signup"
   else
    redirect_to "/merchant_signup"
   end
  end
  def policy
     send_file "#{RAILS_ROOT}/public/images/policy.doc",:type=>'application/doc',:disposition => 'inline',:stream => false
  end 
  def admin_create
   logout_keeping_session!
    @user = AdminUser.new(params[:user])
    @user.time_created = Time.now
    @user.login = @user.email
    success = @user && @user.save
    if success && @user.errors.empty?
      redirect_back_or_default('/')
      flash[:notice] = "Admin user is created.Please sign in with your login credentials"
    else
      flash[:error]  = "We couldn't set up that account, sorry."
      render :action => 'new', :layout=> 'signup'
    end

  end
  def new
    @page = "Login"
  end

  def create
    logout_keeping_session!
    if params[:login_user] == 'customer'
      customer
    elsif params[:login_user] =='admin'
      admin
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


    def change_password_update
     @page = "Change Password"
     customer = Customer.find(params[:current_user])
    if Customer.authenticate(customer.login, params[:old_password])
      if ((params[:password] == params[:password_confirmation]) && !params[:password_confirmation].blank?)
        customer.password_confirmation = params[:password_confirmation]
        customer.password = params[:password]
        if customer.save!
          CustomerMailer.deliver_change_password(customer, customer.password)
          flash[:notice] = "Password successfully updated"
          redirect_to :controller => 'customers' ,:action => 'change_password'
        else
          flash[:error] = "Password not changed"
          redirect_to :controller => 'customers' ,:action => 'change_password'
        end
      else
        flash[:error] = "New Password mismatch"
        redirect_to :controller => 'customers' , :action => 'change_password'
      end
    else
      flash[:error] = "Old password incorrect"
     redirect_to :controller => 'customers' ,:action => 'change_password'
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
     if params[:dev]=='mob'
       xml = Builder::XmlMarkup.new
       xml.instruct!
       xml.login do
        xml.response 'success'
        xml.user_id customer.id
       end
       respond_to do |format|
         format.xml { render :xml => xml.target! }
       end
      else
      redirect_to :controller => 'customers',:action => "deal_of_the_day"
      flash[:notice] = "Logged in successfully"
      end
    else
      if params[:dev]=='mob'
       xml = Builder::XmlMarkup.new
       xml.instruct!
       xml.login do
        xml.response 'failure'
        xml.message "UserId/password doesn't match"
       end
       respond_to do |format|
         format.xml { render :xml => xml.target! }
       end
      else
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      render :action => 'new'
      end
    end
  end

  def admin
    customer = AdminUser.authenticate(params[:login], params[:password])
    if customer
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      #self.current_admin = customer
      session[:admin]=customer.id
      new_cookie_flag = (params[:remember_me] == "1")
      #handle_remember_cookie! new_cookie_flag
      redirect_to '/admins'
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
