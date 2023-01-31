class DashboardsController < ApplicationController
  before_action :require_user

  def show
    @points = 0
    @total = 0

    # @points = current_user.points
    # @total  = PointsBreakdown.count
  end
end
