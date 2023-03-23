# 一回の出勤～退勤の時間を表す
class Attendance < ApplicationRecord
  include ShiftAttendanceRelation

  before_save :set_duration_sec
  validates :end_at, comparison: { greater_than: :begin_at }
  validate :check_overlapping

  belongs_to :employee
  has_many :shifts, foreign_key: :employee_id, primary_key: :employee_id, inverse_of: :employee, dependent: nil

  # HACK: 無理やりON句に条件を入れている．
  # あらかじめeager_load(:overlapped_shifts)せずに各レコードのrelatedを呼び出すとエラーが出る
  has_many :overlapped_shifts, lambda {
    where(<<~SQL.squish)
      shifts.date = attendances.date
        AND shifts.begin_at < attendances.end_at
        AND shifts.end_at > attendances.begin_at
    SQL
  }, through: :employee, source: :shifts

  scope :collect_duration_sec, -> { eager_load(:employee).group(:employee).sum(:duration_sec) }

  scope :eager_find, ->(id) { eager_load(:overlapped_shifts).find(id) }

  # :corresponding => 対応するシフトが存在し，時間のずれもない
  # :missing => 対応するシフトが存在しない
  # :wrong_time => 対応するシフトが存在するが，時間のずれがある
  def relation
    return [:missing, []] if overlapped_shifts.empty?

    wrong_time_shifts = overlapped_shifts.filter { |shift| wrong_time?(shift) }
    return [:wrong_time, wrong_time_shifts] if wrong_time_shifts.present?

    [:corresponding, overlapped_shifts]
  end

  def error?
    relation[0] != :corresponding
  end

  private

  def check_overlapping
    return unless Attendance
                  .where.not(id:) # 自身を除く
                  .where(employee:, date:) # 同じ従業員，同じ日
                  .exists?(['begin_at < ? AND end_at > ?', end_at, begin_at]) # 重なっている

    errors.add(:begin_at, I18n.t('errors.messages.attendance_overlapped'))
    errors.add(:end_at, I18n.t('errors.messages.attendance_overlapped'))
  end

  def set_duration_sec
    self.duration_sec = end_at - begin_at
  end
end
