class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :set_sentry_user

  CLIENT_VERSION = '0.2.0'

  def user_setup
    token_body = params.require(:token)
    user_token = UserToken.inactive.find_by(body: token_body)

    if user_token.blank?
      render_error("Този токен (#{token_body}) не съществува или вече е бил активиран")
      return
    end

    if !user_token.update(meta: meta_params, activated_at: Time.current)
      render_error("Неочаквана грешка при активиране на токен #{token_body}")
      return
    end

    user = user_token.user

    render json: {
      id:             user.id,
      faculty_number: user.faculty_number,
      token:          user_token.body,
    }
  end

  def task
    token = params.require(:token)
    solution = Solution.incomplete.find_by(token: token)
    if solution.nil?
      if Solution.completed.exists?(token: token)
        render_error("Токена за упражнението (#{token}) вече е използван")
      else
        render_error("Токена за упражнението (#{token}) не съществува")
      end

      return
    end

    task = solution.task
    if task.closed?
      render_error("Задачата е била затворена на #{task.closes_at.iso8601}")
      return
    end

    render json: {
      input:          task.input,
      output:         task.output,
      file_extension: task.file_extension,
      version:        CLIENT_VERSION,
    }
  end

  def free_task
    token = params.require(:token)
    solution = FreeTaskSolution.find_by(token: token)
    if solution.nil?
      render_error("Токена за упражнението (#{token}) не съществува")
      return
    end

    free_task = solution.free_task
    if free_task.hidden?
      render_error("Задачата е била скрита на #{task.hidden_at.iso8601}")
      return
    end

    render json: {
      input:          free_task.input,
      output:         free_task.output,
      file_extension: free_task.file_extension,
      version:        CLIENT_VERSION,
    }
  end

  def solution
    entry = Base64.decode64(params.require(:entry) || '')
    token = params.require(:challenge_id)
    vimrc_revision_id = params[:vimrc_revision_id].presence&.to_i

    solution = Solution.incomplete.find_by(token: token)
    if solution.nil?
      if Solution.completed.exists?(token: token)
        render_error("Токена за упражнението (#{token}) вече е използван")
      else
        render_error("Токена за упражнението (#{token}) не съществува")
      end

      return
    end

    solution_updates = {
      script:            entry,
      points:            solution.task.points,
      completed_at:      Time.current,
      meta:              meta_params,
      user_token:        params[:user_token],
      vimrc_revision_id: vimrc_revision_id,
    }

    if !solution.update(solution_updates)
      render_error("Неочаквана грешка при записване на упражнение #{token}")
      return
    end

    solution.user.update_points
    render json: { message: "OK" }
  end

  def free_task_solution
    entry = Base64.decode64(params.require(:entry) || '')
    token = params.require(:challenge_id)
    vimrc_revision_id = params[:vimrc_revision_id].presence&.to_i

    solution = FreeTaskSolution.find_by(token: token)
    if solution.nil?
      render_error("Токена за упражнението (#{token}) не съществува")
      return
    end

    solution_updates = {
      script:            entry,
      completed_at:      Time.current,
      meta:              meta_params,
      user_token:        params[:user_token],
      vimrc_revision_id: vimrc_revision_id,
    }

    if !solution.update(solution_updates)
      render_error("Неочаквана грешка при записване на упражнение #{token}")
      return
    end

    render json: { message: "OK" }
  end

  def vimrc
    token_body = params.require(:token)
    user_token = UserToken.active.find_by(body: token_body)

    if user_token.blank?
      render_error("Този токен (#{token_body}) не съществува или не е бил активиран")
      return
    end

    vimrc = user_token.user.vimrc

    render json: {
      revision_id: vimrc&.last_revision&.id,
      body: vimrc&.body,
    }
  end

  private

  def render_error(message)
    render json: { message: message }, status: 400
  end

  def meta_params
    JSON.parse(params[:meta])
  rescue => e
    Sentry.capture_exception(e)
    {}
  end
end
