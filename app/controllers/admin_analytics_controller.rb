class AdminAnalyticsController < ApplicationController
  layout "admins"
  protect_from_forgery :only => [:destroy]
  require 'fastercsv'
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
    @deals = Deal.accounting    
    if !params['sort'].blank?
      @deals = case params['sort']
      when "expiry_date"  then sort_asc("expiry_date", @deals)
      when "expiry_date_reverse"  then sort_desc("expiry_date", @deals)
      when "posting_date"  then sort_desc("posting_date", @deals)
      when "posting_date_reverse"  then sort_asc("posting_date", @deals)
      when "closing_date"  then sort_asc("closing_date", @deals)
      when "closing_date_reverse"  then sort_desc("closing_date", @deals)
      when "merchant_name"  then sort_asc("merchant_name", @deals)
      when "merchant_name_reverse"  then sort_desc("merchant_name", @deals)
      when "title"  then sort_asc("title", @deals)
      when "title_reverse"  then sort_desc("title", @deals)
      when "actual_price"  then sort_asc("actual_price", @deals)
      when "actual_price_reverse"  then sort_desc("actual_price", @deals)
      when "purchased"  then sort_asc("purchased", @deals)
      when "purchased_reverse"  then sort_desc("purchased", @deals)
      when "discount"  then sort_asc("discount", @deals)
      when "discount_reverse"  then sort_desc("discount", @deals)
      when "commission"  then sort_asc("commission", @deals)
      when "commission_reverse"  then sort_desc("commission", @deals)
      when "sales"  then sort_asc("sales", @deals)
      when "sales_reverse"  then sort_desc("sales", @deals)
      when "net_sales"  then sort_asc("net_sales", @deals)
      when "net_sales_reverse"  then sort_desc("net_sales", @deals)
      end
    else
      @deals = sort_desc("posting_date", @deals)
    end

    if request.xml_http_request?
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'accounting',:partial => "accounting_summary"
          end
        }
      end
    end
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
 def customer_reports_csv
    sort = "time_created" if sort.blank?
    @customers = Customer.customers_summary(sort)
    @outfile = "costomer_report_" + Time.zone.now.strftime("%m-%d-%Y") + ".csv"
    csv_data = FasterCSV.generate do |csv|
      csv << ["Sign-up Date","Name","NRIC/FIN","Age","Phone Number","Email","Average M.Salary(S$)","Location","# of times Bought","total Spending(S$)","# of Keupoints","# of Friends Introduced"]
      @customers.each do |customer|
        csv << [Time.at(customer.time_created).strftime("%d-%m-%Y"),customer.name,customer.customer_pin,my_age(customer.dob),customer.phone,customer.email,customer.income,customer.location,customer.total_bought,customer.spendings,customer.kupoints,customer.introduced]
      end
    end

    send_data csv_data,:type => 'text/csv; charset=iso-8859-1; header=present',:disposition => "attachment; filename=#{@outfile}"
    flash[:notice] = "Customer report export complete!"
  end
   def accounting_reports_csv
    @deals = Deal.accounting    
    @deals = sort_desc("posting_date", @deals)
    @outfile = "accounting_report_" + Time.zone.now.strftime("%m-%d-%Y") + ".csv"
    csv_data = FasterCSV.generate do |csv|
      csv << ["Merchant Name","Date of Posting","Deal Title","Date of closing","Date of Expiry","Keupons Purchased","Usual Price(S$)","Sales(S$)","Final Discount","Keupons Commission","Net Sales"]
      @deals.each do |deal|
        result = deal[1]
        csv << [result["merchant_name"],Time.at(result["posting_date"].to_i).strftime("%d-%m-%Y"),result["title"],Time.at(result["closing_date"].to_i).strftime("%d-%m-%Y"),Time.at(result["expiry_date"].to_i).strftime("%d-%m-%Y"),result["purchased"],result["actual_price"],result["sales"],result["discount"].to_s+"%",result["commission"].to_s+"%",result["net_sales"]]
      end
    end

    send_data csv_data,:type => 'text/csv; charset=iso-8859-1; header=present',:disposition => "attachment; filename=#{@outfile}"
    flash[:notice] = "Accounting report export complete!"
  end


  def sort_asc(column, summary)
    sorted_hash = summary.sort  { | leftval, rightval | leftval[1][column]<=>rightval[1][column] }
    return sorted_hash
  end

  def sort_desc(column, summary)
    sorted_hash = summary.sort  { | leftval, rightval | rightval[1][column]<=>leftval[1][column] }
    return sorted_hash
  end
  protected
   def my_age(dob)
         return (dob.blank?or(dob='0000-00-00'))? "-" : Customer.birthdate_to_age(Time.parse(dob)).to_s
   end

end
