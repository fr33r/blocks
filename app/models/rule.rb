# frozen_string_literal: true

class Rule < ApplicationRecord
  # associations.
  belongs_to :pipeline

  # enum values.
  STATE_ENUM_VALUES = Evaluation::Rule::STATES.to_h { |state| [state, state.to_s] }
  TYPE_ENUM_VALUES = Evaluation::Rule::TYPES.to_h { |type| [type, type.to_s] }

  # validations.
  enum state: STATE_ENUM_VALUES, _suffix: true
  enum rule_type: TYPE_ENUM_VALUES, _suffix: true
end
