require 'rails_helper'
require 'swagger_helper'

RSpec.describe "Api::Files", type: :request do
  path '/api/formats/{format_id}/files' do
    post 'Creates new file' do
      tags 'Files'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :file, in: :body, required: true
      parameter name: :format_id, in: :path, required: true

      response '201', 'Format created' do
        let(:file) do
          {}
        end
        run_test!
      end
    end

    get 'Retrieves collection of files' do
      tags 'Files'
      produces 'application/json'

      response '200', 'Collection retrieved' do
        context 'without any query parameters' do
          before do
          end

          run_test! do |response|
            body = JSON.parse(response.body)

            expect(body.count).to eq(1)
          end
        end
      end
    end
  end

  path '/api/formats/{format_id}/files/{id}' do
    get 'Retrieves a single file' do
      tags 'Files'
      produces 'application/json'
      parameter name: :id, in: :path, required: true
      parameter name: :format_id, in: :path, required: true

      response '200', 'File retrieved' do
        let(:id) { SecureRandom.uuid }
        let!(:existing_file) do
          {}
        end

        run_test! do |response|
          body = JSON.parse(response.body)
        end
      end
    end
  end
end
