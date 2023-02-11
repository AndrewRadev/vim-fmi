class SignUpsController < ApplicationController
  before_action :require_admin

  def index
    @sign_ups = SignUp.all
  end

  def create
    @sign_up = SignUp.new(params.require(:sign_up).permit(:faculty_number, :full_name))

    if @sign_up.save
      redirect_to sign_ups_path, notice: 'Готово, студентът е записан.'
    else
      index
      render :index
    end
  end
end
