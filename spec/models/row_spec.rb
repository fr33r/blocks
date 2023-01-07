require 'rails_helper'

RSpec.describe Row, type: :model do
  it { should have_many(:row_errors) }
  it { should have_many(:anchor_values) }
  it {
    should define_enum_for(:state)
      .with_values(Row::STATE_ENUM_VALUES)
      .with_suffix(true)
      .backed_by_column_of_type(:string)
  }

  describe '.with_hash' do
    let!(:expected_match) { create(:row, data_hash: 'BIZ') }

    before do
      create(:row, data_hash: 'FOO')
      create(:row, data_hash: 'BAR')
      create(:row, data_hash: 'BAZ')
    end

    it 'filters rows by hash' do
      expect(described_class.with_hash('BIZ').count).to eq(1)
      expect(described_class.with_hash('BIZ')).to match_array([expected_match])
    end
  end

  describe '#uploaded_at' do
    it 'indicates when the row was created' do
      expect(subject.uploaded_at).to eq(subject.created_at)
    end
  end

  describe '#uploaded_by' do
    it 'indicates the party that created the row' do
      expect(subject.uploaded_by).to eq(subject.created_by)
    end
  end
end
