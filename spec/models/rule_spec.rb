require 'rails_helper'

RSpec.describe Rule, type: :model do
  it { should belong_to(:pipeline) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:condition) }
  it {
    should define_enum_for(:state)
      .with_values(Rule::STATE_ENUM_VALUES)
      .with_suffix(true)
      .backed_by_column_of_type(:string)
  }
  it {
    should define_enum_for(:rule_type)
      .with_values(Rule::TYPE_ENUM_VALUES)
      .with_suffix(true)
      .backed_by_column_of_type(:string)
  }
end
