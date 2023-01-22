FactoryBot.define do
  factory :student_sign_up do
    full_name { "Its A. Student" }
    faculty_number { |n| n.to_s.rjust(5, '0') }
  end
end
