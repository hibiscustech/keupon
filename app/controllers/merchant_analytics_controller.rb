class MerchantAnalyticsController < ApplicationController
  include AuthenticatedSystemMerchant

  protect_from_forgery :only => [:destroy]
  before_filter :login_required

  def index
    
  end

  def sales_report
    if request.xml_http_request?
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'date_display', "<h3>(#{params[:start_date]} - #{params[:end_date]})</h3>"
          end
        }
      end
    end
  end

  def customers_report
    
  end
end
