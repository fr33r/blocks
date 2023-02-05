FactoryBot.define do
  factory :column do
    name { Faker::Alphanumeric.alpha(number: 10).upcase }
    description { Faker::Lorem.sentence(word_count: 3) }
    data_type { Data::Column::DataType::STRING }
    required { Faker::Boolean.boolean }
  end
end
