# frozen_string_literal: true

module Api
  class ApplicationController < ActionController::API
    include ActionController::MimeResponds

    def command_bus
      Rails.configuration.command_bus
    end

    def new_id
      SecureRandom.uuid
    end
  end
end
