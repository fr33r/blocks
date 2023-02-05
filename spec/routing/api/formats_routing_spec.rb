# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::FileFormatsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: 'api/formats')
        .to route_to('api/file_formats#index')
    end

    it 'routes to #create' do
      expect(post: 'api/formats')
        .to route_to('api/file_formats#create')
    end

    it 'routes to #show' do
      expect(get: 'api/formats/1')
        .to route_to('api/file_formats#show', id: '1')
    end
  end
end
