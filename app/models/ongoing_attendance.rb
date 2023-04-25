# まだ退勤していない出勤の時間を表す
class OngoingAttendance < ApplicationRecord
  belongs_to :employee

  # 出勤を終了させ，出勤時間と退勤時間を`Attendance`へ記録する
  def punch_out(end_at)
    transaction do
      employee.attendances.create!(date: begin_at.to_date, begin_at:, end_at:)
      destroy!
    end
  end
end
