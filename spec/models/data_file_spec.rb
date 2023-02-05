require 'rails_helper'

RSpec.describe DataFile, type: :model do
  it { should belong_to(:file_format) }
  it { should have_many(:rows) }
  it {
    should define_enum_for(:state)
      .with_values(DataFile::STATE_ENUM_VALUES)
      .with_suffix(true)
      .backed_by_column_of_type(:string)
  }
  it { should validate_presence_of(:filename) }
  it { should validate_presence_of(:total_row_count) }
end
