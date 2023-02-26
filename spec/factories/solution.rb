FactoryBot.define do
  factory :solution do
    task
    sequence(:token) { |n| "%040d" % n }

    trait :completed do
      user
      script { "iplaceholder" }
      completed_at { Time.current }
      points { task.points }
    end
  end
end
