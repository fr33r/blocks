FactoryBot.define do
  factory :data_file do
    filename { 'foo.csv' }
    total_row_count { 1 }
    file_format { association(:file_format) }
    uploaded

    trait :uploaded do
      state { Data::File::State::UPLOADED }
    end
  end
end
