FactoryBot.define do
  factory :voucher do
    sequence(:code) { |n| "%08d" % n }
  end
end
