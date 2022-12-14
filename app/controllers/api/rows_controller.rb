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
      serialized_row = RowRepresenter.new(row).serialize
      patched_representation = JSON::Patch.new(serialized_row, patch_operations).call
      updated_by = SecureRandom.uuid
      command = Data::Commands::UpdateRow.new(row.id, patched_representation, updated_by)
      command_bus.call(command)
      render json: read_model.find(command.id)
    end

    def patch_collection
      # validate operations.
      additions = patch_operation.map do |operation|
        operation['value'] if operation['op'] == 'add'
      end.compact

      # do this async.
      additions.each do |addition|
        created_by = SecureRandom.uuid
        command = Data::Commands::CreateRow.new(new_uuid, addition, created_by)
        command_bus.call(command)
      end
    end

    private

    def patch_operations
      params.permit(array: %i[path op value])['array'].map(&:to_h)
    end

    def create_command
      created_by = SecureRandom.uuid
      Data::Commands::CreateRow.new(new_id, create_params.fetch(:data), created_by)
    end

    def create_params
      params.permit!.slice(:data)
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
