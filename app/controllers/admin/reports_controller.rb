class Admin::ReportsController < ApplicationController
  layout 'reports'
  def index
    redirect_to '/admin/reports/recorded_vs_flatrate'
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
    
    # run my search
    conditions = {}
    conditions[:completed_at] = {'$gt' => start_date.to_time, '$lt' => end_date.to_time}
    conditions[:technician_id] = params[:technician_id] unless params[:technician_id].blank?
    conditions[:flatrate_time] = {'$gt' => 0.0}
    @jobs = Job.all(conditions)

    # used to create a running differential
    @runningdiff = []
  end
  
  def time_sheet
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
    
    # run my search
    conditions = {}
    conditions[:completed_at] = {'$gt' => start_date.to_time, '$lt' => end_date.to_time}
    conditions[:technician_id] = params[:technician_id] unless params[:technician_id].blank?
    conditions[:flatrate_time] = {'$gt' => 0.0}
    jobs = Job.all(conditions)
    
    # setup my hash
    rows = Hash.new {|h,k| h[k] = { "row" => (k) }}
    
    # build my initial list of technicans
    technicians = jobs.collect { |j| j.technician_id }.uniq
    technicians.each do |tech_id|
      rows[tech_id] = {}
      rows[tech_id]["Name"] = Technician.find(tech_id).name
      rows[tech_id]["Jobs"] = []
      rows[tech_id]["Totals"] = {}
      rows[tech_id]["Totals"]["Recorded"] = 0.0
      rows[tech_id]["Totals"]["Flatrate"] = 0.0
      rows[tech_id]["Totals"]["Extra"] = 0.0
    end
    
    jobs.each do |job|
      rows[job.technician_id]["Jobs"] << job
      rows[job.technician_id]["Totals"]["Recorded"] += job.recorded_time_helper.to_f
      rows[job.technician_id]["Totals"]["Flatrate"] += job.flatrate_time.to_f
      rows[job.technician_id]["Totals"]["Extra"] += job.extra_time.to_f
    end
    
    @techs = rows.values
    
  end
  
end