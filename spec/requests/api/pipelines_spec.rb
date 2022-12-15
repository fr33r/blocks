require 'rails_helper'
require 'swagger_helper'

RSpec.describe "Api::Pipelines", type: :request do
  path '/api/formats/{format_id}/pipelines' do
    post 'Creates new pipeline' do
      tags 'Pipelines'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :pipeline, in: :body, required: true
      parameter name: :format_id, in: :path, required: true

      response '201', 'Pipeline created' do
        let(:format_id) { SecureRandom.uuid }
        let(:pipeline) do
          {}
        end
        run_test!
      end
    end

    get 'Retrieves collection of pipelines' do
      tags 'Pipelines'
      produces 'application/json'
      parameter name: :format_id, in: :path, required: true

      response '200', 'Collection retrieved' do
        let(:format_id) { SecureRandom.uuid }

        context 'without any query parameters' do
          before do
            create(:pipeline)
          end

          run_test! do |response|
            body = JSON.parse(response.body)

            expect(body.count).to eq(1)
          end
        end
      end
    end
  end

  path '/api/formats/{format_id}/pipelines/{id}' do
    get 'Retrieves a single pipeline' do
      tags 'Pipelines'
      produces 'application/json'
      parameter name: :format_id, in: :path, required: true
      parameter name: :id, in: :path, required: true

      response '200', 'Pipeline retrieved' do
        let(:format_id) { SecureRandom.uuid }
        let(:id) { existing_pipeline.id }
        let!(:existing_pipeline) do
          create(:pipeline)
        end

        run_test! do |response|
          body = JSON.parse(response.body)

          expect(body['id']).to eq(existing_pipeline.id)
        end
      end
    end
  end
end
