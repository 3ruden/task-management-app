class GroupsController < ApplicationController
  before_action :set_group, only: %i(show edit update destroy)
  before_action :authenticate_user
  before_action :authenticate_group_owner, only: %i(edit update destroy)

  def index
    @groups = Group.all.page(params[:page])
  end

  def show
    @tasks = Task.where(user_id: @group.users.ids).page(params[:page]).includes(:user)
  end

  def new
    @group = Group.new
  end

  def edit; end

  def create
    params['group']['user_ids'] = [current_user.id]
    @group = Group.new(group_params)
    if @group.save
      @group_user = current_user.group_users.find_by(group_id: @group.id)
      @group_user.update(owner: true)
      redirect_to @group, notice: 'グループを作成しました'
    else
      render :new
    end
  end

  def update
    if @group.update(group_params)
      redirect_to @group, notice: 'グループを編集しました'
    else
      render :eidt
    end
  end

  def destroy
    @group.destroy
    redirect_to groups_url, notice: 'グループを削除しました'
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:name, :content, user_ids: [])
  end

  def authenticate_group_owner
    unless view_context.group_user_current_id(params[:id]).try(:owner?)
      redirect_to groups_url
    end
  end
end
