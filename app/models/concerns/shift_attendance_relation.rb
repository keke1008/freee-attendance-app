require 'active_support'

module ShiftAttendanceRelation
  extend ActiveSupport::Concern

  included do
    scope :order_by_datetime, -> { order(:date, :begin_at, :end_at) }
  end

  # 対応する勤怠/シフトに対し，begin_atまたはend_atにずれが生じている場合，trueを返す
  def wrong_time?(source_record, offset = 10.minutes)
    valid_begin_range = (source_record.begin_at - offset)..(source_record.begin_at + offset)
    valid_end_range = (source_record.end_at - offset)..(source_record.end_at + offset)
    !valid_begin_range.cover?(begin_at) || !valid_end_range.cover?(end_at)
  end
end
