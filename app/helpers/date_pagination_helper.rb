module DatePaginationHelper
  private

  def assert_is_page(page)
    raise ArgumentError('page is not instance of Page') unless page.is_a?(Page)
  end

  public

  def date_pagination_date_nav(page)
    assert_is_page(page)

    render(
      partial: 'date_pagination/date_nav',
      locals: {
        next_link_param: page.next_link_param,
        previous_link_param: page.previous_link_param
      }
    )
  end

  def date_pagination_span_nav(page)
    assert_is_page(page)

    render(
      partial: 'date_pagination/span_nav',
      locals: { nav_props: page.span_change_nav_props }
    )
  end

  def date_pagination_current_span(page)
    render(
      partial: 'date_pagination/current_span',
      locals: { current_span_string: page.current_span_string }
    )
  end

  def date_pagination_go_back_current_nav(page)
    render(
      partial: 'date_pagination/go_back_nav',
      locals: { nav_props: page.now_link_param }
    )
  end
end
