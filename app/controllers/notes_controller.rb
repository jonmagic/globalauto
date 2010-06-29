class NotesController < ApplicationController

  def show
    unless @note = Note.where(:date => params[:id]).first
      @note = Note.create(:date => params[:id])
    end
  end
  
  def update
    @note = Note.find(params[:id])
    
    if @note.update_attributes(params[:note])
      render :nothing => true, :layout => false, :response => 200
    else
      render :json => @note.errors.to_json, :layout => false, :response => 500
    end
  end

end
