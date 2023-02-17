FactoryBot.define do
  factory :solution do
    sequence(:token) { |n| "%040d" % n }

    trait :completed do
      user
      script { "iplaceholder" }
    end
  end
end
