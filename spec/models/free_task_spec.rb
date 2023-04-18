require 'rails_helper'

describe FreeTask do
  describe "#completed_by?" do
    it "checks if the given user has completed the task" do
      free_task = create :free_task

      solution = create :free_task_solution, free_task: free_task, completed_at: nil
      expect(free_task.completed_by?(solution.user)).to be_falsey

      solution = create :free_task_solution, :completed, free_task: free_task
      expect(free_task.completed_by?(solution.user)).to be_truthy

      user = create :user
      expect(free_task.completed_by?(user)).to be_falsey
    end

    it "doesn't break when given a nil user" do
      free_task = create :free_task
      expect(free_task.completed_by?(nil)).to be_falsey
    end

    it "validates that its name doesn't match a standard Task name, unless the author is an admin" do
      user = create :user
      admin = create :user, :admin

      free_task = build(:free_task, user: user, label: "Упражнение 001")
      expect(free_task).not_to be_valid

      free_task = build(:free_task, user: user, label: "Упражнение 13")
      expect(free_task).not_to be_valid

      free_task = build(:free_task, user: user, label: "  Упражнение   4 ")
      expect(free_task).not_to be_valid

      free_task = build(:free_task, user: admin, label: "Упражнение 001")
      expect(free_task).to be_valid
    end
  end
end
