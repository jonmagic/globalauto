class ScheduleController < ApplicationController

  def index
    redirect_to "/schedule/#{Date.today.strftime("%m%d%Y")}"
  end
  
  def show
    @day = (params["id"][0..1]+"/"+params["id"][2..3]+"/"+params["id"][4..7]).to_date
    @technicians = params[:technician_id] ? Technician.find(params[:technician_id]).to_a : Technician.all
    @hours = []
    ["8:00", "8:30", "9:00", "9:30", "10:00", "10:30", "11:00", 
    "11:30", "12:00", "12:30", "1:00", "1:30", "2:00", "2:30", 
    "3:00", "3:30", "4:00", "4:30", "5:00", "5:30"].each do |time|
      @hours << {:digits => time, :class => "time_#{time.split(':').join('_')}"}
    end
  end
end