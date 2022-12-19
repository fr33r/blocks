require 'rails_helper'

RSpec.describe Data::Commands::CreateRow, type: :command do
  include Shoulda::Matchers::ActiveModel

  let(:id) { SecureRandom.uuid }
  let(:file_id) { SecureRandom.uuid }
  let(:format_id) { SecureRandom.uuid }
  let(:row_data) { { 'COLUMN_1' => 'foo' } }
  let(:created_by) { SecureRandom.uuid }
  let(:row_number) { 1 }

  subject do
    described_class.new(id, row_number, format_id, file_id, row_data, created_by)
  end
  
  it { should validate_presence_of(:id) }
  it { should validate_presence_of(:file_id) }
  it { should validate_presence_of(:format_id) }
  it { should validate_presence_of(:row_data) }
  it { should validate_presence_of(:row_number) }
  it { should validate_presence_of(:created_by) }
end
