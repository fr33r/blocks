require 'rails_helper'

RSpec.describe Anchor, type: :model do
  it { should belong_to(:file_format) }
  it { should have_many(:anchor_values) }
  it { should have_and_belong_to_many(:columns) }
  it { should validate_presence_of(:name) }
end
