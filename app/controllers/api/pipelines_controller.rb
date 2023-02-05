# frozen_string_literal: true

module Api
  class PipelinesController < ApplicationController
    include Roar::Rails::ControllerAdditions
    include Roar::Rails::ControllerAdditions::Render

    represents :json, :entity => PipelineRepresenter, :collection => PipelineCollectionRepresenter

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

    private

    def read_model
      PipelineReadModel.new
    end

   def create_command
     created_by = SecureRandom.uuid
     Data::Commands::CreatePipeline.new(**create_params, created_by: created_by)
   end

    def create_params
      params.permit!
    end
  end
end
