# frozen_string_literal: true

module Api
  class RulesController < ApplicationController
    include Roar::Rails::ControllerAdditions
    include Roar::Rails::ControllerAdditions::Render

    represents :json, :entity => RuleRepresenter, :collection => RuleCollectionRepresenter

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

    def patch 
      rule = read_model.find(params[:id])
      serialized_rule = RuleRepresenter.new(rule).to_hash
      patched_representation = JSON::Patch.new(serialized_rule, patch_operations).call
      updated_by = SecureRandom.uuid
      command = Evaluation::Commands::UpdateRule.new(
        **patched_representation,
        'updated_by' => updated_by,
        'pipeline_id' => params['pipeline_id'],
      )
      command_bus.call(command)
      render json: read_model.find(command.id)
    end

    private

    def read_model
      RuleReadModel.new
    end

    def create_command
      created_by = SecureRandom.uuid
      Evaluation::Commands::CreateRule.new(
        **create_params,
        'created_by' => created_by,
      )
    end

    def patch_operations
      params.permit!['_json'].map(&:to_h)
    end

    def create_params
      params.permit!
    end
  end
end
