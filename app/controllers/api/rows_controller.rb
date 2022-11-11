# frozen_string_literal: true

module Api
  class RowsController < ApplicationController
    def index
      # use projection instead.
    end

    def show
      row = repository.load(Domain::DataRow.new, stream_name)

      respond(row)
    end

    def create
      result = repository.with_aggregate(Domain::DataRow.new(new_id), stream_name) do |row|
        row.upload(creation_params.fetch(:data))
      end

      respond(result)
    end

    def update
      result = repository.with_aggregate(Domain::DataRow.new(params[:id]), stream_name) do |row|
        row.update_data(update_params.fetch(:data))
      end

      respond(result)
    end

    private

    def creation_params
      {
        data: {
          'COLUMN X': 'foo',
          'COLUMN Y': 'bar',
          'COLUMN Z': 'baz'
        }
      }
    end

    def update_params
      {
        data: {
          'COLUMN X': 'oof',
          'COLUMN Y': 'rab',
          'COLUMN Z': 'zab'
        }
      }
    end

    def resource_klass
      Domain::DataRow
    end
  end
end
