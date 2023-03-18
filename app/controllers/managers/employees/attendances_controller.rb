class Managers::Employees::AttendancesController < ApplicationController
  before_action :set_employee

  def index
    date = params.permit(:date)&.[](:date)&.to_date || Time.current
    @attendances = @employee.attendances.where(begin_at: date.all_month)
    @current_date = date
    @next_date = date.since(1.month).to_s
    @previous_date = date.ago(1.month).to_s
  end

  private

  def set_employee
    if current_manager.nil?
      redirect_to root_path
      return
    end

    employee_id = params.permit(:employee_id)[:employee_id]
    @employee = current_manager.employee.find(employee_id)
  end
end
