# frozen_string_literal: true

class TablePaginationFooterComponent < ViewComponent::Base
  MAX_PAGE_COUNT = 5
  COLLAPSED_PAGE_NUM = '...'

  def initialize(total:, limit:, max_page_count: MAX_PAGE_COUNT, current_page_num: 1)
    @total = total
    @offset = ((current_page_num-1) * limit) + 1
    @limit = limit
    @page_count = total / limit
    @end = (@offset + limit) > total ? total : (@offset + limit) - 1
    @start = @offset
    @current_page_num = current_page_num
    @max_page_count = max_page_count
  end

  def collapse?
    @page_count > @max_page_count
  end

  # amount of pages with numbers on each side of the current page if collapsing.
  def buffer
    1
  end

  def pages_from_start
    @current_page_num - 1
  end

  def pages_from_end
    @end - @current_page_num 
  end

  def left_collapse?
    pages_from_start > buffer
  end

  def right_collapse?
    pages_from_end > buffer
  end

  def start_page_num
    start_num = @current_page_num - buffer
    start_num < 1 ? @current_page_num : start_num
  end

  def end_page_num
    end_num = @current_page_num + buffer
    end_num > MAX_PAGE_COUNT ? @current_page_num : end_num
  end

  def pages
    return (1..@page_count).to_a unless collapse?

    results = []
    results << COLLAPSED_PAGE_NUM if left_collapse?
    nums = (start_page_num..end_page_num).to_a
    results.push(*nums)
    results << COLLAPSED_PAGE_NUM if right_collapse?
    results
  end
end
