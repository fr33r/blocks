# frozen_string_literal: true

module Data
  class File
    include AggregateRoot

    class State
      UPLOADED = :uploaded
      PROCESSING = :processed
      PROCESSED = :processed
    end

    attr_reader :id
    attr_reader :state
    attr_reader :uploaded_at
    attr_reader :filename
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

    def upload(filename:)
      event_data = {
        uploaded_at: Time.now,
        updated_at: Time.now,
        filename: filename,
        state: State::UPLOADED,
        id: id,
      }
      apply Events::FileUploaded.new(data: event_data)
    end

    def processing
      event_data = {
        state: State::PROCESSING,
        processing_started_at: Time.now,
        updated_at: Time.now,
      }
      apply Events::FileProcessing.new(data: event_data)
    end

    def processed
      event_data = {
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
      @filename = event.data.fetch(:filename)
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
