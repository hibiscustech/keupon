class AdminsController < ApplicationController

  layout "admins"
  protect_from_forgery :only => [:destroy]
  before_filter :admin_login_required, :except => [:open_the_deals]
  include AuthenticatedSystemMerchant
  def view_all_deals
    @deal_discounts,@deals = Deal.all_deals
  end
  
  def open_the_deal
    deal = Deal.find(params[:id])
    deal.update_attributes(:status => 'open')
    redirect_to "/admins/view_all_deals"
  end

  def open_the_deals
    deals = Deal.deals_to_open
    opened_deals = Array.new
    for deal in deals
      if (Time.parse("#{Time.at(Time.now.to_i).strftime('%d-%m-%Y')} 00:00:00").to_i >= deal.start_time.to_i) && (deal.start_time.to_i <=  Time.parse("#{Time.at(Time.now.to_i).strftime('%d-%m-%Y')} 23:59:59").to_i)
        d = Deal.find(deal.id)
        d.update_attributes(:status => "open")
        opened_deals.push(d)
      end
    end
    if opened_deals.size > 0
      AdminMailer.deliver_opened_deals(opened_deals)
    end
    render(:text => 'deals opened')
  end

  def deal_preferred
    deal = Deal.find(params[:id])
    deal.update_attributes(:admin_preferred => '1')
    redirect_to "/admins/view_all_deals"
  end
  def confirm_the_deal
    deal = Deal.find(params[:id])
    deal.update_attributes(:confirm => '1')
    merchant=Merchant.find(deal.merchant_id)
    merchant_profile=merchant.merchant_profile
    MerchantMailer.deliver_confirm_deal(merchant_profile,merchant,deal)
    redirect_to "/admins/view_all_deals"
  end  
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
    @merchants_count = MerchantProfile.merchant_counts
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

   def all_customers
    @customers = Customer.all_customers
    #@merchants_count = Customer.merchant_counts
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


  def all_deal_categories
    @deal_categories = DealCategory.all_deal_categories
  end

  def create_deal_category
    @deal_category = DealCategory.new(params[:subject])
    if @deal_category.save
      render :partial => 'admins/deal_category', :object => @deal_category
    end
  end

  def all_deal_sub_categories
    @deal_sub_categories = DealSubCategory.all_deal_sub_categories
   
  end

  def create_deal_sub_category
    @deal_sub_category = DealSubCategory.new(params[:deal_sub_category])
    if @deal_sub_category.save
      render :partial => 'admins/deal_sub_category', :object => @deal_sub_category
    end
  end


   def all_constants
     @constant = Constant.find :all
   end

   def update_constant
     @constant = Constant.find(params[:id])
     @constant .update_attributes(:value => params['constant']['value'])
     if request.xml_http_request?
       respond_to do |format|
         format.html
         format.js {
           render :update do |page|
             page.insert_html :top, "subject_list", "<div id='msg' style='text-align:center;background-color:grey;color:#fff;' onclick='Effect.toggle('msg','appear');'>You Successfully update value for #{@constant.name}</div>"
           end
         }
       end
     end
   end

end



