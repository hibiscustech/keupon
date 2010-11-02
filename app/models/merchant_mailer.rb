class MerchantMailer < ActionMailer::Base
  def merchant_registration(merchant_profile,merchant_company )
    merchant_email(merchant_profile)
    @body[:merchant_profile]  = merchant_profile
    @body[:merchant_company] = merchant_company
    content_type "text/html"
  end

  protected
  def  merchant_email(merchant_profile)
    @recipients  = "#{merchant_profile.email_address}"
    @from        = "#{Constant.get_admin_email_id}"
    @subject     = "Merchant Application for Keupons"
    @sent_on     = Time.now
  end
end