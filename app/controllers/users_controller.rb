class UsersController < ApplicationController
  def index
    @users = User.students.sorted.at_page(params[:page])
  end

  def show
    @user = User.find(params[:id])

    @done_task_count = @user.tasks.count
    @total_task_count = Task.count
  end
end
