class ScheduleController < ApplicationController

  def index
    redirect_to "/schedule/#{Date.today.strftime("%m%d%Y")}"
  end
  
  def show
    @day = (params["id"][4..7]+"-"+params["id"][0..1]+"-"+params["id"][2..3]).to_date
    @technicians = params[:technician_id] ? [Technician.find(params[:technician_id])] : Technician.all
    @hours = []
    [["08:00", "08:00"], ["08:30", "08:30"], ["09:00", "09:00"], ["09:30", "09:30"], 
    ["10:00", "10:00"], ["10:30", "10:30"], ["11:00", "11:00"], ["11:30", "11:30"], 
    ["12:00", "12:00"], ["12:30", "12:30"], ["01:00", "13:00"], ["01:30", "13:30"], 
    ["02:00", "14:00"], ["02:30", "14:30"], ["03:00", "15:00"], ["03:30", "15:30"], 
    ["04:00", "16:00"], ["04:30", "16:30"], ["05:00", "17:00"], ["05:30", "17:30"]].each do |time|
      @hours << {:digits => time[0], :class => "time_#{time[0].split(':').join('_')}", :t24 => "time_#{time[1].split(':').join('_')}"}
    end
  end
end