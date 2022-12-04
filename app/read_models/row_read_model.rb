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
    scope.with_hash(hash)
  end

  def with_state(state)
    scope.send("#{state}_state".to_sym)
  end

  def limit(limit = 25)
    scope.limit(limit)
  end

  def offset(offset = 0)
    scope.offset(offset)
  end

  private

  def create_row!(event_data)
    attributes_names = %i[id state hash data uploaded_by uploaded_at updated_by updated_at]
    attributes = event_data.slice(*attributes_names)
    attributes[:created_at] = attributes.delete(:uploaded_at)
    attributes[:created_by] = attributes.delete(:uploaded_by)
    attributes[:data_hash] = attributes.delete(:hash)
    row = Row.new(**attributes)
    row.id = attributes.fetch(:id)
    row.save!
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

  def scope
    @scope ||= Row
  end
end
