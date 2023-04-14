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

  delegate :body, :formatted_body, to: :last_revision, allow_nil: true

  def last_revision
    revisions.order(:id).last
  end
end
