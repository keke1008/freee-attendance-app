class EmployeesController < ApplicationController
  before_action :set_employee

  def show; end

  private

  def set_employee
    @employee = current_employee
    redirect_to root_path if @employee.nil?
  end
end
