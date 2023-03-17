class ManagersController < ApplicationController
  before_action :set_manager

  def show; end

  private

  def set_manager
    @manager = current_manager
    redirect_to root_path if @manager.nil?
  end
end
