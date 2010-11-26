class AdminMailer < ActionMailer::Base
  def merchant_registration_notification(merchant_profile, merchant_company )
    admin_email("Notification - Merchant Application for Keupons")
    @body[:merchant_profile]  = merchant_profile
    @body[:merchant_company] = merchant_company
    content_type "text/html"
  end

  def merchant_created_preferred_deal(deal, merchant_profile, merchant_company)
    admin_email("Notification - Merchant Created a Highly Preferred Deal")
    @body[:merchant_profile]  = merchant_profile
    @body[:merchant_company] = merchant_company
    @body[:deal] = deal
    content_type "text/html"
  end

  protected
  def admin_email(subject)
    @recipients  = "#{Constant.get_admin_email_id}"
    @from        = "#{Constant.get_admin_email_id}"
    @subject     = subject
    @sent_on     = Time.now
  end

end