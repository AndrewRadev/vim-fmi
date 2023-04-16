class VimrcsController < ApplicationController
  before_action :require_user

  def edit
    @vimrc = current_user.vimrc || Vimrc.new
    @vimrc_revision = @vimrc.revisions.last || @vimrc.revisions.new
    @incomplete_tasks = Task.not_completed_by(current_user)
  end

  def update
    @vimrc = current_user.vimrc || current_user.build_vimrc
    @vimrc_revision = @vimrc.revisions.new(vimrc_revision_params)

    if !@vimrc.editable_by?(current_user)
      flash[:error] = 'Vimrc-то е заключено, има отворени задачи'
      redirect_to action: :edit
    elsif @vimrc_revision.save
      flash[:notice] = 'Vimrc-то е обновено успешно'
      redirect_to action: :edit
    else
      flash[:error] = 'Имаше грешка'
      render action: :edit
    end
  end

  private

  def vimrc_revision_params
    params.require(:vimrc_revision).permit(:body)
  end
end
