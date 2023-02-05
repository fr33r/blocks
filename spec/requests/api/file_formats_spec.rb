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
          {
            name: "TEST FORMAT",
            description: "This is a test file format",
            columns: [{
              name: "COLUMN_1",
              description: "This is a cool thing",
              required: true,
              data_type: "string"
            },{
              name: "COLUMN_2",
              description: "This is another cool thing",
              required: true,
              data_type: "string"
            },
            {
              name: "COLUMN_3",
              description: "This is the last cool thing",
              required: false,
              data_type: "integer"
            }],
            anchors: [{
              name: "Cool thing",
              description: "Links cool things",
              columns: [ "COLUMN_1" ]
            },{
              name: "Another cool thing",
              description: "Links other cool things",
              columns: [ "COLUMN_2" ]
            }]
          }
        end

        run_test! do |response|
          body = JSON.parse(response.body)

          # format assertions.
          expect(body['id']).to be
          expect(body['name']).to eq(format[:name])
          # expect(body['description']).to eq(format[:description])

          # column assertions.
          columns = body['columns']
          expected_columns = format[:columns]
          expect(columns.count).to eq(expected_columns.count)
          expected_columns.each do |expected_column|
            column = columns.find { |c| c['name'].downcase == expected_column[:name].downcase }
            expect(column).to_not eq(nil)
            expect(column['required']).to eq(expected_column[:required])
            expect(column['data_type']).to eq(expected_column[:data_type])
            expect(column['description']).to eq(expected_column[:description])
          end

          # anchor assertions.
          anchors = body['anchors']
          expected_anchors = format[:anchors]
          expect(anchors.count).to eq(expected_anchors.count)
          expected_anchors.each do |expected_anchor|
            anchor = anchors.find { |c| c['name'].downcase == expected_anchor[:name].downcase }
            expect(anchor).to_not eq(nil)
            expect(anchor['name']).to eq(expected_anchor[:name])
            expect(anchor['description']).to eq(expected_anchor[:description])
          end
        end
      end
    end

    get 'Retrieves collection of formats' do
      tags 'Formats'
      produces 'application/json'

      response '200', 'Collection retrieved' do
        context 'without any query parameters' do
          before do
            create(:file_format, :with_columns, :with_anchors)
            create(:file_format, :with_columns, :with_anchors)
            create(:file_format, :with_columns, :with_anchors)
          end

          run_test! do |response|
            body = JSON.parse(response.body)

            expect(body.count).to eq(3)
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
        let(:id) { existing_format.id }
        let(:existing_format) do
          create(:file_format, :with_columns, :with_anchors)
        end

        run_test! do |response|
          body = JSON.parse(response.body)

          expect(body['id']).to eq(existing_format.id)
          expect(body['name']).to eq(existing_format.name)
          expect(body['columns'].count).to eq(existing_format.columns.count)
          expect(body['anchors'].count).to eq(existing_format.anchors.count)
        end
      end
    end
  end
end
