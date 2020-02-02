class UsersController < ApplicationController
  before_action :authenticate_user, only: [:show]
  before_action :forbid_login_user, only: %i(new create)
  before_action :ensure_correct_user, only: [:show]

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to @user, notice: 'アカウントを作成し、ログインしました'
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def ensure_correct_user
    redirect_to tasks_url unless current_user.id == params[:id].to_i
  end
end
