FactoryBot.define do
  factory :user do
    email { |n| "user-#{n}@example.org" }
    password { "password" }
    full_name { "Student A. User" }
    name { "Student" }
    faculty_number { |n| n.to_s.rjust(5, '0') }

    trait :with_photo do
      photo { Rack::Test::UploadedFile.new Rails.root.join('spec/fixtures/files/mind_flayer.jpg') }
    end

    trait :admin do
      admin { true }
    end
  end
end
