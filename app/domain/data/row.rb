# frozen_string_literal: true

module Data
  class Row
    include AggregateRoot

    attr_reader :id
    attr_reader :state
    attr_reader :uploaded_at
    attr_reader :hash
    attr_reader :ingested_at
    attr_reader :filtered_at
    attr_reader :data

    def initialize(id, hasher = ::Hashers::Md5)
      @id = id
      @hasher = hasher
    end

    def update_data(data)
      apply Events::RowUpdated.new(data: { data: data, updated_at: Time.now })
    end

    def upload(data)
      event_data = {
        uploaded_at: Time.now,
        updated_at: Time.now,
        data: data,
        id: id,
      }
      apply Events::RowUploaded.new(data: event_data)
    end

    def validate
      # execute all rules attached to the corresponding report format pipeline.
      valid = rand(10) % 2 == 0
      if valid
        apply Events::RowValidated.new(data: { updated_at: Time.now })
      else
        apply Events::RowInvalidated.new(data: { updated_at: Time.now })
      end
    end

    def filter
      apply Events::RowFiltered.new(data: { filtered_at: Time.now, updated_at: Time.now })
    end

    def ingest
      apply Events::RowIngested.new(data: { ingested_at: Time.now, updated_at: Time.now })
    end

    on Events::RowUploaded do |event|
      @state = :uploaded
      @updated_at = event.data.fetch(:updated_at)
      @hash = hasher.hash(event.data.to_yaml)
      @data = event.data.fetch(:data)
      @uploaded_at = event.data.fetch(:uploaded_at)
    end

    on Events::RowUpdated do |event|
      @updated_at = event.data.fetch(:updated_at)
      @hash = hasher.hash(event.data.to_yaml)
      @data = event.data.fetch(:data)
    end

    on Events::RowFiltered do |event|
      @state = :filtered
      @updated_at = event.data.fetch(:updated_at)
      @filtered_at = event.data.fetch(:filtered_at)
    end

    on Events::RowInvalidated do |event|
      @state = :invalid
    end

    on Events::RowValidated do |event|
      @state = :valid
    end

    on Events::RowIngested do |event|
      @state = :ingested
      @updated_at = event.data.fetch(:updated_at)
      @ingested_at = event.data.fetch(:ingested_at)
    end

    private

    attr_reader :hasher
  end
end
