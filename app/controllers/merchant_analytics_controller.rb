class MerchantAnalyticsController < ApplicationController
  include AuthenticatedSystemMerchant
  layout 'application_merchant'
  protect_from_forgery :only => [:destroy]
  before_filter :login_required, :only => [:index, :sales_report,:customers_report,:customers_usage_report,:customers_purchase_frequency,
                                            :customers_kupoints,:deals_report,:location_deal_sales_revenue]

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

  def customers_usage_report

  end

  def customers_purchase_frequency
    if request.xml_http_request?
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'purchase_frequency_title', "<h3>Customers Purchase Frequency <br/>(#{params[:start_date]} - #{params[:end_date]})</h3>"
          end
        }
      end
    end
  end

  def customers_kupoints
    if request.xml_http_request?
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'kupoints_title', "<h3>Customers Kupoints <br/>(#{params[:start_date]} - #{params[:end_date]})</h3>"
          end
        }
      end
    end
  end

  def deals_report
    @page = "Deals Profit/Loss"
    @deals = Deal.accounting_for_merchant(current_merchant.id)
    if !params['sort'].blank?
      @deals = case params['sort']
      when "expiry_date"  then sort_asc("expiry_date", @deals)
      when "expiry_date_reverse"  then sort_desc("expiry_date", @deals)
      when "posting_date"  then sort_desc("posting_date", @deals)
      when "posting_date_reverse"  then sort_asc("posting_date", @deals)
      when "closing_date"  then sort_asc("closing_date", @deals)
      when "closing_date_reverse"  then sort_desc("closing_date", @deals)
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
            page.replace_html 'report_title', "<h3>#{params[:start_date]} - #{params[:end_date]}</h3>"
            page.replace_html 'table_analytic1',:partial => "merchants_deals_summary"
          end
        }
      end
    end
  end

  def location_deal_sales_revenue
    if request.xml_http_request?
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'location_deal_sales_revenue_report', :partial => "location_deal_sales_revenue"
          end
        }
      end
    end
  end

  def sort_asc(column, summary)
    sorted_hash = summary.sort  { | leftval, rightval | leftval[1][column]<=>rightval[1][column] }
    return sorted_hash
  end

  def sort_desc(column, summary)
    sorted_hash = summary.sort  { | leftval, rightval | rightval[1][column]<=>leftval[1][column] }
    return sorted_hash
  end
end
