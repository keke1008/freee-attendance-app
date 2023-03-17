class RootController < ApplicationController
  def index
    redirect_to manager_path if manager_signed_in?
    redirect_to employee_path if employee_signed_in?
  end
end
