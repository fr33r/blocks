# frozen_string_literal: true

module Api
  class ApplicationController < ActionController::API
    include ActionController::MimeResponds

    def repository
      AggregateRoot::Repository.new
    end

    def stream_name(id = params[:id])
      "#{resource_klass}$#{id}"
    end

    def new_id
      SecureRandom.uuid
    end

    def respond(resource)
      respond_to do |format|
        format.json { render json: representation(resource) }
      end
    end

    def representation(resource)
      resource_representer_klass.new(resource)
    end
  end
end
