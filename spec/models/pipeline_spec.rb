require 'rails_helper'

RSpec.describe Pipeline, type: :model do
  it { should have_many(:rules) }
end
