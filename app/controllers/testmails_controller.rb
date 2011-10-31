class TestmailsController < ApplicationController
  # GET /testmails
  # GET /testmails.xml
  def index
    @testmails = Testmail.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @testmails }
    end
  end

  # GET /testmails/1
  # GET /testmails/1.xml
  def show
    @testmail = Testmail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @testmail }
    end
  end

  # GET /testmails/new
  # GET /testmails/new.xml
  def new
    @testmail = Testmail.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @testmail }
    end
  end

  # GET /testmails/1/edit
  def edit
    @testmail = Testmail.find(params[:id])
  end

  # POST /testmails
  # POST /testmails.xml
  def create
    @testmail = Testmail.new(params[:testmail])

    respond_to do |format|
      if @testmail.save
        subject='Test'
        message='This is testing!!'
        Emailer.deliver_contact('divyakr1985@gmail.com', subject, message, sent_at = Time.now)
        flash[:notice] = 'Testmail was successfully created.'
        format.html { redirect_to(@testmail) }
        format.xml  { render :xml => @testmail, :status => :created, :location => @testmail }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @testmail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /testmails/1
  # PUT /testmails/1.xml
  def update
    @testmail = Testmail.find(params[:id])

    respond_to do |format|
      if @testmail.update_attributes(params[:testmail])
        flash[:notice] = 'Testmail was successfully updated.'
        format.html { redirect_to(@testmail) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @testmail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /testmails/1
  # DELETE /testmails/1.xml
  def destroy
    @testmail = Testmail.find(params[:id])
    @testmail.destroy

    respond_to do |format|
      format.html { redirect_to(testmails_url) }
      format.xml  { head :ok }
    end
  end
end
