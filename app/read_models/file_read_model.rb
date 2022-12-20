# frozen_string_literal: true

class FileReadModel
  def handle(event)
    case event
      when Data::Events::FileUploaded
        create_file!(event.data)
    end
  end

  def all
    DataFile.all
  end

  def find(id)
    DataFile.find(id)
  end

  def self.configure(event_store)
    handler = ->(event) { self.new.handle(event) }
    event_store.subscribe(handler, to: Data::Events::ALL)
  end

  private

  def create_file!(event_data)
    attributes_names =
      %i[id state file_format_id filename total_row_count uploaded_at updated_at]
    attributes = event_data.slice(*attributes_names)
    file = DataFile.new(**attributes)
    file.id = attributes.fetch(:id)
    file.save!
  end
end
