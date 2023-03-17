# まだ退勤していない出勤の時間を表す
class OngoingAttendance < ApplicationRecord
  belongs_to :employee
end
