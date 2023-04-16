require 'rails_helper'

describe Vimrc do
  describe "#editable_by?" do
    it "is only editable by its owner or an admin" do
      vimrc = create :vimrc

      expect(vimrc).to be_editable_by(vimrc.user)
      expect(vimrc).not_to be_editable_by(create(:user))
      expect(vimrc).to be_editable_by(create(:user, admin: true))
    end

    it "is not editable if there are open tasks" do
      vimrc = create :vimrc
      task = create :task

      expect(vimrc).not_to be_editable_by(vimrc.user)

      # Incomplete solution:
      solution = create :solution, task: task, user: vimrc.user
      expect(vimrc).not_to be_editable_by(vimrc.user)

      # Completed solution:
      solution = create :solution, :completed, task: task, user: vimrc.user
      expect(vimrc).to be_editable_by(vimrc.user)

      # Non-open tasks, don't change editability
      create :task, opens_at: 1.day.from_now, closes_at: 2.days.from_now
      create :task, opens_at: 2.days.ago, closes_at: 1.day.ago
      expect(vimrc).to be_editable_by(vimrc.user)
    end
  end

  describe "#body" do
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
end
