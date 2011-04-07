# The module has a class which holds merchant's API credentials and PayPal endpoint information.  

module PayPalSDKProfiles
  class Profile         
    cattr_accessor :credentials 
    cattr_accessor :endpoints 
    cattr_accessor :client_info 
    cattr_accessor :proxy_info 
    cattr_accessor :PAYPAL_EC_URL 
    cattr_accessor :DEV_CENTRAL_URL 
    cattr_accessor :unipay
    
    
# Redirect URL for Express Checkout 
    @@PAYPAL_EC_URL="https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token="
#    
    @@DEV_CENTRAL_URL="https://developer.paypal.com"
###############################################################################################################################    
#    NOTE: Production code should NEVER expose API credentials in any way! They must be managed securely in your application.
#    To generate a Sandbox API Certificate, follow these steps: https://www.paypal.com/IntegrationCenter/ic_certificate.html
###############################################################################################################################
# specify the 3-token values.  
#credentials for 3 token
@@credentials =  {"USER" => "akshay_api1.keupons.com", "PWD" => "VYE9TNTSKZ5W7WFC", "SIGNATURE" => "AKhpjCvdj3KVB2-fNZqxoZKi4iWFAlC-DupHgtdY2t3LB7uSb20IjddJ" }

#Credentials for certificate
#@@credentials =  {"USER" => "sdk-seller_api1.sdk.com", "PWD" => "12345678"}

# Use (uncomment) the following for UniPay that is to when API caller has only e-mail address, but no 3 token credentials  
#uncomment @@unipay and @@credentials when making third party call, that is when you want to pass both subject and 3 token credentials
#@@unipay = {"SUBJECT" => "bmuniy_1245144089_biz@paypal.com"   }

# endpoint of PayPal server against which call will be made. For 3 token
@@endpoints = {"SERVER" => "api-3t.paypal.com", "SERVICE" => "/nvp/"}
#@@endpoints = {"SERVER" => "api-3t.sandbox.paypal.com", "SERVICE" => "/nvp/"}

# endpoint of PayPal server against which call will be made. For certificate
#@@endpoints = {"SERVER" => "api.sandbox.paypal.com", "SERVICE" => "/nvp/"}
    

# Proxy information of the client environment.    
    @@proxy_info = {"USE_PROXY" => false, "ADDRESS" => nil, "PORT" => nil, "USER" => nil, "PASSWORD" => nil }
    
# Information needed for tracking purposes.    
   @@client_info = { "VERSION" => "65.1", "SOURCE" => "PayPalRubySDKV1.2.0"}   
 
  def initialize
      config
    end
 def config
     @config ||= YAML.load_file("./script/../config/paypal.yml")     
 end
 
 def m_use_proxy
   @config[:USE_PROXY]
 end
end

   
end



