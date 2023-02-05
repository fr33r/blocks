# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::RulesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: 'api/formats/1/pipelines/2/rules')
        .to route_to('api/rules#index', format_id: '1', pipeline_id: '2')
    end

    it 'routes to #create' do
      expect(post: 'api/formats/1/pipelines/2/rules')
        .to route_to('api/rules#create', format_id: '1', pipeline_id: '2')
    end

    it 'routes to #show' do
      expect(get: 'api/formats/1/pipelines/2/rules/3')
        .to route_to('api/rules#show', format_id: '1', pipeline_id: '2', id: '3')
    end

    it 'routes to #patch' do
      expect(patch: 'api/formats/1/pipelines/2/rules/3')
        .to route_to('api/rules#patch', format_id: '1', pipeline_id: '2', id: '3')
    end
  end
end
