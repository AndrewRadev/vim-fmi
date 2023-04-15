require 'rails_helper'

describe Vimrc do
  it "renders the body of its latest revision" do
    vimrc = create :vimrc

    expect(vimrc.body).to be_nil
    expect(vimrc.formatted_body).to be_nil

    revision1 = create :vimrc_revision, vimrc: vimrc
    vimrc.reload

    expect(vimrc.body).to eq revision1.body
    expect(vimrc.formatted_body).to eq revision1.formatted_body

    revision2 = create :vimrc_revision, vimrc: vimrc
    vimrc.reload

    expect(vimrc.body).to eq revision2.body
    expect(vimrc.formatted_body).to eq revision2.formatted_body
  end

  it "returns nil if the last revision's body is only whitespace" do
    vimrc = create :vimrc
    revision = create :vimrc_revision, vimrc: vimrc, body: "\r\n"
    vimrc.reload

    expect(vimrc.body).to be_nil
    expect(vimrc.formatted_body).to be_nil
  end
end
