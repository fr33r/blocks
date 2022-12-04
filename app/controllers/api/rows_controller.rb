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
      render json: read_model.find(command.id)
    end

    def update
      command = update_command
      command_bus.call(command)
      render json: read_model.find(command.id)
    end

    private

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
