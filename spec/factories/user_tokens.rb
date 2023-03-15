FactoryBot.define do
  factory :user_token do
    user
    sequence(:label) { |n| "label#{n}" }
    sequence(:body) { |n| "%040d" % n }

    trait :activated do
      activated_at { Time.current }
    end
  end
end
