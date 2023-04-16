require 'rails_helper'

describe VimrcRevision do
  it "shows a diff with its previous revision" do
    vimrc = create :vimrc
    revision1 = create :vimrc_revision, vimrc: vimrc, body: 'Content 1'
    revision2 = create :vimrc_revision, vimrc: vimrc, body: 'Content 2'
    revision3 = create :vimrc_revision, vimrc: vimrc, body: "Content 2\nContent 3\nContent 4"

    expect(revision1.formatted_diff).to be_nil

    expect(revision2.diff_stats).to eq [1, 1] # [added, removed]
    expect(revision2.formatted_diff.lines.length).to eq 2

    expect(revision3.diff_stats).to eq [2, 0] # [added, removed]
    expect(revision3.formatted_diff.lines.length).to eq 3
  end
end
