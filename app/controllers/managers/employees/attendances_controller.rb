class Managers::Employees::AttendancesController < ApplicationController
  before_action :set_manager_and_employee
  before_action :set_attendance, only: %i[show edit update destroy]

  def show; end

  def new
    @attendance = Attendance.new
  end

  def edit; end

  def create
    @attendance = Attendance.new(attendance_params)
    @attendance.employee = @employee
    return if @attendance.save

    render :new, status: :unprocessable_entity
  end

  def update
    return if @attendance.update(attendance_params)

    render :edit, status: :unprocessable_entity
  end

  def destroy
    @attendance.destroy
  end

  private

  def attendance_params
    params.require(:attendance).permit(:date, :begin_at, :end_at)
  end

  def set_attendance
    @attendance = Attendance.find(params[:id])
  end
end
