FactoryBot.define do
  factory :free_task_solution do
    user
    free_task
    sequence(:token) { |n| "%040d" % n }

    trait :completed do
      script { "iplaceholder" }
      completed_at { Time.current }
    end
  end
end
