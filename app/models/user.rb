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
#  points_breakdown       :json             not null
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
  has_many :completed_solutions, -> { completed }, class_name: 'Solution'
  has_many :tasks, -> { distinct }, through: :solutions, source: :task
  has_many :completed_tasks, -> { distinct }, through: :completed_solutions, source: :task

  has_many :created_free_tasks, class_name: 'FreeTask'
  has_many :free_task_solutions
  has_many :completed_free_task_solutions, -> { completed }, class_name: 'FreeTaskSolution'
  has_many :completed_free_tasks, -> { distinct }, through: :completed_solutions, source: :task

  has_many :vouchers
  has_many :user_tokens
  has_one :vimrc
  has_many :vimrc_revisions, through: :vimrc, source: :revisions

  mount_uploader :photo, PhotoUploader

  validates :password, confirmation: true, unless: -> { password.blank? }
  serialize :points_breakdown, PointsBreakdown

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
    points_breakdown.total
  end

  def update_points
    update!(points_breakdown: points_breakdown.update(self))
  end
end
