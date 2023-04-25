class EmployeesController < ApplicationController
  before_action :set_employee

  def show
    @is_in_attendance = !@employee.ongoing_attendance.nil?
  end

  # 出勤を記録する
  def punch_in
    @employee.punch_in(Time.current)
    redirect_to @employee
  end

  # 退勤を記録する
  def punch_out
    @employee.punch_out(Time.current)
    redirect_to @employee
  end

  private

  def set_employee
    @employee = current_employee
    redirect_to root_path if @employee.nil?
  end
end
