class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token

  def user_setup
    user_token = UserToken.inactive.find_by(body: params[:token])

    if user_token.blank?
      render json: { status: 'failed' }, status: 400
      return
    end

    user_token.update!(meta: meta_params, activated_at: Time.current)
    user = user_token.user

    render json: {
      id:             user.id,
      faculty_number: user.faculty_number,
      token:          user_token.body,
    }
  end

  def task
    solution = Solution.incomplete.find_by!(token: params.require(:token))
    task = solution.task

    if task.closed?
      render json: { status: 'failed' }, status: 400
      return
    end

    render json: {
      input:   task.input,
      output:  task.output,
      version: '0.2.0',
    }
  end

  def solution
    entry = Base64.decode64(params.require(:entry) || '')
    solution = Solution.incomplete.find_by(token: params.require(:challenge_id))

    if solution.blank?
      render json: { status: 'failed' }, status: 400
      return
    end

    solution.update!({
      script:       entry,
      points:       solution.task.points,
      completed_at: Time.current,
      meta:         meta_params,
      user_token:   params[:user_token],
    })
    solution.user.update_points
  end

  private

  def meta_params
    JSON.parse(params[:meta])
  rescue => e
    Sentry.capture_exception(e)
    {}
  end
end
