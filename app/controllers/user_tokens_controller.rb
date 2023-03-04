class UserTokensController < ApplicationController
  before_action :require_user, except: %(activate)
  skip_before_action :verify_authenticity_token, only: :activate

  def index
    @user_tokens = current_user.user_tokens.visible
  end

  def new
    @user_token = UserToken.new(body: SecureRandom.hex)
  end

  def create
    @user_token = current_user.user_tokens.new(user_token_params)

    if @user_token.save
      redirect_to({ action: :index }, notice: 'Токена е създаден успешно, сега го активирайте')
    else
      render :new
    end
  end

  def activate
    user_token = UserToken.inactive.find_by(body: params[:token])
    meta = params.require(:meta)

    respond_to do |format|
      if user_token
        user_token.update!(meta: meta, activated_at: Time.current)
        user = user_token.user

        format.json { render json: { id: user.id, faculty_number: user.faculty_number } }
      else
        format.json { render json: { status: 'failed' }, status: 400 }
      end
    end
  end

  def edit
    @user_token = current_user.user_tokens.find(params[:id])
  end

  def update
    @user_token = current_user.user_tokens.find(params[:id])

    if @user_token.update(task_params)
      redirect_to({ action: :index }, notice: 'Токена е обновен успешно')
    else
      render :edit
    end
  end

  def destroy
    @user_token = current_user.user_tokens.find(params[:id])
    @user_token.trash

    redirect_to({ action: :index }, notice: 'Токена е премахнат')
  end

  private

  def user_token_params
    params.require(:user_token).permit(:label, :body)
  end
end
