# == Schema Information
#
# Table name: vimrcs
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_vimrcs_on_user_id  (user_id)
#
class Vimrc < ApplicationRecord
  belongs_to :user
  has_many :revisions, class_name: 'VimrcRevision'

  def editable_by?(editor)
    return false if !editor.admin? && editor != user
    return false if Task.not_completed_by(user).exists?

    true
  end

  def last_revision
    revisions.order(:id).last
  end

  def body
    last_revision&.body.presence
  end

  def formatted_body
    last_revision&.formatted_body.presence
  end
end
