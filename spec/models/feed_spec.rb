require 'rails_helper'

describe Feed do
  it "aggregates comments" do
    comment   = create(:comment)
    commenter = comment.user
    solution  = comment.solution
    task      = solution.task

    item = last_activity

    expect(item.user_id).to      eq commenter.id
    expect(item.user_name).to    eq commenter.name
    expect(item.target_id).to    eq solution.id
    expect(item.secondary_id).to eq task.id
    expect(item.kind).to         eq :comment

    expect(item.happened_at).to be_within(1.second).of(comment.created_at)
  end

  it "aggregates submitted solutions" do
    solution = create(:solution)
    user     = solution.user
    task     = solution.task

    item = last_activity

    expect(item.user_id).to      eq user.id
    expect(item.user_name).to    eq user.name
    expect(item.target_id).to    eq solution.id
    expect(item.secondary_id).to eq task.id
    expect(item.kind).to         eq :solution

    expect(item.happened_at).to be_within(1.second).of(solution.updated_at)
  end

  it "aggregates vimrc revisions" do
    vimrc_revision = create(:vimrc_revision)
    vimrc = vimrc_revision.vimrc
    user = vimrc.user

    item = last_activity

    expect(item.user_id).to      eq user.id
    expect(item.user_name).to    eq user.name
    expect(item.target_id).to    eq vimrc_revision.id
    expect(item.secondary_id).to eq vimrc.id
    expect(item.kind).to         eq :vimrc_revision

    expect(item.happened_at).to be_within(1.second).of(vimrc_revision.created_at)
  end

  def last_activity
    Feed.new.enum_for(:each_activity).first
  end
end
