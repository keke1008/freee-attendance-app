class Shift < ApplicationRecord
  include ShiftAttendanceRelation

  belongs_to :employee
  has_many :attendances, foreign_key: :employee_id, primary_key: :employee_id, inverse_of: :employee, dependent: nil

  before_save :set_duration_sec
  validates :end_at, comparison: { greater_than: :begin_at }
  validate :check_overlapping

  scope :collect_duration_sec, -> { eager_load(:employee).group(:employee).sum(:duration_sec) }

  scope :attendance_relations, ->(offset) { with_relation(:shifts, :attendances, Attendance, offset) }

  private

  def check_overlapping
    return unless Shift
                  .where.not(id:) # 自身を除く
                  .where(employee:, date:) # 同じ従業員，同じ日
                  .exists?(['begin_at < ? AND end_at > ?', end_at, begin_at]) # 重なっている

    errors.add(:begin_at, I18n.t('errors.messages.shift_overlapped'))
    errors.add(:end_at, I18n.t('errors.messages.shift_overlapped'))
  end

  def set_duration_sec
    self.duration_sec = end_at - begin_at
  end
end
