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
      when Data::Events::RowLinked
        link_row!(event.data)
    end
  end

  def all
    Row.all
  end

  def find(id)
    Row.find(id)
  end

  def linkable_rows(id)
    row = Row.find(id)
    anchor_values = row.anchor_values
    return unless anchor_values.present?

    format = row.data_file.file_format
    Row
      .joins(:anchor_values, :file_format)
      .where(anchor_values: { data_hash: anchor_values.map(&:data_hash) })
      .where.not(file_formats: { id: format.id })
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

    Data::LinkRowJob.perform_async(row.id)
  end

  def update_row!(event_data)
    attributes_names = %i[id data updated_by updated_at]
    attributes = event_data.slice(*attributes_names)
    attributes[:data_hash] = attributes.delete(:hash)
    id = attributes.fetch(:id)
    find(id).update!(**attributes)
  end

  def validate_row!(event_data)
    attribute_names = %i[id state updated_at]
    id = attributes.fetch(:id)
    find(id).update!(**event_data.slice(*attribute_names))
  end

  def invalidate_row!(event_data)
    attribute_names = %i[id state updated_at]
    id = attributes.fetch(:id)
    find(id).update!(**event_data.slice(*attribute_names))
  end

  def filter_row!(event_data)
    attribute_names = %i[id state updated_at]
    id = attributes.fetch(:id)
    find(id).update!(**event_data.slice(*attribute_names))
  end

  def ingest_row!(event_data)
    attribute_names = %i[id state updated_at]
    id = attributes.fetch(:id)
    find(id).update!(**event_data.slice(*attribute_names))
  end

  def link_row!(event_data)
    row = find(event_data.fetch(:id))
    linked_row = find(event_data.fetch(:linked_row_id))
    link = RowLink.new(source_row: row, target_row: linked_row)
    link.save!
  end
end
