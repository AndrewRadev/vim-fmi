FactoryBot.define do
  factory :free_task do
    user

    sequence(:label) { |n| "Free task #{n}" }
    input { "Foo\nBar" }
    output { "Bar\nBaz\nBla" }
  end
end
