require 'rails_helper'

RSpec.describe Data::Row do
  subject { described_class.new(id) }

  let(:id) { SecureRandom.uuid }

  context '#upload' do
    let(:data) { { 'COLUMN_1' => 'foo', 'COLUMN_2' => 'bar' } }

    before { subject.upload(data) }

    it { should have_applied(event(Data::Events::RowUploaded)).once.strict }
  end

  context '#update_data' do
    let(:data) { { 'COLUMN_1' => 'foo', 'COLUMN_2' => 'bar' } }

    before { subject.update_data(data) }

    it { should have_applied(event(Data::Events::RowUpdated)).once.strict }
  end

  context '#filter' do
    before { subject.filter }

    it { should have_applied(event(Data::Events::RowFiltered)).once.strict }
  end

  context '#ingest' do
    before { subject.ingest }

    it { should have_applied(event(Data::Events::RowIngested)).once.strict }
  end

  context '#evaluate' do
    context 'no errors occur' do
      before do
        pipeline_double = double
        allow(pipeline_double).to receive(:execute!).with(subject).and_return([])
        subject.evaluate(pipeline_double)
      end

      it { should have_applied(event(Data::Events::RowValidated)).once.strict }
    end

    context 'errors occur' do
      let(:error) { Data::Row::Error.new('oops!', SecureRandom.uuid) }

      before do
        pipeline_double = double
        allow(pipeline_double).to receive(:execute!).with(subject).and_return([error])
        subject.evaluate(pipeline_double)
      end

      it { should have_applied(event(Data::Events::RowInvalidated)).once.strict }
    end
  end
end
