# マネージャーのもとで働く人を表す
class Employee < ApplicationRecord
  belongs_to :manager

  validates :name, presence: true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
