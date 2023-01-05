FactoryBot.define do
  factory :anchor do
    name { Faker::Alphanumeric.alpha(number: 10).upcase }
    description { Faker::Lorem.sentence(word_count: 3) }
  end
end
