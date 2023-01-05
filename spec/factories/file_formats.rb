FactoryBot.define do
  factory :file_format do
    name { 'foo' }
    created

    transient do
      column_count { 0 }
      anchor_count { 0 }
    end

    trait :with_columns do
      column_count { 4 }

      after(:create) do |format, eval|
        create_list(:column, eval.column_count, file_format: format)
      end
    end

    trait :with_anchors do
      anchor_count { 2 }

      after(:create) do |format, eval|
        anchor_columns = format.columns.empty? ? [] : format.columns
        create_list(:anchor, eval.anchor_count, file_format: format, columns: anchor_columns)
      end
    end

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
