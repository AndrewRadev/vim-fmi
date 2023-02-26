class ProfilesController < ApplicationController
  before_action :require_user

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    user_params = params.require(:user).permit(
      :photo,
      :remove_photo,
      :github,
      :discord,
      :about,
      :comment_notification,
      :password,
      :password_confirmation
    )

    if @user.update(user_params)
      @user.update_points
      bypass_sign_in @user
      redirect_to dashboard_path, notice: 'Профилът ви е обновен'
    else
      render :edit
    end
  end
end
