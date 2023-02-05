# frozen_string_literal: true

class ColumnBadgeComponent < ViewComponent::Base
  attr_reader :column_name

  def initialize(column_name)
    @column_name = column_name
  end
end
