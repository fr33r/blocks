# frozen_string_literal: true

module Domain
  class DataFileFormat
    include AggregateRoot

    attr_reader(
      :state,
      :updated_at,
      :activated_at,
      :inactivated_at,
      :name,
    )

    def initialize(id)
      @id = id
    end

    def create(name)
      event_data = {
        name: name,
        updated_at: Time.now,
      }
      apply Domain::Events::FileFormatCreated.new(data: event_data)
    end

    def activate
      event_data = {
        activated_at: Time.now,
        updated_at: Time.now,
      }
      apply Domain::Events::FileFormatActivated.new(data: event_data)
    end

    def inactivate
      event_data = {
        inactivated_at: Time.now,
        updated_at: Time.now,
      }
      apply Domain::Events::FileFormatInactivated.new(data: event_data)
    end

    on Domain::Events::FileFormatCreated do |event|
      @state = :created
      @updated_at = event.data.fetch(:updated_at)
      @name = event.data.fetch(:name)
    end

    on Domain::Events::FileFormatActivated do |event|
      @state = :activated
      @updated_at = event.data.fetch(:updated_at)
      @activated_at = event.data.fetch(:activated_at)
    end

    on Domain::Events::FileFormatInactivated do |event|
      @state = :inactivated
      @updated_at = event.data.fetch(:updated_at)
      @inactivated_at = event.data.fetch(:inactivated_at)
    end
  end
end
