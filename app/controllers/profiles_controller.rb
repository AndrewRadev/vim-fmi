class ProfilesController < ApplicationController
  before_action :require_user

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    # TODO (2023-01-31) Password updates?
    user_params = params.require(:user).permit(
      :photo,
      :github,
      :discord,
      :about,
      :comment_notification,
      :password,
      :password_confirmation
    )

    if @user.update(user_params)
      sign_in @user, bypass: true
      redirect_to dashboard_path, notice: 'Профилът ви е обновен'
    else
      render :edit
    end
  end
end
