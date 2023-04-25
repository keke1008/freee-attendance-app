class ManagerIdValidator < ActiveModel::Validator
  def validate(record)
    return if Manager.find_by(id: record.manager_id).present?

    record.errors.add(:manager_id, I18n.t('errors.messages.manager_not_found'))
  end
end

# マネージャーのもとで働く人を表す
class Employee < ApplicationRecord
  belongs_to :manager
  has_one :ongoing_attendance, required: false, dependent: :destroy
  has_many :attendances, dependent: :destroy
  has_many :shifts, dependent: :destroy

  validates :name, presence: true
  validates_with ManagerIdValidator

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def punch_in(begin_at)
    create_ongoing_attendance(begin_at:) if ongoing_attendance.nil?
  end

  delegate :punch_out, to: :ongoing_attendance, allow_nil: true
end
