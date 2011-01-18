class ApiController < ApplicationController
 def deals_on_demand_new_or_confirmed
 current_customer=Customer.find(params[:user_id])
 @msg =
     @categories = DealCategory.find(:all)
     @demand_deals_summary = CustomerDemandDeal.customer_demand_deals_summary(current_customer.id)
     #@demand_deal = (params[:id].blank?)? nil : CustomerDemandDeal.find(params[:id])
     @msg = (@demand_deal.blank?)? "Please fill in the form below.<br/>All the fields are required for submission<br/>Do let us know which specific deal you want us to showcase on Keupon, We will get back to you soon!!" : (@demand_deal.status == "new")? "'Update' this Demand Deal with changes or 'Confirm' in order to start receiving Offerings." : "Thank you! The Deal will be shared with the merchants. We will update you via e-mail/ SMS when the merchants respond"

     if request.post?
       if params[:id].blank?
         @demand_deal = CustomerDemandDeal.create(:expected_value => params[:price], :number => params[:quantity], :deadline => Time.parse(params[:deadline].gsub('/','-')+" 23:59:59").to_i, :description => params[:description], :status => "new", :time_created => Time.now.to_i, :customer_id => current_customer.id, :deal_category_id => params[:category])
         @sub_categories = DealSubCategory.find_by_sql("select * from deal_sub_categories where deal_category_id = #{@demand_deal.deal_category_id}")
         @msg = "The New Deal that you demanded has been created. 'Update' the new Deal with changes or 'Confirm' in order to receive Offerings."
       end
     end
    @demand_deals_summary = CustomerDemandDeal.customer_demand_deals_summary(current_customer.id)
    xml = Builder::XmlMarkup.new
    xml.instruct!
    xml.deals_on_demand do
      @demand_deals_summary.each { |d|
        if (d.status=="new") or (d.status="confirmed")
        xml.item(:type => d.status )do
        xml.deal_id d.id
        xml.type d.status
        xml.name d.description
        xml.expected_price d.expected_value
        xml.no_of_deals d.number
        xml.deadline d.deadline
        end
        end
      }
    end

    respond_to do |format|
      format.xml { render :xml => xml.target! }
    end 

  end
  def deals_available
     @open_deal_discounts, @open_deals = Deal.all_hot_and_open_deals
     @hotest_deal = Deal.hottest_deal_of_today
        xml = Builder::XmlMarkup.new
        xml.instruct!
        xml.deals_on_demand do
      @open_deals.each { |d|
        for opdd in @open_deal_discounts
            discount = opdd[1]
            open_deal = @open_deals[opdd[0]]
            opd = Deal.find(open_deal.id)
            type=(d.id==@hotest_deal.id)?"HOT":(opd.status)
            xml.item(:type => type )do
            xml.image opd.deal_photo.url(:small)
            xml.unique_id_of_the_deal opd.id
            xml.title open_deal.name
            xml.deal_discount_in_float_percentage opd.discount#((discount.nil?)?discount :'')
            xml.deals_sold open_deal.no_of_customers
            xml.address open_deal.address1,open_deal.address2,open_deal.city 
            xml.expiry Time.at(open_deal.end_time.to_i).strftime("%d-%m-%Y")
          end
        end
      }
            xml.item(:type => 'hot' )do
            opd = Deal.find(@hotest_deal.id)
            xml.image_url opd.deal_photo.url(:small)
            xml.unique_id_of_the_deal @hotest_deal.id
            xml.title @hotest_deal.name
            xml.deal_discount_in_float_percentage @hotest_deal.discount#((discount.nil?)?discount :'')
            xml.deals_sold @hotest_deal.no_of_customers
            end
    end

    respond_to do |format|
      format.xml { render :xml => xml.target! }
    end 

  end
  def my_keupons
      current_customer=Customer.find(params[:user_id])
      @keupoint_deals = Deal.available_keupoint_deals(current_customer.kupoints)
      my_keupons = Deal.my_keupons(current_customer.id)
        xml = Builder::XmlMarkup.new
        xml.instruct!
        xml.deals do
        my_keupons.each { |k|
        deal = Deal.find(k.id)
         for available in my_keupons 
          if (available.expiry_date.to_i > Time.now.to_i && available.status == "available")
          xml.item(:type => "unused" )do
           xml.name available.name
           xml.image deal.deal_photo.url(:small)
           xml.purchased Time.at(available.purchase_date.to_i).strftime("%d-%m-%Y")
           xml.expiry Time.at(available.expiry_date.to_i).strftime("%d-%m-%Y")
           xml.code available.deal_code
          end
          end
         end
         for expired in my_keupons 
          if expired.expiry_date.to_i <= Time.now.to_i || expired.status == "expired"
          xml.item(:type => "expired" )do
           xml.name expired.name
           xml.image deal.deal_photo.url(:small)
           xml.purchased Time.at(expired.purchase_date.to_i).strftime("%d-%m-%Y")
           xml.expiry Time.at(expired.expiry_date.to_i).strftime("%d-%m-%Y")
           xml.code expired.deal_code
          end
          end
         end
         for used in my_keupons
           if used.status == "used"
           xml.item(:type => "used" )do
           xml.name used.name
           xml.image deal.deal_photo.url(:small)
           xml.purchased Time.at(used.purchase_date.to_i).strftime("%d-%m-%Y")
           xml.expiry Time.at(used.expiry_date.to_i).strftime("%d-%m-%Y")
           xml.code used.deal_code
           end
           end
        end

        }
        end
    respond_to do |format|
      format.xml { render :xml => xml.target! }
    end 
  end
  def offered_deals_api
    @demand_deal = CustomerDemandDeal.find(params[:deal])
    @offerings = CustomerProfile.my_demand_deal_offerings(params[:deal])
    @hotest_deal = Deal.hottest_deal_of_today
    xml = Builder::XmlMarkup.new
    xml.instruct!
    xml.deals_on_demand do
     for deal in @offerings
      cddb = CustomerDemandDealBidding.find(deal.id)
      xml.item(:type => "offered" )do
       xml.deal_id deal.id
       xml.name_demanded deal.name
       xml.name_offered @demand_deal.description
       xml.offered_price cddb.actual_value
       xml.offered_discount cddb.discount
       xml.offered_expiry Time.at(cddb.deal_end_date).strftime("%d-%m-%Y")
       xml.offered_icon cddb.demand_deal_photo.url(:small)
     end
    end
   end
    respond_to do |format|
      format.xml { render :xml => xml.target! }
    end 
  end
end
