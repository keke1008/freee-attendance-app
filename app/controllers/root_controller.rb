class RootController < ApplicationController
  def index
    if manager_signed_in?
      redirect_to manager_path
      return
    end
    redirect_to employee_path if employee_signed_in?
  end
end
