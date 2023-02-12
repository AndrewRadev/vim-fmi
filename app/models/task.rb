# == Schema Information
#
# Table name: tasks
#
#  id          :bigint           not null, primary key
#  closes_at   :datetime
#  description :text
#  input       :text             not null
#  opens_at    :datetime
#  output      :text             not null
#  points      :integer          default(1), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_tasks_on_closes_at  (closes_at)
#
class Task < ApplicationRecord
  scope :in_chronological_order, -> { order('closes_at ASC') }
  scope :visible, -> { in_chronological_order.where('opens_at >= ?', Time.current) }

  def closed?
    closes_at.past?
  end

  def hidden?
    opens_at.future?
  end

  def label
    "Задача за #{I18n.l(opens_at, format: "%A, %d.%m.%Y")}"
  end
end
