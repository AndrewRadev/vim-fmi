# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  about                  :text
#  admin                  :boolean          default(FALSE), not null
#  comment_notification   :boolean          default(TRUE), not null
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  discord                :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  faculty_number         :string           not null
#  full_name              :string           not null
#  github                 :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  name                   :string           not null
#  photo                  :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  devise :database_authenticatable, :rememberable, :trackable, :recoverable

  scope :admins,   -> { where(admin: true) }
  scope :students, -> { where(admin: false) }

  has_many :solutions

  mount_uploader :photo, PhotoUploader

  validates :password, confirmation: true, unless: -> { password.blank? }

  class << self
    def shorten_name(name)
      name.gsub(/^(\S+) .* (\S+)$/, '\1 \2')
    end

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

  def points
    # TODO
    0
  end
end
