require 'rails_helper'

RSpec.describe Evaluation::Events do
  describe Evaluation::Events::PipelineRuleCreated do
    it { should be_an_event(described_class) }
  end

  describe Evaluation::Events::PipelineRuleActivated do
    it { should be_an_event(described_class) }
  end

  describe Evaluation::Events::PipelineRuleInactivated do
    it { should be_an_event(described_class) }
  end

  describe Evaluation::Events::PipelineRuleUpdated do
    it { should be_an_event(described_class) }
  end

  describe Evaluation::Events::PipelineCreated do
    it { should be_an_event(described_class) }
  end

  describe Evaluation::Events::PipelineActivated do
    it { should be_an_event(described_class) }
  end

  describe Evaluation::Events::PipelineInactivated do
    it { should be_an_event(described_class) }
  end
end
