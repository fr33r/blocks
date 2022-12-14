# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::FilesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: 'api/formats/1/files')
        .to route_to('api/files#index', format_id: '1')
    end

    it 'routes to #create' do
      expect(post: 'api/formats/1/files')
        .to route_to('api/files#create', format_id: '1')
    end

    it 'routes to #show' do
      expect(get: 'api/formats/1/files/2')
        .to route_to('api/files#show', format_id: '1', id: '2')
    end
  end
end
