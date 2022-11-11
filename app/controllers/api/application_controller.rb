# frozen_string_literal: true

module Api
  class ApplicationController < ActionController::API
    include ActionController::MimeResponds

    def repository
      AggregateRoot::Repository.new
    end

    def stream_name(id_param = :id)
      "#{resource_klass}$#{params[id_param]}"
    end

    def new_id
      SecureRandom.uuid
    end

    def respond(representation)
      respond_to do |format|
        format.json { render json: representation }
      end
    end
  end
end
