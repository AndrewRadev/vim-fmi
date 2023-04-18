# == Schema Information
#
# Table name: free_tasks
#
#  id             :bigint           not null, primary key
#  description    :text
#  file_extension :string
#  filetype       :string
#  hidden_at      :datetime
#  input          :text             not null
#  label          :string           not null
#  output         :text             not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :bigint           not null
#
# Indexes
#
#  index_free_tasks_on_user_id  (user_id)
#
class FreeTask < ApplicationRecord
  belongs_to :user
  has_many :solutions, class_name: 'FreeTaskSolution', dependent: :destroy
  has_many :completed_solutions, -> { completed }, class_name: 'FreeTaskSolution'
  has_many :completed_users,     -> { distinct }, through: :completed_solutions, source: :user

  validates :label, presence: true, uniqueness: true
  validates :input, :output, presence: true

  validate :label_does_not_match_task

  scope :visible, -> { where(hidden_at: nil) }
  scope :in_chronological_order, -> { order('created_at DESC') }

  def self.not_completed_by(user)
    open.where.not(id: user.completed_free_tasks)
  end

  def completed_by?(user)
    return false if user.blank?

    solutions.completed.exists?(user_id: user.id)
  end

  def hidden?
    hidden_at?
  end

  def formatted_input
    @formatted_input ||= FormattedCode::Code.new(input, filetype, [])
  end

  def formatted_output
    @formatted_output ||= FormattedCode::Code.new(output, filetype, [])
  end

  private

  def label_does_not_match_task
    if label =~ /^\s*Упражнение\s+\d+\s*$/ && !user.admin?
      errors.add :label, "не може да има формата 'Упражнение NNN'"
    end
  end
end
