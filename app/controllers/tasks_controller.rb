class TasksController < ApplicationController
  before_action :require_admin, except: %w(index show)

  def index
    @tasks = if admin?
      Task.in_chronological_order
    else
      Task.visible
    end
  end

  def new
    @task = Task.new({
      opens_at:  Date.tomorrow.beginning_of_day,
      closes_at: Date.tomorrow.end_of_day,
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
    @task = Task.find(params[:id])

    # TODO (2023-02-06) Solutions
    # @current_user_solution = Solution.for(current_user, @task) if current_user

    deny_access if @task.hidden? and not admin?
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

  def task_params
    params.require(:task).permit(
      :opens_at, :closes_at,
      :input, :output,
      :description, :points,
    )
  end
end
