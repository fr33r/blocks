# frozen_string_literal: true

class ColumnTableComponent < ViewComponent::Base
  def initialize(columns:)
    @columns = columns
  end
end
