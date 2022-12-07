# frozen_string_literal: true

module Data
  class Row
    include AggregateRoot

    class State
      UPLOADED = :uploaded
      VALID    = :valid
      INVALID  = :invalid
      FILTERED = :filtered
      INGESTED = :ingested
    end

    STATES = [
      State::UPLOADED,
      State::VALID,
      State::INVALID,
      State::FILTERED,
      State::INGESTED,
    ].freeze

    attr_reader :id
    attr_reader :state
    attr_reader :uploaded_at
    attr_reader :hash
    attr_reader :data

    def initialize(id, hasher = ::Hashers::Md5)
      @id = id
      @hasher = hasher
    end

    def update_data(data)
      hash = hasher.hash(data.to_yaml)
      apply Events::RowUpdated.new(data: { data: data, updated_at: Time.now, hash: hash })
    end

    def upload(data)
      event_data = {
        uploaded_at: Time.now,
        updated_at: Time.now,
        data: data,
        state: State::UPLOADED,
        id: id,
        hash: hasher.hash(data.to_yaml),
      }
      apply Events::RowUploaded.new(data: event_data)
    end

    def validate
      apply Events::RowValidated.new(data: { state: State::VALID, updated_at: Time.now })
    end

    def invalidate
      apply Events::RowInvalidated.new(data: { state: State::INVALID, updated_at: Time.now })
    end

    def filter
      apply Events::RowFiltered.new(data: { state: State::FILTERED, updated_at: Time.now })
    end

    def ingest
      apply Events::RowIngested.new(data: { state: State::INGESTED, updated_at: Time.now })
    end

    on Events::RowUploaded do |event|
      @state = event.data.fetch(:state)
      @updated_at = event.data.fetch(:updated_at)
      @hash = event.data.fetch(:hash)
      @data = event.data.fetch(:data)
      @uploaded_at = event.data.fetch(:uploaded_at)
    end

    on Events::RowUpdated do |event|
      @updated_at = event.data.fetch(:updated_at)
      @hash = event.data.fetch(:hash)
      @data = event.data.fetch(:data)
    end

    on Events::RowFiltered do |event|
      @state = event.data.fetch(:state)
      @updated_at = event.data.fetch(:updated_at)
    end

    on Events::RowInvalidated do |event|
      @state = event.data.fetch(:state)
      @updated_at = event.data.fetch(:updated_at)
    end

    on Events::RowValidated do |event|
      @state = event.data.fetch(:state)
      @updated_at = event.data.fetch(:updated_at)
    end

    on Events::RowIngested do |event|
      @state = event.data.fetch(:state)
      @updated_at = event.data.fetch(:updated_at)
    end

    private

    attr_reader :hasher
  end
end
