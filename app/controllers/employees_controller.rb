class EmployeesController < ApplicationController
  before_action :set_employee

  def show
    @is_in_attendance = !@employee.ongoing_attendance.nil?
  end

  # 出勤を記録する
  def punch_in
    @employee.transaction do
      ongoing_attendance = @employee.ongoing_attendance
      @employee.create_ongoing_attendance(begin_at: DateTime.now) if ongoing_attendance.nil?
      redirect_to @employee
    end
  end

  # 退勤を記録する
  def punch_out
    @employee.transaction do
      ongoing_attendance = @employee.ongoing_attendance
      unless ongoing_attendance.nil?
        @employee.attendances.create!(begin_at: ongoing_attendance.begin_at, end_at: DateTime.now)
        @employee.ongoing_attendance.destroy
      end

      redirect_to @employee
    end
  end

  private

  def set_employee
    @employee = current_employee
    redirect_to root_path if @employee.nil?
  end
end
