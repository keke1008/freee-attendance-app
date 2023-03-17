# 一回の出勤～退勤の時間を表す
class Attendance < ApplicationRecord
  belongs_to :employee
end
