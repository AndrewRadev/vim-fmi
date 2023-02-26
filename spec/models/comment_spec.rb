require 'rails_helper'

describe Comment do
  describe "(editing)" do
    let(:comment) { build :comment }

    it "is editable by its author" do
      expect(comment).to be_editable_by comment.user
    end

    it "is editable by admins" do
      expect(comment).to be_editable_by build(:user, :admin)
    end

    it "is not editable by other users" do
      expect(comment).not_to be_editable_by build(:user)
    end
  end
end
