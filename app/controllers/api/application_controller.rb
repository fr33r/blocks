# frozen_string_literal: true

module Api
  class ApplicationController < ActionController::API
    include ActionController::MimeResponds

    def event_store
      @event_store ||= Rails.configuration.event_store.tap do |client|
        configuration_event_handlers(client)
      end
    end

    def command_bus
      @command_bus ||= Arkency::CommandBus.new.tap do |bus|
        configure_command_handlers(bus)
      end
    end

    def handleable_events
      [
        Data::Events::RowUploaded,
        Data::Events::RowUpdated,
        Data::Events::RowValidated,
        Data::Events::RowInvalidated,
        Data::Events::RowFiltered,
        Data::Events::RowIngested,
      ]
    end

    def configuration_event_handlers(client)
      handler = ->(event) { read_model.handle(event) }
      client.subscribe(handler, handleable_events)
    end

    def configure_command_handlers(bus)
      bus.register(Data::Commands::CreateRow, Data::CommandHandlers::CreateRowHandler)
      bus.register(Data::Commands::UpdateRow, Data::CommandHandlers::UpdateRowHandler)
    end

    def read_model
      RowReadModel.new
    end

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
