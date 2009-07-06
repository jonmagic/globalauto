class Admin::TechniciansController < ApplicationController
  before_filter :login_required
  layout 'settings'
  
  def index
    @technicians = Technician.active_techs

    respond_to do |format|
      format.html
      format.xml  { render :xml => @technicians }
    end
  end

  def show
    @technician = Technician.find(params[:id])

    respond_to do |format|
      format.xml  { render :xml => @technician }
    end
  end

  def new
    @technician = Technician.new

    respond_to do |format|
      format.html
      format.xml  { render :xml => @technician }
    end
  end

  def edit
    @technician = Technician.find(params[:id])
  end
  
  def create
    @technician = Technician.new(params[:technician])

    respond_to do |format|
      if @technician.save
        flash[:notice] = 'Technician was successfully created.'
        format.html { redirect_to "/admin/technicians" }
        format.xml  { render :xml => @technician, :status => :created, :location => @technician }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @technician.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @technician = Technician.find(params[:id])

    respond_to do |format|
      if @technician.update_attributes(params[:technician])
        flash[:notice] = 'Technician was successfully updated.'
        format.html { redirect_to "/technicians" }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @technician.errors, :status => :unprocessable_entity }
      end
    end
  end


end
