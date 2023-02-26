FactoryBot.define do
  factory :comment do
    user
    solution
    body { "Example" }
  end
end
