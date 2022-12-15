# frozen_string_literal: true

FactoryBot.define do
  factory :pipeline do
    transient do
      rule_count { 0 }
    end

    trait :with_active_rules do
      rule_count { 2 }

      after(:create) do |pipeline, eval|
        create_list(:rule, eval.rule_count, :active, pipeline: pipeline)
      end
    end

    trait :with_inactive_rules do
      rule_count { 2 }

      after(:create) do |pipeline, eval|
        create_list(:rule, eval.rule_count, :inactive, pipeline: pipeline)
      end
    end
  end
end
