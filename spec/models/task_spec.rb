require 'rails_helper'

describe Task do
  it "is visible if its #opens_at is due" do
    Timecop.freeze do
      task1 = create :task, opens_at: 1.day.ago
      task2 = create :task, opens_at: 2.days.from_now
      task3 = create :task, opens_at: 3.days.from_now

      expect(Task.visible).to match_array [task1]

      Timecop.travel(2.5.days.from_now)
      expect(Task.visible).to match_array [task1, task2]

      Timecop.travel(1.day.from_now)
      expect(Task.visible).to match_array [task1, task2, task3]
    end
  end

  it "is open if its #opens_at is due and its #closes_at is not passed" do
    Timecop.freeze do
      task1 = create :task, opens_at: 1.day.ago, closes_at: 1.day.from_now
      task2 = create :task, opens_at: 2.days.from_now, closes_at: 3.days.from_now
      task3 = create :task, opens_at: 3.days.from_now, closes_at: 4.days.from_now

      expect(Task.open).to eq [task1]

      Timecop.travel(2.5.days.from_now)
      expect(Task.open).to eq [task2]

      Timecop.travel(1.day.from_now)
      expect(Task.open).to eq [task3]
    end
  end

  describe "#completed_by?" do
    it "checks if the given user has completed the task" do
      task = create :task

      solution = create :solution, task: task, completed_at: nil
      expect(task.completed_by?(solution.user)).to be_falsey

      solution = create :solution, :completed, task: task
      expect(task.completed_by?(solution.user)).to be_truthy

      user = create :user
      expect(task.completed_by?(user)).to be_falsey
    end

    it "doesn't break when given a nil user" do
      task = create :task
      expect(task.completed_by?(nil)).to be_falsey
    end
  end
end
