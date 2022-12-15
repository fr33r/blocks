require 'rails_helper'
require 'swagger_helper'

RSpec.describe "Api::Rows", type: :request do
  path '/api/formats/{format_id}/files/{file_id}/rows' do
    post 'Creates new row' do
      tags 'Rows'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :row, in: :body, required: true
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

    patch 'Modifies the collection rows' do
      tags 'Rows'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :patch_operations, in: :body, required: true
      parameter name: :format_id, in: :path, required: true
      parameter name: :file_id, in: :path, required: true

      before do
        create(:row, :uploaded)
      end

      response '204', 'Rows created' do
        let(:format_id) { SecureRandom.uuid }
        let(:file_id) { SecureRandom.uuid }
        let(:patch_operations) do
          [
            { op: 'add', path: '-', value: { data: { 'COLUMN_1' => 'foo' } } },
            { op: 'add', path: '-', value: { data: { 'COLUMN_1' => 'bar' } } },
            { op: 'add', path: '-', value: { data: { 'COLUMN_1' => 'baz' } } },
            { op: 'add', path: '-', value: { data: { 'COLUMN_1' => 'biz' } } },
            { op: 'add', path: '-', value: { data: { 'COLUMN_1' => 'zap' } } },
          ]
        end

        run_test! do
          expect(Row.count).to eq(patch_operations.count + 1)
        end
      end
    end
  end

  path '/api/formats/{format_id}/files/{file_id}/rows/{id}' do
    get 'Retrieves a single row' do
      tags 'Rows'
      produces 'application/json'
      parameter name: :format_id, in: :path, required: true
      parameter name: :file_id, in: :path, required: true
      parameter name: :id, in: :path, required: true

      response '200', 'Row retrieved' do
        let(:format_id) { SecureRandom.uuid }
        let(:file_id) { SecureRandom.uuid }
        let(:id) { existing_row.id }
        let!(:existing_row) do
          create(:row, :uploaded, data_hash: { 'COLUMN_1' => 'bing' })
        end

        run_test! do |response|
          body = JSON.parse(response.body)

          expect(body['data']).to eq(existing_row.data)
          expect(body['id']).to eq(existing_row.id)
        end
      end
    end

    put 'Replaces a single row' do
      tags 'Rows'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :row, in: :body, required: true
      parameter name: :format_id, in: :path, required: true
      parameter name: :file_id, in: :path, required: true
      parameter name: :id, in: :path, required: true

      response '200', 'Row replaced' do
        let(:format_id) { SecureRandom.uuid }
        let(:file_id) { SecureRandom.uuid }
        let(:id) { existing_row.id }
        let(:row) do
          { data: { 'COLUMN_1' => 'foo', 'COLUMN_2' => 'bar', 'COLUMN_3' => 'baz' } }
        end
        let!(:existing_row) do
          create(:row, :uploaded, data_hash: { 'COLUMN_1' => 'bing' })
        end

        run_test! do |response|
          body = JSON.parse(response.body)

          expect(body['data']).to eq(row.fetch(:data))
        end
      end
    end

    patch 'Modifies a single row' do
      tags 'Rows'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :patch_operations, in: :body, required: true
      parameter name: :format_id, in: :path, required: true
      parameter name: :file_id, in: :path, required: true
      parameter name: :id, in: :path, required: true

      response '200', 'Row modified' do
        let(:format_id) { SecureRandom.uuid }
        let(:file_id) { SecureRandom.uuid }
        let(:id) { existing_row.id }
        let(:patch_operations) do
          [{ op: 'replace', path: '/data', value: { 'COLUMN_1' => 'bang' } }]
        end
        let!(:existing_row) do
          create(:row, :uploaded, data_hash: { 'COLUMN_1' => 'bing' })
        end

        run_test! do |response|
          body = JSON.parse(response.body)

          expect(body['data']).to eq({ 'COLUMN_1' => 'bang' })
        end
      end
    end
  end
end
