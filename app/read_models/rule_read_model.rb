# frozen_string_literal: true

class RuleReadModel
  def handle(event)
    case event
      when Evaluation::Events::PipelineRuleCreated
        create_rule!(event.data)
      when Evaluation::Events::PipelineRuleActivated
        activate_rule!(event.data)
      when Evaluation::Events::PipelineRuleInactivated
        inactivate_rule!(event.data)
    end
  end

  def all
    Rule.all
  end

  def find(id)
    Rule.find(id)
  end

  def self.configure(event_store)
    handler = ->(event) { self.new.handle(event) }
    event_store.subscribe(handler, to: Evaluation::Events::ALL)
  end

  private

  def create_rule!(event_data)
    attributes_names = %i[
      id
      type
      state
      condition
      name
      description
      created_by
      created_at
      updated_by
      updated_at
    ]
    attributes = event_data.slice(*attributes_names)
    attributes[:rule_type] = attributes.delete(:type)
    rule = Rule.new(**attributes)
    rule.id = attributes.fetch(:id)
    rule.save!
  end

  def activate_rule!(event_data)
    attributes_names = %i[id state updated_by updated_at]
    attributes = event_data.slice(*attributes_names)
    rule = Rule.new(**attributes)
    rule.id = attributes.fetch(:id)
    rule.save!
  end

  def inactivate_rule!(event_data)
    attributes_names = %i[id state updated_by updated_at]
    attributes = event_data.slice(*attributes_names)
    rule = Rule.new(**attributes)
    rule.id = attributes.fetch(:id)
    rule.save!
  end
end
