class SolutionsController < ApplicationController
  before_action :require_user, only: :create
  skip_before_action :verify_authenticity_token, only: :update

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
        solution.update!(script: entry, points: solution.task.points)
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
