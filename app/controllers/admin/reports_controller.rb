class Admin::ReportsController < ApplicationController
  layout 'reports'
  def index
    
  end
  
  def recorded_vs_flatrate
    params[:start_date]     ||= LastDayNextDay.last('friday')
    params[:end_date]       ||= LastDayNextDay.next('thursday')
    if params[:technician_id] then @selected = params[:technician_id] end
    if params[:technician_id] == 'all' then params[:technician_id] = nil end
    params[:technician_id]  ||= (0..1000)
    
    start_date = params[:start_date].to_s + " 00:00:00"
    end_date = params[:end_date].to_s + " 23:59:59"
    
    @jobs = Job.all(:conditions => {:completed => start_date..end_date, :technician_id => params[:technician_id]})
    @runningdiff = []
    
    @start_date = params[:start_date]
    @end_date = params[:end_date]
  end
  
end