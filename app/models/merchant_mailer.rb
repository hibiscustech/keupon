class MerchantMailer < ActionMailer::Base
  def merchant_registration(merchant_profile,merchant_company )
    merchant_email(merchant_profile)
    @subject     = "Merchant Application for Keupons"
    @body[:merchant_profile]  = merchant_profile
    @body[:merchant_company] = merchant_company
    content_type "text/html"
  end
  
  def merchant_authenticated(merchant_profile, merchant, password, company)   
    merchant_email(merchant_profile)
    @subject     = "Merchant Authenticated for Keupons"
    @body[:merchant_profile]  = merchant_profile
    @body[:merchant] = merchant
    @body[:password] = password
    @body[:merchant_company] = company
    content_type "text/html"
  end

  protected
  def  merchant_email(merchant_profile)
    @recipients  = "#{merchant_profile.email_address}"
    @from        = "#{Constant.get_admin_email_id}"    
    @sent_on     = Time.now
  end
end