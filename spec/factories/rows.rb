# frozen_string_literal: true

FactoryBot.define do
  factory :row do
    data do
      {
        'COLUMN_1' => 'foo',
        'COLUMN_2' => 'bar',
        'COLUMN_3' => 'biz',
        'COLUMN_4' => 'baz',
      }
    end
    data_hash { Hashers::Md5.hash(data.to_yaml) }
    created_by { Faker::Internet.uuid }
    updated_by { Faker::Internet.uuid }

    trait :uploaded do
      state { Data::Row::State::UPLOADED }
    end

    trait :filtered do
      state { Data::Row::State::FILTERED }
    end

    trait :ingested do
      state { Data::Row::State::INGESTED }
    end

    trait :valid do
      state { Data::Row::State::VALID }
    end

    trait :invalid do
      state { Data::Row::State::VALID }
      row_errors { [ association(:row_error) ] }
    end
  end
end