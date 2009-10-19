class Admin::JobsController < ApplicationController
  layout 'admin_jobs'
  before_filter :load_totals, :except => [:create, :update, :delete_jobs]
  
  def index
    @jobs = Job.limit(params[:status])
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @jobs }
    end
  end
  
  def find_next_completed_job
    if Job.limit("completed").length > 0
      @job = Job.first_completed_job
      redirect_to edit_admin_job_path(@job)
    else
      redirect_to "/admin/jobs/?status=completed"
    end
  end

  def show
    @job = Job.find(params[:id])
    if Timer.find(:first, :conditions => {:job_id => @job.id, :end_time => nil})
      @timer = Timer.find(:first, :conditions => {:job_id => @job.id, :end_time => nil})
    else
      @timer = Timer.new
    end

    respond_to do |format|
      format.html { render }
      format.xml  { render :xml => @job }
    end
  end

  def new
    @technician = Technician.find(params[:technician_id])
    @job = Job.new

    respond_to do |format|
      format.html { render :layout => false }
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
        format.html { redirect_to "/" }
        format.xml  { render :xml => @job, :status => :created, :location => @job }
      else
        format.html { redirect_to "/" }
        format.xml  { render :xml => @job.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @job = Job.find(params[:id])

    respond_to do |format|
      if @job.update_attributes(params[:job])
        format.json { render :nothing => true, :response => 200 }
        format.xml  { head :ok }
      else
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
  
  def delete_jobs
    # find all the jobs between my start and end date
    @jobs = Job.find(:all) do
      created_at >= params[:start_date].to_date
      created_at <= params[:end_date].to_date
    end
    if @jobs.length > 0
      # delete each job
      @jobs.each { |job| job.destroy }
      # search for jobs in that date range again
      @jobs = Job.find(:all) do
        created_at >= params[:start_date].to_date
        created_at <= params[:end_date].to_date
      end
      # if there are still jobs return failure, otherwise success
      if @jobs.length == 0
        flash[:notice] = "Jobs deleted successfully!"
        redirect_to '/admin/jobs'
      else
        flash[:notice] = "Not all jobs could be deleted :-("
        redirect_to '/admin/jobs'
      end
    else
      flash[:notice] = "There were no jobs to delete in that date range."
      redirect_to '/admin/jobs'
    end
  end
  
  protected

    def load_totals
      @totals = Job.totals
    end
end
