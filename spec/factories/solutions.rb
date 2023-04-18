FactoryBot.define do
  factory :solution do
    user
    task
    sequence(:token) { |n| "%040d" % n }

    trait :completed do
      script { "iplaceholder" }
      completed_at { Time.current }
      points { task.points }
    end
  end
end
