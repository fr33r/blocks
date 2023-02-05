# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::PipelinesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: 'api/formats/1/pipelines')
        .to route_to('api/pipelines#index', format_id: '1')
    end

    it 'routes to #show' do
      expect(get: 'api/formats/1/pipelines/2')
        .to route_to('api/pipelines#show', format_id: '1', id: '2')
    end

    it 'routes to #create' do
      expect(post: 'api/formats/1/pipelines')
        .to route_to('api/pipelines#create', format_id: '1')
    end
  end
end
