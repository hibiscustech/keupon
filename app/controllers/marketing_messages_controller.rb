class MarketingMessagesController < ApplicationController
  # GET /marketing_messages
  # GET /marketing_messages.xml
  include AuthenticatedSystem

  def index
    @marketing_messages = MarketingMessage.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @marketing_messages }
    end
  end

  # GET /marketing_messages/1
  # GET /marketing_messages/1.xml
  def show
    @marketing_message = MarketingMessage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @marketing_message }
    end
  end

  # GET /marketing_messages/new
  # GET /marketing_messages/new.xml
  def new
    @marketing_message = MarketingMessage.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @marketing_message }
    end
  end

  # GET /marketing_messages/1/edit
  def edit
    @marketing_message = MarketingMessage.find(params[:id])
  end

  # POST /marketing_messages
  # POST /marketing_messages.xml
  def create
    @marketing_message = MarketingMessage.new(params[:marketing_message])

    respond_to do |format|
      if @marketing_message.save
        flash[:notice] = 'MarketingMessage was successfully created.'
        format.html { redirect_to('/marketing_messages') }
        format.xml  { render :xml => @marketing_message, :status => :created, :location => @marketing_message }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @marketing_message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /marketing_messages/1
  # PUT /marketing_messages/1.xml
  def update
    @marketing_message = MarketingMessage.find(params[:id])

    respond_to do |format|
      if @marketing_message.update_attributes(params[:marketing_message])
        flash[:notice] = 'MarketingMessage was successfully updated.'
        format.html { redirect_to('/marketing_messages') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @marketing_message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /marketing_messages/1
  # DELETE /marketing_messages/1.xml
  def destroy
    @marketing_message = MarketingMessage.find(params[:id])
    @marketing_message.destroy

    respond_to do |format|
      format.html { redirect_to(marketing_messages_url) }
      format.xml  { head :ok }
    end
  end
end
