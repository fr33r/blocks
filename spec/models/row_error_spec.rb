require 'rails_helper'

RSpec.describe RowError, type: :model do
  it { should belong_to(:row) }
end
