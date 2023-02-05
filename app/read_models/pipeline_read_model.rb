# frozen_string_literal: true

class PipelineReadModel
  def handle(event)
    case event
      when Evaluation::Events::PipelineCreated
        create_pipeline!(event.data)
    end
  end

  def all
    Pipeline.all
  end

  def find(id)
    Pipeline.find(id)
  end

  def self.configure(event_store)
    handler = ->(event) { self.new.handle(event) }
    event_store.subscribe(handler, to: Evaluation::Events::ALL)
  end
  
  private

  def create_pipeline!(event_data)
    attributes_names = %i[id created_at updated_at]
    attributes = event_data.slice(*attributes_names)
    pipeline = Pipeline.new(**attributes)
    pipeline.id = attributes.fetch(:id)
    pipeline.save!
  end
end
