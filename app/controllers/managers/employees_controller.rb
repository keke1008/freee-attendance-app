class Managers::EmployeesController < ApplicationController
  before_action :set_employee

  def show
    date = params.permit(:date)&.[](:date)&.to_date || Time.current
    @attendances = @employee.attendances.where(begin_at: date.all_month)
    @current_date = date
    @next_date = date.since(1.month).to_s
    @previous_date = date.ago(1.month).to_s
  end

  private

  def set_employee
    set_manager
    return if @manager.nil?

    employee_id = params.permit(:id)[:id]
    @employee = current_manager.employee.find(employee_id)
  end
end
