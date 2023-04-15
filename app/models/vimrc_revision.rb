# == Schema Information
#
# Table name: vimrc_revisions
#
#  id         :bigint           not null, primary key
#  body       :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  vimrc_id   :bigint           not null
#
# Indexes
#
#  index_vimrc_revisions_on_vimrc_id  (vimrc_id)
#
class VimrcRevision < ApplicationRecord
  belongs_to :vimrc
  has_many :solutions

  validates :body, presence: true, allow_blank: true

  def formatted_body
    return nil if !body?
    FormattedCode::Code.new(body, 'vim', [])
  end
end
