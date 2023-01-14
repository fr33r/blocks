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
    attr_reader :anchor_values
    attr_reader :linked_row_ids

    def initialize(id, hasher = ::Hashers::Md5)
      @id = id
      @hasher = hasher
      @linked_row_ids = []
    end

    def update_data(data)
      hash = hasher.hash(data.to_yaml)
      event_data = { id: id, data: data, updated_at: Time.now, hash: hash }
      apply Events::RowUpdated.new(data: event_data)
    end

    def upload(row_number, file_id, data, format)
      event_data = {
        uploaded_at: Time.now,
        updated_at: Time.now,
        row_number: row_number,
        data: data,
        state: State::UPLOADED,
        id: id,
        hash: hasher.hash(data.to_yaml),
        file_id: file_id,
        anchor_values: generate_anchor_values(data, format).map(&:to_h),
      }
      apply Events::RowUploaded.new(data: event_data)
    end

    def link(row)
      event_data = {
        updated_at: Time.now,
        id: id,
        linked_row_id: row.id,
      }
      apply Events::RowLinked.new(data: event_data)
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
        event_data = { id: id, errors: errors, state: State::INVALID, updated_at: Time.now }
        apply Events::RowInvalidated.new(data: event_data)
      else
        event_data = { id: id, errors: errors, state: State::VALID, updated_at: Time.now }
        apply Events::RowValidated.new(data: event_data)
      end
    end

    def filter
      event_data = { id: id, state: State::FILTERED, updated_at: Time.now }
      apply Events::RowFiltered.new(data: event_data)
    end

    def ingest
      event_data = { id: id, state: State::INGESTED, updated_at: Time.now }
      apply Events::RowIngested.new(data: event_data)
    end

    on Events::RowUploaded do |event|
      @state = event.data.fetch(:state)
      @updated_at = event.data.fetch(:updated_at)
      @hash = event.data.fetch(:hash)
      @data = event.data.fetch(:data)
      @uploaded_at = event.data.fetch(:uploaded_at)
      @row_number = event.data.fetch(:row_number)

      anchor_value_data = event.data.fetch(:anchor_values)
      @anchor_values = anchor_value_data.map do |anchor_value|
        AnchorValue.new(anchor_value[:data], anchor_value[:anchor_id])
      end
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

    on Events::RowLinked do |event|
      linked_row_id = event.data.fetch(:linked_row_id)
      @linked_row_ids << linked_row_id
      @updated_at = event.data.fetch(:updated_at)
    end

    private

    attr_reader :hasher

    def generate_anchor_values(data, format)
      return [] if format.nil?
      return [] if format.anchors.nil?
      return [] if format.anchors.empty?

      columns = format.columns
      format.anchors.map do |anchor|
        anchor_columns = columns.filter { |c| anchor.column_ids.include?(c.id) }
        anchor_column_names = anchor_columns.map(&:name)
        anchor_data = data.slice(*anchor_column_names)
        AnchorValue.new(anchor_data, anchor.id)
      end
    end
  end
end
