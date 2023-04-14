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
end
