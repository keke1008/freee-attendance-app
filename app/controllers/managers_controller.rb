class ManagersController < ApplicationController
  include DatePagination

  before_action :set_manager

  def show
    @page = paginate
    @employees = @manager.employee
    @graph_data = [
      { name: I18n.t('common.attendance_time'), data: to_graph_data(Attendance) },
      { name: I18n.t('common.shift'), data: to_graph_data(Shift) }
    ]
  end

  private

  def to_graph_data(model)
    model.where(
      date: @page.date_range,
      employee: @manager.employee
    ).collect_duration_sec.map do |employee, duration_sec|
      duration_hours = duration_sec.fdiv(3600).ceil(1) # 秒 => 時間
      [employee.name, duration_hours]
    end
  end
end
