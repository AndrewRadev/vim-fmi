class SolutionsController < ApplicationController
  before_action :require_user, only: [:index, :create]
  skip_before_action :verify_authenticity_token, only: :update

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

  def update
    entry = Base64.decode64(params[:entry] || '')

    if entry && entry.size < 2
      cheat = true
    elsif params[:challenge_id] && !params[:apikey].empty? && !params[:apikey].nil?
      cheat = false
      solution = Solution.find_by(token: params[:challenge_id])

      if solution
        # TODO (2023-02-14) Verify user with API key, change param names
        # TODO (2023-02-26) Don't allow the same solution to be submitted twice
        solution.update!({
          script:       entry,
          points:       solution.task.points,
          completed_at: Time.current,
        })
        solution.user.update_points
      end
    end

    respond_to do |format|
      if !cheat && solution
        format.json { render json: { status: 'ok' } }
      else
        format.json { render json: { status: 'failed' }, status: 400 }
      end
    end
  end
end
