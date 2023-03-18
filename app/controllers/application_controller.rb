class ApplicationController < ActionController::Base
  protected

  def set_manager
    @manager = current_manager
    redirect_to root_path if @manager.nil?
  end
end
