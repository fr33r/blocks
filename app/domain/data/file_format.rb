# frozen_string_literal: true

module Data
  class FileFormat
    include AggregateRoot

    class State
      CREATED = :created
      ACTIVE = :active
      INACTIVE = :inactive
    end

    STATES = [
      State::CREATED,
      State::ACTIVE,
      State::INACTIVE,
    ].freeze

    attr_reader :state
    attr_reader :name
    attr_reader :created_at
    attr_reader :created_by
    attr_reader :updated_at
    attr_reader :updated_by

    def initialize(id)
      @id = id
    end

    def create(name, created_by)
      event_data = {
        name: name,
        state: State::CREATED,
        updated_at: Time.now,
        updated_by: created_by,
        created_at: Time.now,
        created_by: created_by,
      }
      apply Events::FileFormatCreated.new(data: event_data)
    end

    def activate(updated_by)
      event_data = {
        state: State::ACTIVE,
        updated_at: Time.now,
        updated_by: updated_by,
      }
      apply Events::FileFormatActivated.new(data: event_data)
    end

    def inactivate(updated_by)
      event_data = {
        state: State::INACTIVE,
        updated_at: Time.now,
        updated_by: updated_by,
      }
      apply Events::FileFormatInactivated.new(data: event_data)
    end

    on Events::FileFormatCreated do |event|
      @state = event.data.fetch(:state)
      @updated_at = event.data.fetch(:updated_at)
      @updated_by = event.data.fetch(:updated_by)
      @created_at = event.data.fetch(:created_at)
      @created_by = event.data.fetch(:created_by)
      @name = event.data.fetch(:name)
    end

    on Events::FileFormatActivated do |event|
      @state = event.data.fetch(:state)
      @updated_at = event.data.fetch(:updated_at)
      @updated_by = event.data.fetch(:updated_by)
    end

    on Events::FileFormatInactivated do |event|
      @state = event.data.fetch(:state)
      @updated_at = event.data.fetch(:updated_at)
      @updated_by = event.data.fetch(:updated_by)
    end
  end
end
