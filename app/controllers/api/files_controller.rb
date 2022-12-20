# frozen_string_literal: true

module Api
  class FilesController < ApplicationController
    include Roar::Rails::ControllerAdditions
    include Roar::Rails::ControllerAdditions::Render

    represents :json, :entity => FileRepresenter, :collection => FileCollectionRepresenter

    def index
    end

    def show
    end

    def create
      command = create_command
      command_bus.call(command)
      render json: read_model.find(command.id), status: :created
    end

    private

    def create_command
      id = new_id
      format_id = params[:format_id]
      filename = params[:filename]
      total_row_count = params[:total_row_count]
      created_by = SecureRandom.uuid
      Data::Commands::CreateFile.new(
        id, format_id, filename, total_row_count, created_by,
      )
    end

    def read_model
      FileReadModel.new
    end
  end
end
