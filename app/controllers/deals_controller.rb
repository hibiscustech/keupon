class DealsController < ApplicationController
  def new
    @deal = Deal.new
  end

  def create
    @deal = Deal.new(params[:deal])
  end

  def index
    if request.get?
      @months = { "January" => 1, "February" => 2, "March" => 3, "April" => 4, "May" => 5, "June" => 6, "July" => 7, "August" => 8,
                  "September" => 9, "October" => 10, "Nevember" => 11, "December" => 12 }
      @years = [2010, 2011]
      today = Time.now
      @month = today.month
      @year = today.year
      @month_name = today.strftime("%B")
      
      session[:month] = @month
      session[:year] = @year
      session[:month_name] = @month_name
      
      @schedules = Hash.new
      @schedules["20".to_s] = Array.new
      detail = {"tournament" => "tournament", "category" => "category", "level" => "level", "place" => "area_name", "opponent" => "opponent"}
      @schedules[20.to_s].push(detail)
    elsif request.xml_http_request?
      @month = (params[:month].blank?)? session[:month] : params[:month].to_i
      @year = (params[:year].blank?)? session[:year] : params[:year].to_i
      @month_name = (params[:month].blank?)? session[:month_name] : Time.parse("#{@year}-#{@month}-15").strftime("%B")

      session[:month] = @month
      session[:year] = @year
      session[:month_name] = @month_name

      @schedules = Hash.new
      @schedules["20".to_s] = Array.new
      detail = {"tournament" => "tournament", "category" => "category", "level" => "level", "place" => "area_name", "opponent" => "opponent"}
      @schedules[20.to_s].push(detail)
      
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'calendar',:partial => "calendar_deals"
          end
        }
      end
    end
  end

  def view_basic_info
    if request.xml_http_request?
      respond_to do |format|
        format.html
        format.js {
          render :update do |page|
            page.replace_html 'view_deal',:partial => "deal_info"
          end
        }
      end
    end
  end


  def get_deals
    @deals = Deal.find(:all)
    deals = []
    @deals.each do |deal|
      deal_schedule = DealSchedule.find_by_deal_id(deal.id)
      d_hash = Hash.new
      d_hash[:id] = deal.id
      d_hash[:title] = "test"
      d_hash[:description] = "deal.highlights"
      d_hash[:start] = Time.at(deal_schedule.start_time.to_i).iso8601
      d_hash[:end] = Time.at(deal_schedule.end_time.to_i).iso8601
      d_hash[:allDay] = 1
      d_hash[:recurring] = false
      deals << d_hash
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
