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
    attr_reader :description
    attr_reader :created_at
    attr_reader :created_by
    attr_reader :updated_at
    attr_reader :updated_by
    attr_reader :columns
    attr_reader :anchors

    def initialize(id)
      @id = id
    end

    def create(name, columns_args, anchors_args, created_by)
      columns = create_columns(columns_args)
      anchors = create_anchors(anchors_args, columns)
      event_data = {
        id: @id,
        name: name,
        state: State::CREATED,
        updated_at: Time.now,
        updated_by: created_by,
        created_at: Time.now,
        created_by: created_by,
        columns: columns.map(&:to_h),
        anchors: anchors.map(&:to_h),
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

      anchor_data = event.data.fetch(:anchors)
      @anchors = anchor_data.map do |anchor|
        Anchor.new(anchor[:id], anchor[:name], anchor[:description], anchor[:column_ids])
      end

      column_data = event.data.fetch(:columns)
      @columns = column_data.map do |column|
        Column.new(
          column[:id],
          column[:name],
          column[:description],
          column[:required],
          column[:data_type],
        )
      end
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

    private

    def create_columns(columns_args)
      columns_args.map do |column_args|
        create_column(column_args)
      end
    end
    
    def create_column(column_args)
      id = SecureRandom.uuid
      name = column_args.fetch(:name)
      description = column_args.fetch(:description)
      required = column_args.fetch(:required)
      data_type = column_args.fetch(:data_type)

      Column.new(id, name, description, required, data_type)
    end

    def create_anchors(anchors_args, columns)
      anchors_args.map do |anchor_args|
        create_anchor(anchor_args, columns)
      end
    end
    
    def create_anchor(anchor_args, columns)
      id = SecureRandom.uuid
      name = anchor_args.fetch(:name)
      description = anchor_args.fetch(:description)
      column_names = anchor_args.fetch(:columns)
      column_ids = column_names.map do |column_name|
        column = columns.find { |c| c.name.downcase == column_name.downcase }
        column.id
      end

      Anchor.new(id, name, description, column_ids)
    end
  end
end
