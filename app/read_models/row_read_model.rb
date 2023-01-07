# frozen_string_literal: true

class RowReadModel
  def handle(event)
    case event
      when Data::Events::RowUploaded
        create_row!(event.data)
      when Data::Events::RowUpdated
        update_row!(event.data)
      when Data::Events::RowValidated
        validate_row!(event.data)
      when Data::Events::RowInvalidated
        invalidate_row!(event.data)
      when Data::Events::RowFiltered
        filter_row!(event.data)
      when Data::Events::RowIngested
        ingest_row!(event.data)
    end
  end

  def all
    Row.all
  end

  def find(id)
    Row.find(id)
  end

  def with_hash(hash)
    @scope = scope.with_hash(hash)
    self
  end

  def with_state(state)
    @scope = scope.send("#{state}_state".to_sym)
    self
  end

  def with_limit(limit = 25)
    @scope = scope.limit(limit)
    self
  end

  def with_offset(offset = 0)
    @scope = scope.offset(offset)
    self
  end

  def scope
    @scope ||= Row.where(nil)
  end

  def self.configure(event_store)
    handler = ->(event) { self.new.handle(event) }
    event_store.subscribe(handler, to: Data::Events::ALL)
  end

  private

  def create_anchor_values!(event_data)
    anchor_values = event_data.fetch(:anchor_values)
    row_id = event_data.fetch(:id)
    anchor_values.each do |anchor_value_data|
      create_anchor_value!(row_id, anchor_value_data)
    end
  end

  def create_anchor_value!(row_id, anchor_value_data)
    attributes = anchor_value_data.dup
    attributes[:data_hash] = attributes.delete(:hash)
    anchor_value = AnchorValue.new(row_id: row_id, **attributes)
    anchor_value.save!
  end

  def create_row!(event_data)
    attributes_names =
      %i[id row_number file_id state hash data uploaded_by uploaded_at updated_by updated_at]
    attributes = event_data.slice(*attributes_names)
    attributes[:created_at] = attributes.delete(:uploaded_at)
    attributes[:created_by] = attributes.delete(:uploaded_by)
    attributes[:data_hash] = attributes.delete(:hash)
    # attributes[:data_file_id] = attributes.delete(:file_id)
    row = Row.new(**attributes)
    row.id = attributes.fetch(:id)
    row.save!

    create_anchor_values!(event_data)
  end

  def update_row!(event_data)
    attributes_names = %i[data updated_by updated_at]
    attributes = event_data.slice(*attributes_names)
    attributes[:data_hash] = attributes.delete(:hash)
    Row.update!(**attributes)
  end

  def validate_row!(event_data)
    attribute_names = %i[updated_at]
    Row.update!(**event_data.slice(*attribute_names))
  end

  def invalidate_row!(event_data)
    attribute_names = %i[updated_at]
    Row.update!(**event_data.slice(*attribute_names))
  end

  def filter_row!(event_data)
    attribute_names = %i[updated_at]
    Row.update!(**event_data.slice(*attribute_names))
  end

  def ingest_row!(event_data)
    attribute_names = %i[updated_at]
    Row.update!(**event_data.slice(*attribute_names))
  end
end
