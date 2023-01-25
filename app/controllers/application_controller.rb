class ApplicationController < ActionController::Base
  helper_method :can_edit?, :logged_in?, :admin?

  private

  def after_sign_in_path_for(something)
    dashboard_path
  end

  def logged_in?
    !!current_user
  end

  def admin?
    current_user.try(:admin?)
  end

  def can_edit?(something)
    something.editable_by? current_user
  end

  # TODO (2023-01-25) Translate
  def deny_access(message = 'Нямате достъп до тази страница.')
    redirect_to root_path, alert: message
  end

  def require_user
    deny_access unless logged_in?
  end

  def require_admin
    deny_access unless current_user.try(:admin?)
  end
end
