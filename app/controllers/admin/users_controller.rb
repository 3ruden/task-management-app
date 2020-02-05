class Admin::UsersController < ApplicationController
  before_action :admin_user
  before_action :set_user, only: %i(edit update destroy)

  def index
    @users = User.all.order(created_at: :DESC)
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_url,
        notice: 'ユーザーを作成しました'
    else
      render :new
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_users_url,
        notice: 'ユーザーを編集しました'
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      redirect_to admin_users_url,
        notice: 'ユーザーを削除しました'
    else
      redirect_to admin_users_url,
        notice: '管理者がなくなるため、削除できません'
    end
  end

  private

  def admin_user
    redirect_to root_path unless current_user.try(:admin?)
  end

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :password,
      :password_confirmation,
      :admin,
    )
  end

  def set_user
    @user = User.find(params[:id])
  end
end
