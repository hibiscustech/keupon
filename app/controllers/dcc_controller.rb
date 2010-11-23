
require 'cgi'
require 'profile'
require 'caller'
# Controller with actions for doing DoDirectPayment API call. The name is chosen in consistent with other PayPal SDKs. 
class DccController < ApplicationController 
    layout "application_paypal"
    session :session_key => '_PayPalSDK_session_id'
    filter_parameter_logging :password
  
   # to make long names shorter for easier access and to improve readability define the following variables
    @@profile = PayPalSDKProfiles::Profile
    #unipay credentials hash
    @@email=@@profile.unipay
    # merchant credentials hash
    @@cre=@@profile.credentials
    
  #condition to check if 3 token credentials are passed
  if((@@email.nil?) && (@@cre.nil? == false))
      @@USER = @@cre["USER"]
      @@PWD = @@cre["PWD"]
      @@SIGNATURE  = @@cre["SIGNATURE"]
      @@SUBJECT = ""
  end
  #condition to check if UNIPAY credentials are passed
  if((@@cre.nil?) && (@@email.nil? == false) )
      @@USER = ""
      @@PWD = ""
      @@SIGNATURE  = ""
      @@SUBJECT = @@email["SUBJECT"]
  end
  #condition to check if 3rd party credentials are passed
  if((@@cre.nil? == false) && (@@email.nil? == false))  
      @@USER = @@cre["USER"]
      @@PWD = @@cre["PWD"]
      @@SIGNATURE  = @@cre["SIGNATURE"]
      @@SUBJECT = @@email["SUBJECT"]
  end 
  
  def begin
    redirect_to :action => 'pay', :PaymentAction => params[:paymentaction]
  rescue Errno::ENOENT => exception
    flash[:error] = exception
    redirect_to :action => 'index' 
  end
  
  def pay
    @payment_action=params[:PaymentAction]
  end
# DoDirectPayment API call  
  def do_DCC        
    if (params[:dcc][:expDateMonth].to_s.length == 1)
      @expMonth =   "0" + params[:dcc][:expDateMonth].to_s
    else
      @expMonth =    params[:dcc][:expDateMonth].to_s
    end     
    @caller =  PayPalSDKCallers::Caller.new(false)
    @transaction = @caller.call(
      {
        :method          => 'DoDirectPayment',
        :amt             => params[:dcc][:amount],
        :currencycode    => 'USD',
        :paymentaction   => params[:dcc][:PAYMENTACTION],
        :creditcardtype  => params[:creditCardType],
        :acct            => params[:creditCardNumber],
        :firstname       => params[:dcc][:firstName].to_s,
        :lastname        => params[:dcc][:lastName],
        :street          => params[:dcc][:address1],
        :city            => params[:dcc][:city],
        :state           => params[:dcc][:state],
        :zip             => params[:dcc][:zip].to_s,
        :countrycode     => 'US',
        :expdate         => @expMonth+params[:dcc][:expDateYear].to_s,
        :cvv2            => params[:dcc][:cvv2Number].to_s,
        :USER  => @@USER,
        :PWD   => @@PWD,
        :SIGNATURE => @@SIGNATURE,
        :SUBJECT => @@SUBJECT       
      }
    )       
     
   if @transaction.success?       
      session[:dcc_response]=@transaction.response 
      redirect_to :controller => 'dcc',:action => 'thanks'
    else
      session[:paypal_error]=@transaction.response
      redirect_to :controller => 'dcc', :action => 'error'
    end
  rescue Errno::ENOENT => exception
    flash[:error] = exception
    redirect_to :controller => 'wppro', :action => 'exception'
  end        
  
  def thanks    
    @response = session[:dcc_response]
    @transactionId =  @response["TRANSACTIONID"]
    @amount = @response["AMT"]
    @avsCode = @response["AVSCODE"]
    @cvv2Match = @response["CVV2MATCH"]
  end

  def get_input
  @transaction_id = params[:authorization_id]
  end

  # DoVoid API call
  def do_void
    @caller =  PayPalSDKCallers::Caller.new(false)
    @transaction = @caller.call(
      { :method          => 'DoVoid',
        :authorizationid => params[:dovoid][:authorization_id].to_s,
        :note            => params[:dovoid][:note].to_s,
        :trxtype         => 'V',
        :USER  =>  @@USER,
        :PWD   => @@PWD,
        :SIGNATURE => @@SIGNATURE,
        :SUBJECT => @@SUBJECT
      }
    )

   if @transaction.success?
      session[:void_response]=@transaction.response
      redirect_to :controller => 'dcc',:action => 'thanks_void'
    else
      session[:paypal_error]=@transaction.response
      redirect_to :controller => 'dcc', :action => 'error'
    end
  rescue Errno::ENOENT => exception
    flash[:error] = exception
    redirect_to :controller => 'dcc', :action => 'error'
  end

  def thanks_void
    @response = session[:void_response]
  end
  
end





