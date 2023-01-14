# frozen_string_literal: true

module Data
  class File
    include AggregateRoot

    class State
      UPLOADED = :uploaded
      PROCESSING = :processing
      PROCESSED = :processed
    end

    STATES = [
      State::UPLOADED,
      State::PROCESSING,
      State::PROCESSED,
    ].freeze

    class FileAlreadyProcessed < StandardError; end
    class InvalidRowProcessed < StandardError; end
    class MissingTotalRowCount < StandardError; end

    attr_reader :id
    attr_reader :state
    attr_reader :uploaded_at
    attr_reader :updated_at
    attr_reader :filename
    attr_reader :file_format_id
    attr_reader :total_row_count
    attr_reader :processing_started_at
    attr_reader :processing_ended_at

    def initialize(id)
      @id = id
    end

    def processing_duration
      return if processing_ended_at.nil?
      return if processing_started_at.nil?

      processing_ended_at - processing_started_at
    end

    def uploaded?
      state == State::UPLOADED
    end

    def processing?
      state == State::PROCESSING
    end

    def processed?
      state == State::PROCESSED
    end

    def last_row?(row)
      row.row_number == total_row_count
    end

    # call me after each row uploaded event.
    def process_row(row)
      fail FileAlreadyProcessed if processed?
      fail MissingTotalRowCount unless total_row_count&.positive?
      fail InvalidRowProcessed if row.row_number > total_row_count

      if uploaded?
        processing
        return
      end

      if processing? && last_row?(row)
        processed
      end
    end

    def upload(filename:, total_row_count:, format_id:)
      event_data = {
        uploaded_at: Time.now,
        updated_at: Time.now,
        filename: filename,
        file_format_id: format_id,
        total_row_count: total_row_count,
        state: State::UPLOADED,
        id: id,
      }
      apply Events::FileUploaded.new(data: event_data)
    end

    def processing
      event_data = {
        id: id,
        state: State::PROCESSING,
        processing_started_at: Time.now,
        updated_at: Time.now,
      }
      apply Events::FileProcessing.new(data: event_data)
    end

    def processed
      event_data = {
        id: id,
        state: State::PROCESSED,
        processing_ended_at: Time.now,
        updated_at: Time.now,
      }
      apply Events::FileProcessed.new(data: event_data)
    end

    on Events::FileUploaded do |event|
      @state = event.data.fetch(:state)
      @updated_at = event.data.fetch(:updated_at)
      @uploaded_at = event.data.fetch(:uploaded_at)
      @total_row_count = event.data.fetch(:total_row_count)
      @filename = event.data.fetch(:filename)
      @file_format_id = event.data.fetch(:file_format_id)
    end

    on Events::FileProcessing do |event|
      @state = event.data.fetch(:state)
      @updated_at = event.data.fetch(:updated_at)
      @processing_started_at = event.data.fetch(:processing_started_at)
    end

    on Events::FileProcessed do |event|
      @state = event.data.fetch(:state)
      @updated_at = event.data.fetch(:updated_at)
      @processing_ended_at = event.data.fetch(:processing_ended_at)
    end
  end
end
