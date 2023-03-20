class Shift < ApplicationRecord
  belongs_to :employee
  validates :end_at, comparison: { greater_than: :begin_at }
  validate :check_same_employee_overlapping

  def check_same_employee_overlapping
    return unless Shift.where.not(id:)
                       .where(employee:)
                       .where.not('end_at <= ? OR ? <= begin_at', begin_at, end_at)
                       .exists?

    errors.add(:begin_at, I18n.t('errors.messages.shift_overlapped'))
    errors.add(:end_at, I18n.t('errors.messages.shift_overlapped'))
  end
end
