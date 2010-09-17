class DealsController < ApplicationController
  layout "deals"
  def new
    @deal = Deal.new
  end

  def create
    @deal = Deal.new(params[:deal])
  end

  def index

  end


  def get_deals
    @deals = Deal.find(:all)
    deals = []
    @deals.each do |deal|
      deal_schedule = DealSchedule.find_by_deal_id(deal.id)
      deals << {:id => deal.id, :title => deal.name, :description => deal.highlights, :start => "#{deal_schedule.start_time.iso8601}", :end => "#{deal_schedule.end_time.iso8601}", :allDay => "1", :recurring => false}
    end
    render :text => deals.to_json
  end



  def move
    @deal = Deal.find(params[:id])
    ds = @deal.deal_schedule
  end


  def resize
    @deal = Deal.find(params[:id])
  end

  def edit
    @deal = Deal.find(params[:id]) 
  end

  def update
    @deal = Deal.find(params[:deal][:id])

    render :update do |page|
      page<<"$('#calendar').fullCalendar( 'refetchDeals' )"
      page<<"$('#desc_dialog').dialog('destroy')"
    end

  end

  def destroy
    @deal = Deal.find(params[:id])
    @deal.destroy

    render :update do |page|
      page<<"$('#calendar').fullCalendar( 'refetchDeals' )"
      page<<"$('#desc_dialog').dialog('destroy')"
    end

  end
end
