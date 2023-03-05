require 'vim_keylog'

class TasksController < ApplicationController
  before_action :require_admin, except: %w(index show)

  def index
    @tasks = if admin?
      Task.in_numeric_order
    else
      Task.visible.in_numeric_order
    end

    @user_tokens = current_user&.user_tokens
  end

  def new
    @task = Task.new({
      opens_at:  Date.tomorrow.beginning_of_day,
      closes_at: Date.tomorrow.end_of_day,
      number:    (Task.maximum(:number) || 0) + 1,
    })
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to @task, notice: 'Задачата е създадена успешно'
    else
      render :new
    end
  end

  def show
    respond_to do |format|
      format.json do
        # ID is token
        solution = Solution.find_by!(token: params[:id])
        task = solution.task

        render json: {
          input: task.input,
          output: task.output,
          version: '0.1.0',
        }
      end

      format.html do
        @task = Task.find(params[:id])

        if current_user
          solutions = current_user.solutions.where(task: @task)

          @incomplete_solution = solutions.incomplete.in_chronological_order.first
          @completed_solutions = solutions.completed.in_chronological_order
        end

        deny_access if @task.hidden? and not admin?
      end
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      redirect_to @task, notice: 'Задачата е обновена успешно'
    else
      render :edit
    end
  end

  private

  def task_params
    params.require(:task).permit(
      :number,
      :opens_at, :closes_at,
      :input, :output,
      :description, :points,
    )
  end
end
