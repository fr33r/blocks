# frozen_string_literal: true

FactoryBot.define do
  factory :rule do
    active
    validation
    name { 'Test rule' }
    description { 'This is a test rule' }
    created_by { Faker::Internet.uuid }
    updated_by { Faker::Internet.uuid }

    trait :active do
      state { Rule::State::ACTIVE }
    end

    trait :inactive do
      state { Rule::State::INACTIVE }
    end

    trait :filter do
      rule_type { Rule::Type::FILTER }
    end

    trait :validation do
      rule_type { Rule::Type::VALIDATION }
    end
  end
end
