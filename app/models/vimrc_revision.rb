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

  scope :in_chronological_order, -> { order('created_at DESC') }

  def formatted_body
    return nil if !body?
    FormattedCode::Code.new(body, 'vim', [])
  end

  def previous_revision
    vimrc.revisions.order(:id).where('id < ?', id).last
  end

  def diff_stats
    previous = previous_revision
    return nil if !previous

    FormattedCode::Diff.new(previous.body, body, 'vim', []).stats
  end

  def formatted_diff
    previous = previous_revision
    return nil if !previous

    FormattedCode::Diff.new(previous.body, body, 'vim', [])
  end
end
