require 'rails_helper'

RSpec.describe FileFormat, type: :model do
  it { should have_many(:files) }
  it {
    should define_enum_for(:state)
      .with_values(FileFormat::STATE_ENUM_VALUES)
      .with_suffix(true)
      .backed_by_column_of_type(:string)
  }
end
