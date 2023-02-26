# == Schema Information
#
# Table name: comments
#
#  id          :bigint           not null, primary key
#  body        :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  solution_id :bigint           not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_comments_on_solution_id  (solution_id)
#  index_comments_on_user_id      (user_id)
#
class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :solution

  validates :body, presence: true

  delegate :task, :task_name, to: :solution

  def editable_by?(user)
    self.user == user or user&.admin?
  end

  def user_name
    user.name
  end
end
