# frozen_string_literal: true

class TablePaginationFooterComponent < ViewComponent::Base
  def initialize(total:, limit:, current_page: 1)
    @total = total.to_i
    @offset = ((current_page.to_i-1) * limit.to_i)
    @limit = limit.to_i
    @page_count = total.to_i / limit.to_i
    @current_page = current_page.to_i
  end

  def previous_page
    return @current_page if first_page?

    @current_page - 1
  end

  def next_page
    return @current_page if last_page?

    @current_page + 1
  end

  def previous_offset
    return 0 if first_page?

    @offset - @limit
  end

  def next_offset
    return @total if last_page?

    @offset + @limit
  end

  def start_num
    @offset + 1
  end

  def end_num
    num = @offset + @limit
    num <= @total ? num : @total
  end

  def hide?
    @page_count == 1
  end

  def show?
    !hide?
  end

  def last_page?
    @current_page == @page_count
  end

  def first_page?
    @current_page == 1
  end

  def previous?
    !first_page?
  end

  def next?
    !last_page?
  end
end
