# 表示範囲の種類
module Spans
  # 一日
  DAY = 'day'.freeze

  # 一週間
  WEEK = 'week'.freeze

  # 一月
  MONTH = 'month'.freeze

  def self.all_spans
    # Module#constantsでは順番が保証されないため
    [self::DAY, self::WEEK, self::MONTH]
  end

  def self.from_untyped(span)
    all_spans.include?(span) ? span : Spans::DAY
  end

  def self.date_range(date, span)
    date.send("all_#{span}")
  end
end

module SpanPagination
  extend ActiveSupport::Concern

  def set_pagination
    date = date_from_params
    span = span_from_params

    @date_range = aggrigate_date_range(date, span)
    @pagination = {
      current_span_string: current_span_string(date, @date_range, span),
      link_params: link_params(date, span)
    }
  end

  private

  # paramsの:dateを参照し，Dateを返す
  # デフォルトは今日の日付
  def date_from_params
    params[:date]&.to_date || Date.current
  end

  # paramsの:spanを参照し，'day', 'week', 'month'のうちどれかを返す
  # デフォルトは'day'
  def span_from_params
    span = params[:span]
    Spans.from_untyped(span)
  end

  # 集計するデータの範囲を返す
  def aggrigate_date_range(date, span)
    date.send("all_#{span}")
  end

  # 「現在表示している日付の範囲」を表す文字列を返す
  def current_span_string(date, date_range, span)
    case span
    when Spans::DAY
      I18n.l(date)
    when Spans::WEEK
      "#{I18n.l(date_range.first)} ~ #{I18n.l(date_range.last)}"
    else
      I18n.l(date, format: :year_month)
    end
  end

  # 集計範囲の前の日付と次の日付を計算する
  def previous_and_next_date(date, span)
    offset = 1.send(span.to_s)
    [date.ago(offset), date.since(offset)]
  end

  # 表示範囲を変更するためのリンクのパラメータ
  def link_params(date, span)
    previous_date, next_date = previous_and_next_date(date, span)
    {
      now: { span: },
      previous: { date: previous_date, span: },
      next: { date: next_date, span: },
      spans: Spans.all_spans.map do |name|
               { name:, current?: name == span, params: { date:, span: name } }
             end
    }
  end
end
