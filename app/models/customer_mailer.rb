class CustomerMailer < ActionMailer::Base
  def signup_notification(customer,profile,password)
    setup_email(customer)
    @subject    = 'Please activate your new Keupons account'
    @body[:profile] = profile
    @body[:password] = password
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

  def deal_purchase_notification(customer, profile, customer_deal, deal, my_keupon_credits, company, location, merchant_profile)
    setup_email(customer)
    @subject    = 'You have purchased a Deal from Keupons'
    @body[:profile] = profile
    @body[:customer_deal] = customer_deal
    @body[:deal] = deal
    @body[:credits] = my_keupon_credits
    @body[:company] = company
    @body[:location] = location
    @body[:merchant_profile] = merchant_profile
    content_type "text/html"
  end

  def subscribers_notification(subscriber, deals, deal_discounts)
    @recipients  = "#{subscriber}"
    @from        = "#{Constant.get_admin_email_id}"
    @sent_on     = Time.zone.now
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

  def forgot_password(customer, password, customer_profile)
    setup_email(customer)
    @subject    = 'Your Keupons password has been reset'
    @body[:password] = password
    @body[:customer] = customer
    @body[:customer_profile] = customer_profile
    content_type "text/html"
  end

  def change_password(mail,password, customer_profile)
    setup_email(mail)
    @subject    = 'Your Keupons password has been changed'
    @body[:password] = password
    @body[:customer] = mail
    @body[:customer_profile] = customer_profile
    content_type "text/html"
  end
  
  def activation(customer,profile)
    setup_email(customer)
    @subject    = 'You Keupons account has been activated!'
    @body[:profile] = profile
    content_type "text/html"
  end 
  
  def send_invite(customer,customer_profile,email,friend_id)
    @recipients  = email
    @subject    = "#{customer_profile.first_name} has invited you to join Keupons"
    @from        = "#{Constant.get_admin_email_id}"
    @sent_on     = Time.zone.now
    @body[:customer] = customer
    @body[:customer_profile] = customer_profile
    @body[:friend_id] = friend_id
    content_type "text/html"
  end
  
  def share_this_deal(customer,customer_profile,email,deal)
    @recipients  = email
    @subject    = "#{customer_profile.first_name} thinks you will like this Keupons deal"
    @from        = "#{Constant.get_admin_email_id}"
    @sent_on     = Time.zone.now
    @body[:customer] = customer
    @body[:customer_profile] = customer_profile
    @body[:deal] = deal
    content_type "text/html"
  end
  
  protected
  def setup_email(customer)
    @recipients  = "#{customer.email}"
    @from        = "#{Constant.get_admin_email_id}"
    @sent_on     = Time.zone.now
    @body[:customer] = customer
  end 
end
