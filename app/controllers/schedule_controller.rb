class ScheduleController < ApplicationController

  def index
    redirect_to "/schedule/#{Date.today.strftime("%m%d%Y")}"
  end
  
  def show
    @day = (params["id"][0..1]+"/"+params["id"][2..3]+"/"+params["id"][4..7]).to_date
    @technicians = params[:technician_id] ? Technician.find(params[:technician_id]).to_a : Technician.all
    @hours = []
    ["08:00", "08:30", "09:00", "09:30", "10:00", "10:30", "11:00", 
    "11:30", "12:00", "12:30", "01:00", "01:30", "02:00", "02:30", 
    "03:00", "03:30", "04:00", "04:30", "05:00", "05:30"].each do |time|
      @hours << {:digits => time, :class => "time_#{time.split(':').join('_')}"}
    end
  end
end