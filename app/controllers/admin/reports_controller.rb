class Admin::ReportsController < ApplicationController
  layout 'reports'
  def index
    
  end
  
  def recorded_vs_flatrate
    # start_date and end_date stuff
    params[:start_date]     ||= LastDayNextDay.last('friday')
    params[:end_date]       ||= LastDayNextDay.next('thursday')
    start_date = params[:start_date].to_s + " 00:00:00"
    end_date = params[:end_date].to_s + " 23:59:59"
    @start_date = params[:start_date]
    @end_date = params[:end_date]
    
    # getting/setting technician_id
    if params[:technician_id] then @selected = params[:technician_id] end
    if params[:technician_id] == 'all' then params[:technician_id] = nil end
    params[:technician_id]  ||= (0..1000)    
    
    # make it so we only find jobs with flatrate and extra time recorded
    flatrate_range = (0..99999999)
    
    @jobs = Job.all(:conditions => {:completed => start_date..end_date, :technician_id => params[:technician_id], :flatrate_time => flatrate_range})

    # used to create a running differential
    @runningdiff = []
  end
  
end