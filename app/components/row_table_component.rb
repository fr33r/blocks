# frozen_string_literal: true

class RowTableComponent < ViewComponent::Base
  def initialize(rows:, total_rows:, page_size:, show_actions: true)
    @rows = rows
    @show_actions = show_actions
    @page_size = page_size
    @total_rows = total_rows
  end
end
