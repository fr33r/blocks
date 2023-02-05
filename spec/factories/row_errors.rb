# frozen_string_literal: true

FactoryBot.define do
  factory :row_error do
    message { 'oops!' }
    rule_id { Faker::Internet.uuid }
  end
end
