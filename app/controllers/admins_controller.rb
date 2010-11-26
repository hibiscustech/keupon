class AdminsController < ApplicationController
  layout "admins"
  protect_from_forgery :only => [:destroy]

  def view_all_deals
    @deals = Deal.all_deals
  end
  
  def open_the_deal
    deal = Deal.find(params[:id])
    deal.update_attributes(:status => 'open')
    redirect_to "/admins/view_all_deals"
  end

  def deal_preferred
    deal = Deal.find(params[:id])
    deal.update_attributes(:admin_preferred => '1')
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

end
