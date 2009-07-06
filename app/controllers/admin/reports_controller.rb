class Admin::ReportsController < ApplicationController
  layout 'reports'
  def index
    
  end
  
  def recorded_vs_flatrate
    params[:start_date] ||= Date.today - 6.days
    params[:end_date] ||= Date.today
    
    start_date = params[:start_date].to_s + " 00:00:00"
    end_date = params[:end_date].to_s + " 23:59:59"
    
    @jobs = Job.all(:conditions => {:completed => start_date..end_date})
    
    @start_date = params[:start_date]
    @end_date = params[:end_date]
  end
  
end