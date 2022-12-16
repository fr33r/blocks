require 'rails_helper'

RSpec.describe Data::Events do
  describe Data::Events::RowUploaded do
    it { should be_an_event(described_class) }
  end

  describe Data::Events::RowUpdated do
    it { should be_an_event(described_class) }
  end

  describe Data::Events::RowFiltered do
    it { should be_an_event(described_class) }
  end

  describe Data::Events::RowValidated do
    it { should be_an_event(described_class) }
  end

  describe Data::Events::RowInvalidated do
    it { should be_an_event(described_class) }
  end

  describe Data::Events::RowIngested do
    it { should be_an_event(described_class) }
  end

  describe Data::Events::FileUploaded do
    it { should be_an_event(described_class) }
  end

  describe Data::Events::FileProcessing do
    it { should be_an_event(described_class) }
  end

  describe Data::Events::FileProcessed do
    it { should be_an_event(described_class) }
  end

  describe Data::Events::FileFormatCreated do
    it { should be_an_event(described_class) }
  end

  describe Data::Events::FileFormatActivated do
    it { should be_an_event(described_class) }
  end

  describe Data::Events::FileFormatInactivated do
    it { should be_an_event(described_class) }
  end
end
