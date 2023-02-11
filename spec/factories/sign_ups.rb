FactoryBot.define do
  factory :sign_up do
    full_name { "Данчо Е. Студент" }
    faculty_number { |n| n.to_s.rjust(5, '0') }

    trait :assigned do
      sequence(:token) { |n| "%040d" % n }
      sequence(:email) { |n| "person-#{n}@example.org" }
    end
  end
end
