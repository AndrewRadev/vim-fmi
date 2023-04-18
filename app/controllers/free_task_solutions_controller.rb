class FreeTaskSolutionsController < ApplicationController
  before_action :require_user, only: [:index, :create]

  def index
    @free_task = FreeTask.find(params[:free_task_id])

    unless admin? or @free_task.closed? or @free_task.completed_by?(current_user)
      deny_access
      return
    end

    @free_task_solutions = FreeTaskSolution.completed.
      for_task(params[:free_task_id], order_type: params[:order])
  end

  def show
    @free_task = FreeTask.find(params[:free_task_id])
    @free_task_solution = @free_task.solutions.find(params[:id])
    @other_solutions = @free_task_solution.user.solutions.
      where.not(id: @free_task_solution.id).
      where(free_task_id: @free_task.id)

    deny_access unless @free_task_solution.visible_to?(current_user)
  end

  def create
    free_task = FreeTask.find(params[:free_task_id])

    FreeTaskSolution.create!({
      free_task: free_task,
      user: current_user,
      token: SecureRandom.hex,
    })

    redirect_to free_task
  end

  def destroy
    free_task = FreeTask.find(params[:free_task_id])
    solution = free_task.solutions.incomplete.find(params[:id])
    solution.destroy!

    redirect_to free_task
  end
end
