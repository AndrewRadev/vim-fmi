FactoryBot.define do
  factory :task do
    sequence(:number) { |n| n }
    input { "Foo\nBar" }
    output { "Bar\nBaz\nBla" }
  end
end
