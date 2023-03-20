# メソッドの引数のspanには，'day', 'week', 'month'のうちどれかが入る
class ManagersController < ApplicationController
  before_action :set_manager

  def show
    @date = date_from_params
    @span = span_from_params

    @date_range = aggrigate_date_range(@date, @span)
    @current_date_string = current_date_string(@date, @date_range, @span)
    @previous_date, @next_date = previous_and_next_date(@date, @span)

    @employees = @manager.employee
    @employees_attendances = aggrigate_total_attendance_minute(@date_range)
  end

  private

  # paramsの:dateを参照し，Dateを返す
  # デフォルトは今日の日付
  def date_from_params
    params[:date]&.to_date || Date.current
  end

  # paramsの:spanを参照し，'day', 'week', 'month'のうちどれかを返す
  # デフォルトは'day'
  def span_from_params
    span = params[:span]
    %w[day week month].include?(span) ? span : 'day'
  end

  # 集計するデータの範囲を返す
  def aggrigate_date_range(date, span)
    date.send("all_#{span}")
  end

  # 集計範囲の前の日付と次の日付を計算する
  def previous_and_next_date(date, span)
    offset = 1.send(span.to_s)
    [date.ago(offset), date.since(offset)]
  end

  # 「現在表示している日付の範囲」を表す文字列を返す
  def current_date_string(date, date_range, span)
    case span
    when 'day'
      I18n.l(date)
    when 'week'
      "#{I18n.l(date_range.first)} ~ #{I18n.l(date_range.last)}"
    else
      I18n.l(date, format: :year_month)
    end
  end

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
