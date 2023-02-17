# == Schema Information
#
# Table name: solutions
#
#  id         :bigint           not null, primary key
#  meta       :json             not null
#  points     :integer          default(0), not null
#  script     :binary
#  token      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  task_id    :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_solutions_on_task_id  (task_id)
#  index_solutions_on_token    (token) UNIQUE
#  index_solutions_on_user_id  (user_id)
#
class Solution < ApplicationRecord
  belongs_to :task
  belongs_to :user
  validates :token, presence: true, uniqueness: true

  scope :incomplete, -> { where(points: 0) }
  scope :completed, -> { where.not(points: 0) }
  scope :in_chronological_order, -> { order('updated_at DESC') }

  def self.latest_for_task(task_id)
    latest_scope = where(task_id: task_id).
      select('DISTINCT ON (user_id) solutions.id').
      order('user_id, solutions.created_at DESC')

    where(id: latest_scope).order('created_at DESC')
  end

  def user_name
    user.name
  end
end
