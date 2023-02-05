# frozen_string_literal: true

module Api
  class RowsController < ApplicationController
    include Roar::Rails::ControllerAdditions
    include Roar::Rails::ControllerAdditions::Render

    represents :json, :entity => RowRepresenter, :collection => RowCollectionRepresenter

    def index
      render json: read_model.all
    end

    def show
      render json: read_model.find(params[:id])
    end

    def create
      command = create_command
      command_bus.call(command)
      render json: read_model.find(command.id), status: :created
    end

    def update
      command = update_command
      command_bus.call(command)
      render json: read_model.find(command.id)
    end

    def patch
      row = read_model.find(params[:id])
      serialized_row = RowRepresenter.new(row).to_hash
      patched_representation = JSON::Patch.new(serialized_row, patch_operations).call
      updated_by = SecureRandom.uuid
      patched_data = patched_representation['data']
      command = Data::Commands::UpdateRow.new(row.id, patched_data, updated_by)
      command_bus.call(command)
      render json: read_model.find(command.id)
    end

    def patch_collection
      file_id = params[:file_id]
      format_id = params[:format_id]

      # validate operations.
      additions = patch_operations.map do |operation|
        operation['value'] if operation['op'] == 'add'
      end.compact

      # do this async.
      additions.each do |addition|
        id = new_id
        data = addition['data']
        row_num = addition['row_number']
        created_by = SecureRandom.uuid
        command = Data::Commands::CreateRow.new(
          id, row_num, format_id, file_id, data, created_by
        )
        command_bus.call(command)
      end
    end

    private

    def patch_operations
      params.permit!['_json'].map(&:to_h)
    end

    def create_command
      id = new_id
      data = create_params[:data]
      file_id = create_params[:file_id]
      format_id = create_params[:format_id]
      row_num = create_params[:row_number]
      created_by = SecureRandom.uuid
      Data::Commands::CreateRow.new(id, row_num, format_id, file_id, data, created_by)
    end

    def create_params
      params.permit!
    end

    def update_command
      updated_by = SecureRandom.uuid
      Data::Commands::UpdateRow.new(params[:id], update_params.fetch(:data), updated_by)
    end

    def update_params
      params.permit!.slice(:data)
    end

    def read_model
      RowReadModel.new
    end
  end
end
