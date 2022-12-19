# frozen_string_literal: true

module Data
  class Row
    include AggregateRoot

    class Error
      attr_reader :message
      attr_reader :rule_id

      def initialize(message, rule_id)
        @message = message
        @rule_id = rule_id
      end
    end

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
    attr_reader :errors
    attr_reader :file_id
    attr_reader :row_number

    def initialize(id, hasher = ::Hashers::Md5)
      @id = id
      @hasher = hasher
    end

    def update_data(data)
      hash = hasher.hash(data.to_yaml)
      apply Events::RowUpdated.new(data: { data: data, updated_at: Time.now, hash: hash })
    end

    def upload(row_number, file_id, data)
      event_data = {
        uploaded_at: Time.now,
        updated_at: Time.now,
        row_number: row_number,
        data: data,
        state: State::UPLOADED,
        id: id,
        hash: hasher.hash(data.to_yaml),
        file_id: file_id,
      }
      apply Events::RowUploaded.new(data: event_data)
    end

    def evaluate(pipeline)
      # reference the pipeline of the report format that is associated with this
      # row and execute it against this row? trigger this method on create and update events
      # and maybe when the pipeline is changed?

      # potential invariants:
      # - if there is > 0 errors, the state is INVALID.
      # - if there is 0 errors and the row has been evaluated, the state is VALID.
      # - cannot evaluate if the status INGESTED.

      # not a fan of this method. but...

      # is this the only way if we want to ensure our list of errors is synced
      # with rule executions? since this method would execute all rules for the row,
      # the errors could be wiped clean at the beginning and appended to as they execute.

      errors = pipeline.execute!(self)
      if errors.count.positive?
        event_data = { errors: errors, state: State::INVALID, updated_at: Time.now }
        apply Events::RowInvalidated.new(data: event_data)
      else
        event_data = { errors: errors, state: State::VALID, updated_at: Time.now }
        apply Events::RowValidated.new(data: event_data)
      end
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
      @row_number = event.data.fetch(:row_number)
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
