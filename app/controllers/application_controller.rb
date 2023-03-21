class ApplicationController < ActionController::Base
  protected

  def set_manager
    @manager = current_manager
    redirect_to root_path if @manager.nil?
  end

  def set_manager_and_employee
    set_manager
    employee_id = params[:employee_id]
    @employee = @manager.employee.find(employee_id)
  end
end
