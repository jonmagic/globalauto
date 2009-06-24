class JobsController < ApplicationController
  layout 'jobs', :except => ['my_jobs']
  
  def redirect
    @technician = Technician.find(params[:technician_id])
    if @technician.has_jobs?
      redirect_to "/technicians/#{@technician.id}/jobs"
    else
      redirect_to "/technicians/#{@technician.id}/jobs/new"
    end
  end
  
  def index
    if params[:technician_id]
      @technician = Technician.find(params[:technician_id])
      @jobs = Job.scoped_by_technician_id(@technician.id)

      respond_to do |format|
        format.html { render :layout => 'my_jobs' }
        format.xml  { render :xml => @jobs }
      end      
    else
      @jobs = Job.active_jobs
      @technicians = Technician.active_techs

      respond_to do |format|
        format.html
        format.xml  { render :xml => @jobs }
      end
    end
  end

  def show
    @job = Job.find(params[:id])
    if Timeclock.find(:first, :conditions => {:job_id => @job.id, :end_time => nil})
      @timer = Timeclock.find(:first, :conditions => {:job_id => @job.id, :end_time => nil})
    else
      @timer = Timeclock.new
    end

    respond_to do |format|
      format.html { render :layout => 'my_jobs' }
      format.xml  { render :xml => @job }
    end
  end

  def new
    @technician = Technician.find(params[:technician_id])
    @job = Job.new

    respond_to do |format|
      format.html { render :layout => 'my_jobs' }
      format.xml  { render :xml => @job }
    end
  end

  def edit
    @job = Job.find(params[:id])
  end

  def create
    @job = Job.new(params[:job])

    respond_to do |format|
      if @job.save
        flash[:notice] = 'Job was successfully created.'
        format.html { redirect_to(@job) }
        format.xml  { render :xml => @job, :status => :created, :location => @job }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @job.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @job = Job.find(params[:id])

    respond_to do |format|
      if @job.update_attributes(params[:job])
        flash[:notice] = 'Job was successfully updated.'
        format.html { redirect_to(@job) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @job.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @job = Job.find(params[:id])
    @job.destroy

    respond_to do |format|
      format.html { redirect_to(jobs_url) }
      format.xml  { head :ok }
    end
  end
end
