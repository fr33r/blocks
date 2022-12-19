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
    row_number { 1 }
    uploaded
    file { association(:data_file) }

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

    transient do
      error_count { 0 }
    end

    trait :invalid do
      state { Data::Row::State::VALID }
      error_count { 1 }
    end

    after(:create) do |row, eval|
      create_list(:row_error, eval.error_count, row: row)
    end
  end
end
