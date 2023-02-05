# frozen_string_literal: true

module Api
  class FileFormatsController < ApplicationController
    include Roar::Rails::ControllerAdditions
    include Roar::Rails::ControllerAdditions::Render

    represents :json, :entity => FileFormatRepresenter, :collection => FileFormatCollectionRepresenter

    def create
      command = create_command
      command_bus.call(command)
      render json: read_model.find(command.id), status: :created
    end

    def show
      render json: read_model.find(params[:id])
    end

    def index
      render json: read_model.all
    end

    private

    def create_command
      id = new_id
      name = params[:name]
      created_by = SecureRandom.uuid
      columns_args = params[:columns]
      anchors_args = params[:anchors]
      Data::Commands::CreateFileFormat.new(id, name, columns_args, anchors_args, created_by)
    end

    def read_model
      FileFormatReadModel.new
    end
  end
end
