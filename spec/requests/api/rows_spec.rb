require 'rails_helper'
require 'swagger_helper'

RSpec.describe "Api::Rows", type: :request do
  path '/api/formats/{format_id}/files/{file_id}/rows' do
    post 'Creates new row' do
      tags 'Rows'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :row, in: :body
      parameter name: :format_id, in: :path, required: true
      parameter name: :file_id, in: :path, required: true

      response '201', 'Row created' do
        let(:format_id) { SecureRandom.uuid }
        let(:file_id) { SecureRandom.uuid }
        let(:row) do
          { data: { 'COLUMN_1' => 'foo', 'COLUMN_2' => 'bar', 'COLUMN_3' => 'baz' } }
        end
        run_test!
      end
    end

    get 'Retrieves collection of rows' do
      tags 'Rows'
      produces 'application/json'
      parameter name: :format_id, in: :path, required: true
      parameter name: :file_id, in: :path, required: true
      parameter name: :hash, in: :query, required: false
      parameter name: :state, in: :query, required: false

      response '200', 'Collection retrieved' do
        let(:format_id) { SecureRandom.uuid }
        let(:file_id) { SecureRandom.uuid }

        context 'without any query parameters' do
          before do
            create(:row, :uploaded)
            create(:row, :filtered)
            create(:row, :valid)
            create(:row, :invalid)
            create(:row, :ingested)
          end

          run_test! do |response|
            body = JSON.parse(response.body)

            expect(body.count).to eq(5)
          end
        end

        context "filtered using 'hash' query parameter" do
          let(:hash) {}

          before do
            create(:row, :uploaded, data_hash: hash)
          end

          run_test! do |response|
            body = JSON.parse(response.body)

            expect(body.count).to eq(1)
            expect(body.first['hash']).to eq(hash)
          end
        end

        context "filtered using 'state' query parameter" do
          let(:state) { Data::Row::State::UPLOADED.to_s }

          before do
            create(:row, :uploaded)
          end

          run_test! do |response|
            body = JSON.parse(response.body)

            expect(body.count).to eq(1)
            expect(body.first['state']).to eq(state)
          end
        end
      end
    end
  end
end
