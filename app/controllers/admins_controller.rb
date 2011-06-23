class AdminsController < ApplicationController

  layout "admins"
  protect_from_forgery :only => [:destroy]
  before_filter :admin_login_required, :except => [:open_the_deals, :email_subscribers, :save_commission ]
  include AuthenticatedSystemMerchant

  def email_subscribers
    @subscribers = KeuponSubscriber.find(:all)
    for subscriber in @subscribers
      sub_deals = subscriber.subscribed_deals
      cat_ids = sub_deals.collect{|sd| sd.deal_category_id}
      category_ids = cat_ids.join(",")
      merchants = MerchantProfile.merchants_for_categories(category_ids) if !category_ids.blank?
      if !merchants.blank?
        deal_discounts, deals = Deal.all_hot_and_open_deals_for_subscribers(merchants.join(","))
        CustomerMailer.deliver_subscribers_notification(subscriber.email, deals, deal_discounts)
      end
    end
    render(:text => 'Emails Sent')
  end

  def view_all_deals
    @deal_discounts,@deals = Deal.all_deals
  end

  def save_commission
    deal = Deal.find(params[:id])

    params[:commission].each_pair do |key,value|
      discount=DealDiscount.find(key)
      discount.update_attribute(:commission,value[0])
    end
    redirect_to "/admins/view_all_deals"
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
      if (Time.parse("#{Time.at(Time.zone.now.to_i).strftime('%d-%m-%Y')} 00:00:00").to_i >= deal.start_time.to_i) && (deal.start_time.to_i <=  Time.parse("#{Time.at(Time.zone.now.to_i).strftime('%d-%m-%Y')} 23:59:59").to_i)
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
    deal.update_attributes(:confirm => '1',:activated => "1")
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

  def view_deal_paypal_info
    @deal = Deal.find(params[:deal])
    if request.xml_http_request?
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'view_deal_paypal',:partial => "view_deal_paypal"
          end
        }
      end
    end
  end

  def view_deal_commission_info
    @deal = Deal.find(params[:deal])
    @discount_details = DealDiscount.find_all_by_deal_id(@deal.id)
    if request.xml_http_request?
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'view_deal_commissions',:partial => "view_deal_commissions"
          end
        }
      end
    end
  end

  def view_deal_transaction_details
    @deal = Deal.find(params[:deal])
    if request.xml_http_request?
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'view_tranaction_deal',:partial => "view_tranaction_deal"
          end
        }
      end
    end
  end

  def upload_tranaction_details
    deal = Deal.find(params[:deal])
    company = deal.merchant.merchant_profile.company
    location = deal.deal_location_detail
    merchant = deal.merchant
    merchant_profile = merchant.merchant_profile

    csv = FasterCSV.new(params[:upload][:upfile])
    successful_customers = Array.new

    i = 0
    csv.each do |row|
      if i > 0
        customer = Customer.find(row[0])
        customer_deal = CustomerDeal.find(row[1])
        quantity = row[9]
        total_price = row[10]
        if !row[7].blank? && row[7].to_i > 0
          customer.update_attributes(:balance_credit => row[7])
        end

        deal_code = rand(36 ** 4 - 1).to_s(36).rjust(4, "0")+customer.id.to_s+deal.id.to_s+deal.merchant_id.to_s
        customer_deal.update_attributes(:status => "available", :deal_code => deal_code, :quantity => quantity, :quantity_left => quantity)

        points_earned = Constant.dollar_to_keupoint_convertion.to_i*total_price.to_i
        CustomerKupoint.create(:customer_deal_id => customer_deal.id, :kupoints => points_earned, :time_created => Time.zone.now.to_i, :status => "earned")
        customer.kupoints = customer.kupoints.to_f + points_earned
        customer.save!

        CustomerMailer.deliver_deal_purchase_notification(customer, customer.customer_profile, customer_deal, deal, row[6].to_i, company, location, merchant_profile)
        successful_customers << {"customer" => customer.customer_profile, "quantity" => quantity, "total_price" => total_price}

        customer_invited_by = CustomerFriend.who_invited_me(customer.login)
        if !customer_invited_by.blank?
          cib = customer_invited_by[0]
          cib.update_attributes(:signed_up => '1')
        end
      end
      i += 1
    end

    file_path = "public/merchant_files/#{merchant_profile.first_name}.csv"
    FasterCSV.open(file_path, "w") do |csv|
      csv << ["Name", "Mobile Number", "NRIC", "No. of Keupons Bought", "Total Price Paid"]
      for sc_cust in successful_customers
        cprofile = sc_cust["customer"]
        csv << ["#{cprofile.first_name} #{cprofile.last_name}", "#{cprofile.contact_number}", "#{cprofile.customer_pin}", sc_cust["quantity"], sc_cust["total_price"]]
      end
    end
    files_to_send = Array.new
    files_to_send << File.open(file_path)
    MerchantMailer.deliver_your_deal_closed(merchant, merchant_profile, file_path, deal, successful_customers.size, files_to_send)
    File.delete(file_path)
    redirect_to "/admins/view_all_deals"
  end

  def paypal_deal_buy_url
    @deal = Deal.find(params[:id])
    @deal.update_attributes(:buy_url => params[:buy_url])
    flash[:notice] = "Buy Url has been Updated Successfully."
    if request.xml_http_request?
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'paypal_dbu',:partial => "paypal_deal_buy_url"
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

   def new_deal
     @deal = (params[:id].blank?)? Deal.new : Deal.find(params[:id])
     @categories = DealCategory.find(:all)
     session[:deal_discounts] = Hash.new
     @merchants = Company.merchants_for_new_deal
   end

   def create_deal
    merchant_profile = Merchant.find(params[:deal][:merchant_id]).merchant_profile
    @deal = Deal.new(params[:deal])
    @deal.expiry_date = Time.parse(params[:deal][:expiry_date]).to_i
    @deal.deal_category_id = merchant_profile.deal_category_id
    @deal.deal_sub_category_id = merchant_profile.deal_sub_category_id
    if params[:deal][:deal_type_id]
      @deal.deal_type_id = params[:deal][:deal_type_id]
    else
      @deal.deal_type_id = 1
    end

    if @deal.save!
      deal_location = DealLocationDetail.new(:deal_id => @deal.id, :address1 => params[:address1], :address2 => params[:address2], :state => params[:country], :city => params[:country], :zipcode => params[:zipcode])
      get_lat_lng(deal_location)
      deal_location.save!
      deal_schedule = DealSchedule.new(:deal_id => @deal.id, :start_time => Time.parse("#{params[:start_date]} 00:00:00").to_i.to_s, :end_time => Time.parse("#{params[:end_date]} 23:59:59").to_i.to_s)
      deal_schedule.save!
      if @deal.preferred.to_s == "1"
        AdminMailer.deliver_merchant_created_preferred_deal(@deal, merchant_profile, merchant_profile.company)
      end

      deal_discounts = session[:deal_discounts].sort
      min_customers = nil
      max_customers = nil
      buy = nil
      save_amount = nil
      discount = nil

      for dd in deal_discounts
        buy = @deal.value.to_f - @deal.value.to_f*dd[0].to_f/100
        save_amount = @deal.value.to_f - buy.to_f
        discount = dd[0]
        min_customers = dd[1][0]
        max_customers = dd[1][1]
        DealDiscount.create(:deal_id => @deal.id, :discount => discount, :customers => min_customers, :max_customers => max_customers, :buy_value => buy, :save_amount => save_amount)
      end
      @deal.update_attributes(:minimum_number => min_customers, :number => max_customers, :buy => buy, :save_amount => save_amount, :discount => discount)
      session[:deal_discounts] = nil
      flash[:notice] = "Deal Created Successfully."
      redirect_to "/admins/view_all_deals"
    end
  end

  def edit_deal
    @deal = (params[:id].blank?)? Deal.new : Deal.find(params[:id])
    @deal_location=DealLocationDetail.find_by_deal_id(@deal.id)
    @deal_discounts=DealDiscount.find_all_by_deal_id(@deal.id)
    @categories = DealCategory.find(:all)
    @merchants = Company.merchants_for_new_deal
  end

  def printable_merchant_copy
    @deal = Deal.find(params[:id])
    @schedule = @deal.deal_schedule
    @discounts = @deal.deal_discounts
    render :layout => 'print'
  end

  def update_deal
    merchant_profile = Merchant.find(params[:deal][:merchant_id]).merchant_profile
    @deal = Deal.find(params[:id])
    @deal.update_attribute(:expiry_date,Time.parse(params[:deal][:expiry_date].gsub("/","-")).to_i)
    @deal.deal_category_id = merchant_profile.deal_category_id
    @deal.deal_sub_category_id = merchant_profile.deal_sub_category_id
    if @deal.preferred.to_s == "1" && Deal.find(params[:id]).preferred.to_s == "0"
      AdminMailer.deliver_merchant_created_preferred_deal(@deal, merchant_profile, merchant_profile.company)
    end
    @deal.update_attributes(:name=>params[:deal][:name],:description => params[:deal][:description],:rules=>params[:deal][:rules],:highlights=>params[:deal][:highlights],:value=>params[:deal][:value])
    if params[:deal][:deal_type_id]
      @deal.deal_type_id = params[:deal][:deal_type_id]
    else
      @deal.deal_type_id = 1
    end

    deal_location = DealLocationDetail.find_by_deal_id(@deal.id)
    deal_location.update_attributes(:deal_id => @deal.id, :address1 => params[:address1], :address2 => params[:address2], :state => params[:country], :city => params[:country], :zipcode => params[:zipcode])
    get_lat_lng(deal_location)
    deal_schedule = DealSchedule.find_by_deal_id(@deal.id)
    deal_schedule.update_attributes(:deal_id => @deal.id, :start_time => Time.parse("#{params[:start_date].gsub("/","-")} 00:00:00").to_i.to_s, :end_time => Time.parse("#{params[:end_date].gsub("/","-")} 23:59:59").to_i.to_s)

    redirect_to "/admins/view_all_deals"
  end

end
