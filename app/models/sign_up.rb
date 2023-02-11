# == Schema Information
#
# Table name: sign_ups
#
#  id             :bigint           not null, primary key
#  email          :string
#  faculty_number :string
#  full_name      :string
#  token          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class SignUp < ApplicationRecord
  validates :full_name, presence: true
  validates :faculty_number, presence: true, uniqueness: true
  validate :faculty_number_must_be_unique_across_users_too

  class << self
    def with_token(token)
      return nil if token.blank?
      find_by(token: token)
    end

    def next_fake_faculty_number
      numbers = [User, SignUp].flat_map do |model|
        model.
          where("faculty_number LIKE 'x%'").
          pluck(:faculty_number)
      end

      last_number = numbers.
        map { |n| n[/^x(\d+)$/, 1] }.
        compact.
        map(&:to_i).
        sort.
        last || 0

      sprintf 'x%05d', last_number + 1
    end
  end

  def assign_to(email)
    update! email: email, token: random_string(40)
  end

  def faculty_number_must_be_unique_across_users_too
    if User.exists? faculty_number: faculty_number
      errors.add :faculty_number, 'Вече има потребител с този факултетен номер'
    end
  end

  private

  def random_string(length)
    (1..length).map { rand(36).to_s(36) }.join
  end
end
