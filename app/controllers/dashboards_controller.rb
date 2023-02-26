class DashboardsController < ApplicationController
  before_action :require_user

  def show
    @points = current_user.points
  end
end
