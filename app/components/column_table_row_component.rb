# frozen_string_literal: true

class ColumnTableRowComponent < ViewComponent::Base
  def initialize(column:)
    @column = column
  end
end
