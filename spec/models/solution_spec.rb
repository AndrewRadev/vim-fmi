require 'rails_helper'

describe Solution do
  it "can find all the latest solutions for task" do
    task = create :task

    user1 = create :user
    user2 = create :user

    solution1 = create :solution, task: task, user: user1, created_at: 10.minutes.ago
    solution2 = create :solution, task: task, user: user2, created_at: 9.minutes.ago
    solution3 = create :solution, task: task, user: user1, created_at: 8.minutes.ago

    expect(Solution.latest_for_task(task.id)).to eq [solution3, solution2]
  end
end
