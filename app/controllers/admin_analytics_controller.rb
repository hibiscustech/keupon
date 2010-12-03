class AdminAnalyticsController < ApplicationController
  layout "admins"
  protect_from_forgery :only => [:destroy]

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

  def accounting_report

  end

  def customers_report
    sort = case params['sort']
      when "time_created"  then "time_created desc"
      when "name"  then "name"
      when "customer_pin"  then "customer_pin"
      when "dob"  then "dob"
      when "phone"  then "phone"
      when "email" then "email"
      when "income"  then "income"
      when "location"  then "location"
      when "kupoints"  then "kupoints"
      when "total_bought"  then "total_bought"
      when "introduced"  then "introduced"
      when "spendings" then "spendings"
      when "time_created_reverse"  then "time_created"
      when "name_reverse"  then "name DESC"
      when "customer_pin_reverse"  then "customer_pin DESC"
      when "dob_reverse"  then "dob DESC"
      when "phone_reverse"  then "phone DESC"
      when "email_reverse" then "email DESC"
      when "income_reverse"  then "income DESC"
      when "location_reverse"  then "location DESC"
      when "kupoints_reverse"  then "kupoints DESC"
      when "total_bought_reverse"  then "total_bought DESC"
      when "introduced_reverse"  then "introduced DESC"
      when "spendings_reverse" then "spendings DESC"
    end
    sort = "time_created" if sort.blank?
    @customers = Customer.customers_summary(sort)
    if request.xml_http_request?
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'customers',:partial => "customers_summary"
          end
        }
      end
    end
  end
end
