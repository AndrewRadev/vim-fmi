# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  about                  :text
#  admin                  :boolean          default(FALSE), not null
#  comment_notification   :boolean          default(TRUE), not null
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  discord                :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  faculty_number         :string           not null
#  failed_attempts        :integer          default(0), not null
#  full_name              :string           not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  locked_at              :datetime
#  name                   :string           not null
#  photo                  :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  unconfirmed_email      :string
#  unlock_token           :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#
class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
    :validatable, :confirmable, :lockable, :trackable

  scope :admins,   -> { where(admin: true) }
  scope :students, -> { where(admin: false) }

  has_many :solutions

  mount_uploader :photo, PhotoUploader

  validates :password, confirmation: true, unless: -> { password.blank? }

  class << self
    def sorted
      order(Arel.sql(<<~END))
        (CASE
          WHEN photo = '' THEN 1
          WHEN photo IS NULL THEN 1
          ELSE 0
        END) ASC,
        created_at ASC
      END
    end

    def at_page(page_number)
      paginate page: page_number, per_page: 20
    end
  end
end
