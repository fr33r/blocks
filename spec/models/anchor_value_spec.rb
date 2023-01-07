require 'rails_helper'

RSpec.describe AnchorValue, type: :model do
  it { should belong_to(:anchor) }
  it { should belong_to(:row) }
  it { should validate_presence_of(:data) }
  it { should validate_presence_of(:data_hash) }
end
