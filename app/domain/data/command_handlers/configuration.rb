# frozen_string_literal: true

module Data
  module CommandHandlers
    class Configuration
      def self.call(event_store, command_bus)
        command_bus.register(Commands::CreateRow, CreateRowHandler.new(event_store))
        command_bus.register(Commands::UpdateRow, UpdateRowHandler.new(event_store))
        command_bus.register(Commands::CreateFile, CreateFileHandler.new(event_store))
        command_bus.register(Commands::CreateFileFormat, CreateFileFormatHandler.new(event_store))
      end
    end
  end
end
