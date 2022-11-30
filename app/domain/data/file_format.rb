# frozen_string_literal: true

module Data
  class FileFormat
    include AggregateRoot

    attr_reader :state
    attr_reader :updated_at
    attr_reader :activated_at
    attr_reader :inactivated_at
    attr_reader :name

    def initialize(id)
      @id = id
    end

    def create(name)
      event_data = {
        name: name,
        updated_at: Time.now,
      }
      apply Events::FileFormatCreated.new(data: event_data)
    end

    def activate
      event_data = {
        activated_at: Time.now,
        updated_at: Time.now,
      }
      apply Events::FileFormatActivated.new(data: event_data)
    end

    def inactivate
      event_data = {
        inactivated_at: Time.now,
        updated_at: Time.now,
      }
      apply Events::FileFormatInactivated.new(data: event_data)
    end

    on Events::FileFormatCreated do |event|
      @state = :created
      @updated_at = event.data.fetch(:updated_at)
      @name = event.data.fetch(:name)
    end

    on Events::FileFormatActivated do |event|
      @state = :activated
      @updated_at = event.data.fetch(:updated_at)
      @activated_at = event.data.fetch(:activated_at)
    end

    on Events::FileFormatInactivated do |event|
      @state = :inactivated
      @updated_at = event.data.fetch(:updated_at)
      @inactivated_at = event.data.fetch(:inactivated_at)
    end
  end
end
