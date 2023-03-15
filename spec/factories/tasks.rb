FactoryBot.define do
  factory :task do
    opens_at { 1.day.ago }
    closes_at { 1.day.from_now }

    sequence(:number) { |n| n }
    input { "Foo\nBar" }
    output { "Bar\nBaz\nBla" }
  end
end
