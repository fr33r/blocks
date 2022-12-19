FactoryBot.define do
  factory :file_format do
    name { 'foo' }
    created

    trait :created do
      state { Data::FileFormat::State::CREATED }
    end

    trait :active do
      state { Data::FileFormat::State::ACTIVE }
    end

    trait :inactive do
      state { Data::FileFormat::State::INACTIVE }
    end
  end
end
