require 'rails_helper'

RSpec.describe RowLink, type: :model do
  it { should belong_to(:source_row).class_name(Row.to_s) }
  it { should belong_to(:target_row).class_name(Row.to_s) }
end
