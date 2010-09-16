class AdminsController < ApplicationController
  layout "admins"
  protect_from_forgery :only => [:destroy]
  
  def all_merchants
    @active_merchants = MerchantProfile.all_active_merchants
    @merchants_count = MerchantProfile.merchant_counts
    if request.xml_http_request?
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'merchants',:partial => "active_merchants"
          end
        }
      end
    end
  end

  def new_merchants
    @new_merchants = MerchantProfile.all_new_merchants
    if request.xml_http_request?
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'merchants',:partial => "new_merchants"
          end
        }
      end
    end
  end
end
