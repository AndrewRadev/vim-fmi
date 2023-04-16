class VimrcRevisionsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
  end

  def show
    @user = User.find(params[:user_id])
    @vimrc_revision = @user.vimrc_revisions.find(params[:id])
  end
end
