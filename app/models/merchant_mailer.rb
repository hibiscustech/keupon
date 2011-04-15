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

  def your_deal_closed(merchant, merchant_profile, file_path, deal, customers)
    merchant_email(merchant_profile)
    @subject     = "Deal Closed"
    @body[:merchant_profile]  = merchant_profile
    @body[:merchant] = merchant
    @body[:deal] = deal
    @body[:customers] = customers
    attachments['customers.csv'] = File.read(file_path)
  end

  def confirm_deal(merchant_profile,merchant,deal)
    merchant_email(merchant_profile)
    @subject     = "Confirm Deal"
    @body[:merchant_profile]  = merchant_profile
    @body[:merchant] = merchant
    @body[:deal] = deal
    content_type "text/html"

  end

  protected
  def  merchant_email(merchant_profile)
    @recipients  = "#{merchant_profile.email_address}"
    @from        = "#{Constant.get_admin_email_id}"    
    @sent_on     = Time.now
  end
end
