# == Schema Information
#
# Table name: user_tokens
#
#  id           :bigint           not null, primary key
#  activated_at :datetime
#  body         :string           not null
#  label        :string           not null
#  meta         :json             not null
#  trashed_at   :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_user_tokens_on_user_id  (user_id)
#
class UserToken < ApplicationRecord
  belongs_to :user

  validates :label, presence: true
  validates :body, presence: true, uniqueness: true

  scope :visible, -> { where(trashed_at: nil) }
  scope :active, -> { visible.where.not(activated_at: nil) }
  scope :inactive, -> { visible.where(activated_at: nil) }

  def solutions
    Solution.where(user_token: body)
  end

  def activate(meta)
    update!(meta: meta, activated_at: Time.current)
  end

  def trash
    update!(trashed_at: Time.current)
  end
end
