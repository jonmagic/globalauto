class TimersController < ApplicationController
  
  def create
    @timer = Timer.new(params[:timer])

    respond_to do |format|
      if @timer.save
        format.xml  { head :ok }
      else
        format.xml  { render :xml => @timer.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def update
    @timer = Timer.find(params[:id])

    respond_to do |format|
      if @timer.update_attributes(params[:timer])
        format.xml  { head :ok }
      else
        format.xml  { render :xml => @timer.errors, :status => :unprocessable_entity }
      end
    end
  end

end