# frozen_string_literal: true

module Api
  class RowsController < ApplicationController
    def index
      # use projection instead.
    end

    def show
      row = repository.load(DataFile.new, stream_name)

      respond(row)
    end

    def create
      result = repository.with_aggregate(DataFile.new(new_id), stream_name) do |row|
        row.upload(creation_params)
      end

      respond(result)
    end

    private

    def creation_params
      {
        filename: 'example.csv',
        total_rows: 500,
      }
    end
  end
end
