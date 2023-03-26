# == Schema Information
#
# Table name: tasks
#
#  id             :bigint           not null, primary key
#  closes_at      :datetime
#  description    :text
#  file_extension :string
#  filetype       :string
#  input          :text             not null
#  number         :integer          not null
#  opens_at       :datetime
#  output         :text             not null
#  points         :integer          default(1), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_tasks_on_closes_at  (closes_at)
#  index_tasks_on_number     (number) UNIQUE
#
class Task < ApplicationRecord
  has_many :solutions
  has_many :completed_solutions, -> { completed }, class_name: 'Solution'
  has_many :completed_users, -> { distinct }, through: :completed_solutions, source: :user

  validates :opens_at, :closes_at, presence: true

  scope :in_numeric_order, -> { order('number DESC') }
  scope :in_chronological_order, -> { order('closes_at DESC') }
  scope :visible, -> { in_chronological_order.where('opens_at <= ?', Time.current) }

  def completed_by?(user)
    return false if user.blank?

    solutions.completed.exists?(user_id: user.id)
  end

  def closed?
    closes_at.past?
  end

  def hidden?
    opens_at.future?
  end

  def label
    "Упражнение #{"%03d" % number}"
  end
end
