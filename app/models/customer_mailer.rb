class CustomerMailer < ActionMailer::Base
  def signup_notification(customer)
    setup_email(customer)
    @subject    = 'Please activate your new account'
    @body[:profile] = customer.customer_profile
    @body[:url]  = "/activate/#{customer.activation_code}"
    content_type "text/html"
  end

  def deal_ordered_notification(customer, profile, deal)
    setup_email(customer)
    @subject    = 'Your order has been received'
    @body[:profile] = profile
    @body[:deal] = deal
    content_type "text/html"
  end

  def deal_purchase_notification(customer, profile, customer_deal, deal, my_keupon_credits)
    setup_email(customer)
    @subject    = 'You have purchased a Deal from Keupons'
    @body[:profile] = profile
    @body[:customer_deal] = customer_deal
    @body[:deal] = deal
    @body[:credits] = my_keupon_credits
    content_type "text/html"
  end

  def subscribers_notification(subscriber, deals, deal_discounts)
    @recipients  = "#{subscriber}"
    @from        = "#{Constant.get_admin_email_id}"
    @sent_on     = Time.now
    @subject    = "Today's Deals"
    @body[:deals] = deals
    @body[:deal_discounts] = deal_discounts
    content_type "text/html"
  end

  def deal_redemption_notification(customer, profile, redeem_deal, deal)
    setup_email(customer)
    @subject    = 'You have Redeemed a Deal bought from Keupons'
    @body[:profile] = profile
    @body[:redemption] = redeem_deal
    @body[:deal] = deal
  end

  def  forgot_password(customer, password)
    setup_email(customer)
    @subject    = 'You password has been reset'
    @body[:password] = password
    @body[:customer] = customer
    content_type "text/html"
  end

  def change_password(mail,password)
    setup_email(mail)
    @subject    = 'You password has been changed'
    @body[:password] = password
    @body[:customer] = mail
    content_type "text/html"
  end
  
  def activation(customer)
    setup_email(customer)
    @subject    = 'Your account has been activated!'
    @body[:profile] = customer.customer_profile
    content_type "text/html"
  end 
  def send_invite(customer,email,id)
    @recipients  = email
    @subject    = 'I think you should get your Keupon!'
    @from        = "#{Constant.get_admin_email_id}"
    @sent_on     = Time.now
    @body[:customer] = customer
    @body[:id] = id
    content_type "text/html"
  end
  
  protected
  def setup_email(customer)
    @recipients  = "#{customer.email}"
    @from        = "#{Constant.get_admin_email_id}"
    @sent_on     = Time.now
    @body[:customer] = customer
  end 
end
