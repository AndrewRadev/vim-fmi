require 'vim_keylog'

# == Schema Information
#
# Table name: solutions
#
#  id                :bigint           not null, primary key
#  completed_at      :datetime
#  meta              :json             not null
#  points            :integer          default(0), not null
#  script            :binary
#  script_keys       :string           is an Array
#  token             :string           not null
#  user_token        :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  task_id           :bigint           not null
#  user_id           :bigint           not null
#  vimrc_revision_id :bigint
#
# Indexes
#
#  index_solutions_on_task_id  (task_id)
#  index_solutions_on_token    (token) UNIQUE
#  index_solutions_on_user_id  (user_id)
#
class Solution < ApplicationRecord
  COMPACTED_KEYS = Set.new([
    '<Left>', '<Right>', '<Up>', '<Down>',
    '<BS>', '<Del>',
    '<ScrollWheelUp>', '<ScrollWheelDown>',
  ]).freeze
  ARROWS = Set.new(['<Left>', '<Right>', '<Up>', '<Down>']).freeze
  MOUSE = Set.new([
    '<LeftMouse>', '<LeftRelease>', '<LeftDrag>',
    '<RightMouse>', '<RightRelease>', '<RightDrag>',
    '<ScrollWheelUp>', '<ScrollWheelDown>',
  ]).freeze

  belongs_to :task
  belongs_to :user
  belongs_to :vimrc_revision, optional: true
  validates :token, presence: true, uniqueness: true

  before_save :update_script_keys

  scope :incomplete, -> { where(completed_at: nil) }
  scope :completed, -> { where.not(completed_at: nil) }
  scope :in_chronological_order, -> { order('updated_at DESC') }

  def self.for_task(task_id, order_type: nil)
    latest_scope = where(task_id: task_id).select('DISTINCT ON (user_id) solutions.id')

    case order_type
    when 'key-count'
      latest_scope = latest_scope.order(Arel.sql('user_id, array_length(solutions.script_keys, 1) ASC'))
    when 'time-spent'
      latest_scope = latest_scope.order(Arel.sql('user_id, completed_at - created_at ASC'))
    else
      latest_scope = latest_scope.order(Arel.sql('user_id, completed_at DESC'))
    end

    solutions = where(id: latest_scope)

    case order_type
    when 'key-count'
      order = 'array_length(solutions.script_keys, 1) ASC, completed_at ASC'
      solutions.order(Arel.sql(order))
    when 'time-spent'
      solutions.order(Arel.sql('completed_at - created_at ASC'))
    else
      solutions.order('completed_at DESC')
    end
  end

  def user_from_token
    UserToken.find_by(body: user_token)&.user
  end

  def user_name
    user.name
  end

  def task_label
    task.label
  end

  def visible_to?(user)
    return true if user&.admin?
    return true if task.closed?

    self.user == user
  end

  def commentable_by?(user)
    return false if user.nil?

    task.closed? or user.admin? or self.user == user
  end

  def compact_script_keys
    sequence = []
    result_keys = []

    script_keys.each do |key|
      if sequence.empty? || sequence.last == key
        sequence << key
      else
        if sequence.size > 1 && COMPACTED_KEYS.include?(sequence.last)
          result_keys << "[#{ sequence.size }x#{ sequence.last }]"
        else
          result_keys += sequence
        end

        sequence = [key]
      end
    end

    if sequence.size > 1 && COMPACTED_KEYS.include?(sequence.last)
      result_keys << "[#{ sequence.size }x#{ sequence.first }]"
    else
      result_keys += sequence
    end

    result_keys
  end

  def warnings
    script_keys.map do |key|
      if ARROWS.include?(key)
        '🏹'
      elsif MOUSE.include?(key)
        '🐁'
      end
    end.compact.uniq
  end

  def update_script_keys
    self.script_keys = VimKeylog.new(self.script).to_a
  end
end
