class ManagersController < ApplicationController
  include SpanPagination

  before_action :set_manager
  before_action :set_pagination

  def show
    @employees = @manager.employee
    @employees_attendances = aggrigate_total_attendance_minute(@date_range)
  end

  private

  # { 従業員名 => block(従業員の出勤記録の配列) } を返す
  def aggrigate_employees_attendances(date_range)
    @manager.employee
            .includes(:attendances)
            .where(attendances: { begin_at: date_range })
            .map.to_h do |employee|
              [employee.name, yield(employee.attendances)]
            end
  end

  # { 従業員名 => 出勤時間の合計(分) } を返す
  def aggrigate_total_attendance_minute(date_range)
    # 従業員名 => 出勤時間の合計(分)
    employees_attendances = aggrigate_employees_attendances(date_range) do |attendances|
      seconds = attendances
                .map { |attendance| attendance.end_at - attendance.begin_at }
                .sum
      (seconds / 60).ceil # 秒 => 分
    end

    # date_range内で出勤しなかった従業員の出勤時間を0に
    @manager.employee.each { |employee| employees_attendances[employee.name] ||= 0 }

    employees_attendances
  end
end
