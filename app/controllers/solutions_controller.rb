class SolutionsController < ApplicationController
  before_action :require_user, only: [:index, :create]

  def index
    @task = Task.find(params[:task_id])

    unless Solution.exists?(user_id: current_user.id, task_id: @task.id) or admin?
      deny_access
      return
    end

    @solutions = Solution.latest_for_task(params[:task_id])
  end

  def show
    @solution = Solution.find(params[:id])
    @other_solutions = @solution.user.solutions.where.not(id: @solution.id).where(task_id: @solution.task_id)

    deny_access unless @solution.visible_to?(current_user)
  end

  def create
    task = Task.find(params[:task_id])

    Solution.create!({
      task: task,
      user: current_user,
      token: SecureRandom.hex,
    })

    redirect_to task
  end
end
