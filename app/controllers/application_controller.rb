# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include Geokit::Geocoders
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  def newpass(len)
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end

  def encrypted_password(password, salt)
    string_to_hash = password + salt
    Digest::SHA1.hexdigest(string_to_hash)
  end

  def my_keupons_stats
    if !current_customer.blank?
      @my_keupons_stats = Deal.my_keupons_statistics(current_customer.id)
      @my_keupons_stats["keupoints"] = current_customer.kupoints
    end
  end

  def get_lat_lng(location)
    res = MultiGeocoder.geocode("#{location.address1}, #{location.address2}, #{location.state}, #{location.zipcode}")
    location.longitude = res.lat
    location.latitude = res.lng
  end

  def admin_login_required
   user=AdminUser.find(session[:admin])if session[:admin]
   if user
    return true
   else
    session[:return_to] = request.request_uri
    flash[:notice]='Please login as admin!'
    redirect_to'/login'
    return false
   end
  end
end
