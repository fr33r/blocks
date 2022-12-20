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
    attributes_names =
      %i[id state name created_at updated_at]
    attributes = event_data.slice(*attributes_names)
    format = FileFormat.new(**attributes)
    format.id = attributes.fetch(:id)
    format.save!
  end
end
