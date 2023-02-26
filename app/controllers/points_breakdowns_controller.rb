class PointsBreakdownsController < ApplicationController
  before_action :require_admin

  def index
    @users = User.sorted
    @total_task_points = Task.sum(:points)
  end
end
