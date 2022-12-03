# frozen_string_literal: true

module Api
  class RowsController < ApplicationController
    def index
      respond(read_model.all)
    end

    def show
      respond(read_model.find(params[:id]))

#       row = repository.load(Data::Row.new(params[:id]), stream_name)

#       respond(row)
    end

    def create
      command_bus.call(create_command)
      respond(read_model.find(params[:id]))
      # id = new_id
      # repository.with_aggregate(Data::Row.new(id), stream_name(id)) do |row|
      #   row.upload(create_params.fetch(:data))
      # end

      # respond(repository.load(Data::Row.new(id), stream_name(id)))
    end

    def update
      command_bus.call(update_command)
      respond(read_model.find(params[:id]))
      # id = params[:id]
      # result = repository.with_aggregate(Data::Row.new(id), stream_name) do |row|
      #   row.update_data(update_params.fetch(:data))
      # end

      # # build read model.
      # # DataRow.update!(
      # #   state: result.state,
      # #   data: result.data,
      # # )

      # respond(repository.load(Data::Row.new(id), stream_name(id)))
    end

    private

   def create_command
     created_by = SecureRandom.uuid
     Data::Commands::CreateRow.new(new_id, create_params.fetch(:data), created_by)
   end

    def create_params
      params.permit!
    end

    def update_command
      updated_by = SecureRandom.uuid
      Data::Commands::UpdateRow.new(new_id, update_params.fetch(:data), updated_by)
    end

    def update_params
      params.permit!
    end

    def resource_klass
      Data::Row
    end

    def resource_representer_klass
      RowRepresenter
    end
  end
end
