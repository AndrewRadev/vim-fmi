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

  def last_revision
    revisions.order(:id).last
  end

  def body
    last_revision&.body
  end

  def formatted_body
    raw_body = body
    return nil if raw_body.nil?

    FormattedCode::Code.new(raw_body, 'vim', [])
  end
end
