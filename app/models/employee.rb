class ManagerIdValidator < ActiveModel::Validator
  def validate(record)
    return if Manager.find_by(id: record.manager_id).present?

    record.errors.add(:manager_id, I18n.t('errors.messages.manager_not_found'))
  end
end

# マネージャーのもとで働く人を表す
class Employee < ApplicationRecord
  belongs_to :manager

  validates :name, presence: true
  validates_with ManagerIdValidator

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
