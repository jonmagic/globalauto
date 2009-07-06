class Admin::SettingsController < ApplicationController
  def index
    redirect_to "/admin/technicians"
  end
end
