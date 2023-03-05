require 'rails_helper'

describe PointsBreakdown do
  it "can calculate total points" do
    user = create :user
    expect(user.points).to eq 0

    user.update!(photo: attributes_for(:user, :with_photo).fetch(:photo))
    user.update_points
    expect(user.points).to eq 1

    create_list :solution, 3, :completed, user: user
    user.update_points
    expect(user.points).to eq 4

    create_list :voucher, 2, user: user
    user.update_points
    expect(user.points).to eq 6
  end

  it "calculates solution points correctly" do
    user = create :user
    create :solution, :completed, points: 1, user: user

    user.update_points
    expect(user.points).to eq 1

    task = create :task, points: 3
    create :solution, :completed, task: task, user: user
    # second solution for the same task, only 1 counts
    create :solution, :completed, task: task, user: user

    user.update_points
    expect(user.points).to eq 4

    # Not completed, not counted
    task = create :task, points: 10
    incomplete_solution = create :solution, task: task, user: user
    user.update_points
    expect(user.points).to eq 4

    incomplete_solution.update!(completed_at: Time.current, points: task.points)
    user.update_points
    expect(user.points).to eq 14
  end
end
