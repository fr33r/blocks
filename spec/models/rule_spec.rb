require 'rails_helper'

RSpec.describe Rule, type: :model do
  it { should belong_to(:pipeline) }
end
