class DiscussionsController < ApplicationController
  include AuthenticatedSystem
  before_filter :login_required
 def create
   forum=Forum.create(:customer_id=>current_customer.id,:deal_id=>params[:deal_id],:description=>params[:description])
   redirect_to "/deal_details?id=#{params[:deal_id]}/#comments"
 end
 def view
  id=params[:id]
  @forum=Forum.find(id)
  @comments=@forum.comments
    @deal = Deal.find(@forum.deal_id)
    @forums=Forum.find_all_by_deal_id(@deal.id)
    @end_time = @deal.deal_schedule.end_time
    @company = @deal.merchant.merchant_profile.company if !@deal.blank?
    @open_deal_discounts_recent, @open_deals_recent = Deal.all_and_open_deals
    @map = GMap.new("map")
    @map.control_init(:large_map => true, :map_type => true)
    @map.center_zoom_init([@deal.deal_location_detail.longitude,@deal.deal_location_detail.latitude],8)
    @map.overlay_init(GMarker.new([@deal.deal_location_detail.longitude,@deal.deal_location_detail.latitude] ))
    @page = "Deal Details"
    render :layout => 'application_home'

 end
 def comments
  id=params[:forum_id]
  @forum=Forum.find(id)
  @comment=Comment.create(:customer_id=>current_customer.id,:forum_id=>params[:forum_id],:description=>params[:description])
   redirect_to :back
 end
end
