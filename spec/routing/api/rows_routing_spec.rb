# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::RowsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: 'api/formats/1/files/2/rows')
        .to route_to('api/rows#index', format_id: '1', file_id: '2')
    end

    it 'routes to #create' do
      expect(post: 'api/formats/1/files/2/rows')
        .to route_to('api/rows#create', format_id: '1', file_id: '2')
    end

    it 'routes to #show' do
      expect(get: 'api/formats/1/files/2/rows/3')
        .to route_to('api/rows#show', format_id: '1', file_id: '2', id: '3')
    end

    it 'routes to #update' do
      expect(put: 'api/formats/1/files/2/rows/3')
        .to route_to('api/rows#update', format_id: '1', file_id: '2', id: '3')
    end

    it 'routes to #patch' do
      expect(patch: 'api/formats/1/files/2/rows/3')
        .to route_to('api/rows#patch', format_id: '1', file_id: '2', id: '3')
    end

    it 'routes to #patch_collection' do
      expect(patch: 'api/formats/1/files/2/rows')
        .to route_to('api/rows#patch_collection', format_id: '1', file_id: '2')
    end
  end
end
