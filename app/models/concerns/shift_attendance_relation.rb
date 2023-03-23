require 'active_support'

# 勤怠/シフトと，シフト/勤怠の関係性
class Relation
  attr_reader :source, :related

  # :correspond => 対応する勤怠/シフトが存在し，時間のずれもない
  # :missing => 対応する勤怠/シフトが存在しない
  # :wrong_time => 対応する勤怠/シフトが存在するが，時間のずれがある
  STATUS = %i[correspond missing wrong_time].freeze

  def initialize(status, source, related = nil)
    raise ArgumentError("status must be one of #{STATUS}") unless STATUS.include?(status)

    @status = status
    @source = source
    @related = related
  end

  def related? = @status == :related
  def missing? = @status == :missing
  def wrong_time? = @status == :wrong_time
end

module ShiftAttendanceRelation
  extend ActiveSupport::Concern

  included do
    scope :join_related_model, lambda { |source_table, related_table, _related_class|
      joins(sanitize_sql([<<~SQL.squish, { source_table:, related_table: }]))
        LEFT OUTER JOIN :related_table
          ON :source_table.employee_id = :related_table.employee_id
          AND :source_table.date = :related_table.date
          AND :source_table.end_at > :related_table.begin_at
          AND :source_table.begin_at < :related_table.end_at
      SQL
        .select(sanitize_sql([<<~SQL.squish, { source_table:, related_table: }]))
          :source_table.*,
          :related_table.id AS related_id,
          :related_table.date AS related_date,
          :related_table.begin_at AS related_begin_at,
          :related_table.end_at AS related_end_at,
          :related_table.duration_sec AS related_duration_sec
        SQL
    }
  end

  # 対応する勤怠/シフトに対し，begin_atまたはend_atにずれが生じている場合，trueを返す
  def wrong_time?(source_record, offset)
    valid_begin_range = (source_record.begin_at - offset)..(source_record.begin_at + offset)
    valid_end_range = (source_record.end_at - offset)..(source_record.end_at + offset)
    !valid_begin_range.cover?(begin_at) || !valid_end_range.cover?(end_at)
  end

  module ClassMethods
    # 対応する勤怠/シフトが存在するRelationの配列を返す
    def with_relation(source_table, related_table, related_class, offset)
      collect_related_model(source_table, related_table, related_class).map do |records|
        source_record = records[:source]
        related_records = records[:related]

        Relation.new(:missing, source_record) if related_records.empty?

        wrong_time_related_records = related_records.filter do |shift|
          source_record.wrong_time?(shift, offset)
        end
        next Relation.new(:wrong_time, source_record, wrong_time_related_records) if wrong_time_related_records.present?

        Relation.new(:correspond, source_record, related_records)
      end
    end

    private

    def collect_related_model(source_table, related_table, related_class)
      join_related_model(source_table, related_table, related_class)
        .group_by(&:id)
        .map do |_, records|
        {
          source: records.first,
          related: records.filter_map { |record| create_related_record(record, related_class) }
        }
      end
    end

    def create_related_record(record, related_class)
      return if record.related_id.nil?

      related_class.new(
        id: record.related_id,
        date: record.related_date,
        begin_at: record.related_begin_at,
        end_at: record.related_end_at,
        duration_sec: record.related_duration_sec
      ).tap(&:readonly!)
    end
  end
end
