class FreeTasksController < ApplicationController
  before_action :require_user, except: %w(index show)
  before_action :require_admin, only: %w(hide)

  def index
    @free_tasks = FreeTask.visible.in_chronological_order
    @user_tokens = current_user&.user_tokens

    respond_to do |format|
      format.html
      format.rss { response.headers['Content-Type'] = 'application/rss+xml; charset=utf-8' }
    end
  end

  def new
    @free_task = FreeTask.new(user: current_user)
  end

  def create
    @free_task = FreeTask.new(free_task_create_params)
    @free_task.user = current_user

    if @free_task.save
      redirect_to @free_task, notice: 'Упражнението е създадено успешно'
    else
      render :new
    end
  end

  def show
    @free_task = FreeTask.find(params[:id])

    if current_user
      solutions = current_user.free_task_solutions.where(free_task: @free_task)

      @incomplete_solution = solutions.incomplete.in_chronological_order.first
      @completed_solutions = solutions.completed.in_chronological_order
    end

    deny_access if @free_task.hidden? and not admin?
  end

  def edit
    @free_task = FreeTask.find(params[:id])
  end

  def update
    @free_task = FreeTask.find(params[:id])

    if @free_task.update(free_task_update_params)
      redirect_to @free_task, notice: 'Упражнението е обновено успешно'
    else
      render :edit
    end
  end

  def hide
    @free_task = FreeTask.find(params[:id])
    @free_task.update!(hidden_at: Time.current)

    flash[:notice] = "Упражнението е скрито"
    redirect_to action: :index
  end

  private

  def free_task_create_params
    params.require(:free_task).permit(
      :label, :description,
      :input, :output,
      :filetype, :file_extension,
    )
  end

  def free_task_update_params
    params.require(:free_task).permit(:label, :description)
  end
end
