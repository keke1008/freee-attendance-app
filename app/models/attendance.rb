# 一回の出勤～退勤の時間を表す
class Attendance < ApplicationRecord
  belongs_to :employee
  before_save :set_duration_sec
  validates :end_at, comparison: { greater_than: :begin_at }
  validate :check_overlapping

  scope :collect_duration_sec, -> { eager_load(:employee).group(:employee).sum(:duration_sec) }

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
