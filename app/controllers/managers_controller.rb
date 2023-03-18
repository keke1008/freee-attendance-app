class ManagersController < ApplicationController
  before_action :set_manager

  def show
    @employees = @manager.employee
  end
end
