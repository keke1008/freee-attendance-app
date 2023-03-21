class ManagersController < ApplicationController
  include DatePagination

  before_action :set_manager

  def show
    @page = paginate
    @graph_data = collect_graph_data(@page.date_range)
    @employees = @manager.employee
  end

  private

  # rangeと重複しているデータを返す
  def overlapped_data(range)
    cond = { begin_at: ..range.last, end_at: range.first.. }
    @manager.employee
            .includes(:attendances, :shifts)
            .where(attendances: cond, shifts: cond)
  end

  # block: (秒数[]) => T
  # { attendance: { 従業員名 => T }, shift: { 従業員名 => T } } を返す
  def collect_record_with(range)
    data = { attendance: {}, shift: {} }
    overlapped_data(range).each do |employee|
      data[:attendance][employee.name] = yield(employee.attendances)
      data[:shift][employee.name] = yield(employee.shifts)
    end
    data
  end

  # collect_record_withの戻り値の単位を，秒から時間に変換する
  def collect_record_hours(range)
    collect_record_with(range) do |records|
      seconds = records
                .map { |record| record.end_at - record.begin_at }
                .sum
      (seconds / 60 / 60).ceil(1) # 秒 => 時間
    end
  end

  # グラフの入力データを返す
  def collect_graph_data(range)
    data = collect_record_hours(range)

    @manager.employee.each do |employee|
      data[:shift][employee.name] ||= 0
      data[:attendance][employee.name] ||= 0
    end
    [
      { name: I18n.t('common.shift'), data: data[:shift] },
      { name: I18n.t('common.attendance_time'), data: data[:attendance] }
    ]
  end
end
