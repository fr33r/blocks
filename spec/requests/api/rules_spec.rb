require 'rails_helper'
require 'swagger_helper'

RSpec.describe "Api::Rules", type: :request do
  path '/api/formats/{format_id}/pipelines/{pipeline_id}/rules' do
    post 'Creates new rule' do
      tags 'Rules'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :rule, in: :body, required: true
      parameter name: :format_id, in: :path, required: true
      parameter name: :pipeline_id, in: :path, required: true

      response '201', 'Rule created' do
        let(:format_id) { SecureRandom.uuid }
        let(:pipeline_id) { pipeline.id }
        let!(:pipeline) do
          create(:pipeline)
        end
        let(:rule) do
          {
            name: 'COLUMN_1 is foo',
            description: 'Determines if COLUMN_1 is foo.',
            type: 'validation',
            condition: {'==' => [{ 'var' => 'COLUMN_1'}, 'foo' ]},
          }
        end
        run_test!
      end
    end

    get 'Retrieves collection of rules' do
      tags 'Rules'
      produces 'application/json'
      parameter name: :format_id, in: :path, required: true
      parameter name: :pipeline_id, in: :path, required: true

      response '200', 'Collection retrieved' do
        let(:format_id) { SecureRandom.uuid }
        let(:pipeline_id) { pipeline.id }
        let!(:pipeline) do
          create(:pipeline, :with_active_rules, :with_inactive_rules)
        end

        context 'without any query parameters' do
          run_test! do |response|
            body = JSON.parse(response.body)

            expect(body.count).to eq(pipeline.rules.count)
          end
        end
      end
    end
  end

  path '/api/formats/{format_id}/pipelines/{pipeline_id}/rules/{id}' do
    get 'Retrieves a single rule' do
      tags 'Rules'
      produces 'application/json'
      parameter name: :format_id, in: :path, required: true
      parameter name: :pipeline_id, in: :path, required: true
      parameter name: :id, in: :path, required: true

      response '200', 'Rule retrieved' do
        let(:format_id) { SecureRandom.uuid }
        let(:pipeline_id) { pipeline.id }
        let(:id) { existing_rule.id }
        let(:existing_rule) { pipeline.rules.first }
        let!(:pipeline) do
          create(:pipeline, :with_active_rules, rule_count: 1)
        end

        run_test! do |response|
          body = JSON.parse(response.body)

          expect(body['id']).to eq(existing_rule.id)
          expect(body['name']).to eq(existing_rule.name)
          expect(body['description']).to eq(existing_rule.description)
          expect(body['type']).to eq(existing_rule.rule_type)
          expect(body['state']).to eq(existing_rule.state)
          expect(body['condition']).to eq(existing_rule.condition)
        end
      end
    end

    patch 'Modifies a single rule' do
      tags 'Rules'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :patch_operations, in: :body, required: true
      parameter name: :format_id, in: :path, required: true
      parameter name: :pipeline_id, in: :path, required: true
      parameter name: :id, in: :path, required: true

      response '200', 'Rule modified' do
        let(:pipeline_id) { SecureRandom.uuid }
        let(:stream) { "Pipeline#{pipeline_id}" }

        before do
          AggregateRoot::Repository
            .new
            .with_aggregate(Evaluation::Pipeline.new(pipeline_id), stream) do |pipeline|
              pipeline.create
              pipeline.create_rule({
                name: 'COLUMN_1 is foo',
                description: 'Determines if COLUMN_1 is foo.',
                type: 'validation',
                condition: {'==' => [{ 'var' => 'COLUMN_1'}, 'foo' ]},
                pipeline_id: pipeline_id,
                created_by: SecureRandom.uuid,
              })
            end
        end

        let(:format_id) { SecureRandom.uuid }
        let(:id) { existing_rule.id }
        let(:existing_rule) { pipeline.rules.first }
        let(:pipeline) do
          AggregateRoot::Repository.new.load(
            Evaluation::Pipeline.new(pipeline_id),
            stream,
          )
        end
        let(:patch_operations) do
          [
            { op: 'replace', path: '/name', value: 'New name' },
            { op: 'replace', path: '/description', value: 'New description' },
          ]
        end

        run_test! do |response|
          body = JSON.parse(response.body)

          expect(body['name']).to eq(patch_operations.first.fetch(:value))
          expect(body['description']).to eq(patch_operations.second.fetch(:value))
        end
      end
    end
  end
end
