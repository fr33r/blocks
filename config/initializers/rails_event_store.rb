require 'rails_event_store'
require 'aggregate_root'
require 'arkency/command_bus'

Rails.configuration.to_prepare do
  Rails.configuration.event_store = RailsEventStore::Client.new
  Rails.configuration.command_bus = Arkency::CommandBus.new

  AggregateRoot.configure do |config|
    config.default_event_store = Rails.configuration.event_store
  end

  # Subscribe event handlers below.
  Rails.configuration.event_store.tap do |store|
    RowReadModel.configure(store)
    PipelineReadModel.configure(store)
    RuleReadModel.configure(store)
    FileReadModel.configure(store)
    FileFormatReadModel.configure(store)

    store.subscribe_to_all_events(RailsEventStore::LinkByEventType.new)
    store.subscribe_to_all_events(RailsEventStore::LinkByCorrelationId.new)
    store.subscribe_to_all_events(RailsEventStore::LinkByCausationId.new)
  end

  # Register command handlers below.
  Rails.configuration.command_bus.tap do |bus|
    store = Rails.configuration.event_store
    Data::CommandHandlers::Configuration.call(store, bus)
    Evaluation::CommandHandlers::Configuration.call(store, bus)
  end
end
