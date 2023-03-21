class Managers::EmployeesController < ApplicationController
  include DatePagination

  before_action :set_employee

  def show
    @page = paginate
    date_range = @page.date_range
    @attendances = @employee.attendances
                            .where('begin_at <= ? AND end_at >= ?', date_range.last, date_range.first)
                            .order(:bgin_at)
    @shifts = @employee.shifts
                       .where('begin_at <= ? AND end_at >= ?', date_range.last, date_range.first)
                       .order(:bgin_at)
  end

  private

  def set_employee
    set_manager
    return if @manager.nil?

    employee_id = params.permit(:id)[:id]
    @employee = current_manager.employee.find(employee_id)
  end
end
