# frozen_string_literal: true

class FileFormatReadModel
  def handle(event)
    case event
      when Data::Events::FileFormatCreated
        create_file_format!(event.data)
    end
  end

  def all
    FileFormat.all
  end

  def find(id)
    FileFormat.find(id)
  end

  def self.configure(event_store)
    handler = ->(event) { self.new.handle(event) }
    event_store.subscribe(handler, to: Data::Events::ALL)
  end

  private

  def create_file_format!(event_data)
    attributes_names = %i[id state name created_at updated_at]
    attributes = event_data.slice(*attributes_names)
    format = FileFormat.new(**attributes)
    format.id = attributes.fetch(:id)
    format.save!

    create_columns(event_data)
    create_anchors(event_data)
  end

  # have to create dependent rows manually because we generate IDs ahead of time.

  def create_anchors(event_data)
    anchors = event_data.fetch(:anchors)
    file_format_id = event_data.fetch(:id)
    anchors.each do |anchor_data|
      create_anchor(file_format_id, anchor_data)
    end
  end

  def create_anchor(file_format_id, anchor_data)
    anchor = Anchor.new(file_format_id: file_format_id, **anchor_data)
    anchor.id = anchor_data.fetch(:id)
    anchor.save!
  end

  def create_columns(event_data)
    columns = event_data.fetch(:columns)
    file_format_id = event_data.fetch(:id)
    columns.each do |column_data|
      create_column(file_format_id, column_data)
    end
  end

  def create_column(file_format_id, column_data)
    column = Column.new(file_format_id: file_format_id, **column_data)
    column.id = column_data.fetch(:id)
    column.save!
  end
end
