# frozen_string_literal: true

module Domain
  class DataFile
    include AggregateRoot

    attr_reader(
      :state,
      :uploaded_at,
      :filename,
      :processing_started_at,
      :processing_ended_at,
    )

    def initialize(id, filename)
      @id = id
      @filename = filename
    end

    def processing_duration
      return if processing_ended_at.nil?
      return if processing_started_at.nil?

      processing_ended_at - processing_started_at
    end

    def upload
      event_data = {
        uploaded_at: Time.now,
        updated_at: Time.now,
        filename: filename,
        id: id,
      }
      apply Events::FileUploaded.new(data: event_data)
    end

    def processing
      event_data = {
        processing_started_at: Time.now,
        updated_at: Time.now,
      }
      apply Events::FileProcessing.new(data: event_data)
    end

    def processed
      event_data = {
        processing_ended_at: Time.now,
        updated_at: Time.now,
      }
      apply Events::FileProcessed.new(data: event_data)
    end

    on Events::FileUploaded do |event|
      @state = :uploaded
      @updated_at = event.data.fetch(:updated_at)
      @uploaded_at = event.data.fetch(:uploaded_at)
      @filename = event.data.fetch(:filename)
    end

    on Events::FileProcessing do |event|
      @state = :processing
      @updated_at = event.data.fetch(:updated_at)
      @processing_started_at = event.data.fetch(:processing_started_at)
    end

    on Events::FileProcessed do |event|
      @state = :processed
      @updated_at = event.data.fetch(:updated_at)
      @processing_ended_at = event.data.fetch(:processing_ended_at)
    end
  end
end
