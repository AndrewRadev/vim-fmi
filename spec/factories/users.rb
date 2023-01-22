FactoryBot.define do
  factory :user do
    email { |n| "user-#{n}@example.org" }
    password { "password" }
    full_name { "Student User" }
    name { "Student" }
    faculty_number { |n| n.to_s.rjust(5, '0') }
  end
end
