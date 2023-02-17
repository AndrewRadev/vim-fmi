FactoryBot.define do
  factory :task do
    input { "Foo\nBar" }
    output { "Bar\nBaz\nBla" }
  end
end
