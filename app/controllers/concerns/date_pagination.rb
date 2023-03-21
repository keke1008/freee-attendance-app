# 日付の範囲
class Span
  attr_reader :span

  DAY = 'day'.freeze
  WEEK = 'week'.freeze
  MONTH = 'month'.freeze

  # Module#constantsでは順番が保証されないため
  def self.all_spans = [self::DAY, self::WEEK, self::MONTH].map { |s| Span.new(s) }

  def initialize(span_like)
    spans = [Span::DAY, Span::WEEK, Span::MONTH]
    @span = spans.include?(span_like) ? span_like : Span::DAY
  end

  def day? = @span == Span::DAY
  def week? = @span == Span::WEEK
  def month? = @span == Span::MONTH

  def date_range(date)
    date.send("all_#{@span}")
  end

  def next_date(date) = date + offset
  def previous_date(date) = date - offset

  def to_s
    @span
  end

  def ==(other) = @span == other.span

  private

  def offset = 1.send(span)
end

# ページネーションを行うクラス
class Page
  private

  def create_link_param(params)
    @params.merge(params)
  end

  public

  def initialize(date, span, request)
    @date = date
    @span = span
    @params = request.params
  end

  def now_link_param = create_link_param(span: @span.to_s, date: nil)
  def next_link_param = create_link_param(date: @span.next_date(@date), span: @span.to_s)
  def previous_link_param = create_link_param(date: @span.previous_date(@date), span: @span.to_s)

  def span_change_nav_props
    props = Struct.new('Props', :name, :current?, :link_param)
    Span.all_spans.map do |span|
      props.new(
        name: I18n.t("datetime.prompts.#{span}"),
        current?: span == @span,
        link_param: create_link_param(date: @date, span: span.to_s)
      )
    end
  end

  def date_range = @span.date_range(@date)

  def current_span_string
    if @span.day?
      I18n.l(@date)
    elsif @span.week?
      "#{I18n.l(date_range.first)} ~ #{I18n.l(date_range.last)}"
    else
      I18n.l(@date, format: :year_month)
    end
  end
end

module DatePagination
  def paginate
    date = date_from_params
    span = span_from_params
    Page.new(date, span, request)
  end

  private

  # paramsの:dateを参照し，Dateを返す
  # デフォルトは今日の日付
  def date_from_params = params[:date]&.to_date || Date.current

  # paramsの:spanを参照し，Spanを返す
  def span_from_params = Span.new(params[:span])
end
