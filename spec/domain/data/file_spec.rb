require 'rails_helper'

RSpec.describe Data::File do
  subject { described_class.new(id) }

  let(:id) { SecureRandom.uuid }

  context '#upload' do
    let(:filename) { 'foo.csv' }

    before { subject.upload(filename: filename) }

    it { should have_applied(event(Data::Events::FileUploaded)).once.strict }
  end

  context '#processing' do
    before { subject.processing }

    it { should have_applied(event(Data::Events::FileProcessing)).once.strict }
  end

  context '#processed' do
    before { subject.processed}

    it { should have_applied(event(Data::Events::FileProcessed)).once.strict }
  end
end
