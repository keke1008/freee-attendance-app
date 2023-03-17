# 店舗と従業員を管理する人を表す
class Manager < ApplicationRecord
  has_many :employee, dependent: :nullify

  validates :name, presence: true
  validates :store_name, presence: true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
