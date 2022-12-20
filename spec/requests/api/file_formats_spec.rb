require 'rails_helper'
require 'swagger_helper'

RSpec.describe "Api::FileFormats", type: :request do
  path '/api/formats' do
    post 'Creates new file format' do
      tags 'Formats'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :format, in: :body, required: true

      response '201', 'Format created' do
        let(:format) do
          {}
        end
        run_test!
      end
    end

    get 'Retrieves collection of formats' do
      tags 'Formats'
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

  path '/api/formats/{id}' do
    get 'Retrieves a single file format' do
      tags 'Formats'
      produces 'application/json'
      parameter name: :id, in: :path, required: true

      response '200', 'Format retrieved' do
        let(:id) { SecureRandom.uuid }
        let!(:existing_format) do
          {}
        end

        run_test! do |response|
          body = JSON.parse(response.body)
        end
      end
    end
  end
end