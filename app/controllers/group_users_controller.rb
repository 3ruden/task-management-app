class GroupUsersController < ApplicationController
  before_action :authenticate_user

  def create
    params['user_id'] = current_user.id
    @group_user = GroupUser.new(group_users_params)
    if @group_user.save
      redirect_to group_url(@group_user.group_id), notice: 'グループに参加しました'
    else
      redirect_to groups_url, notice: 'グループに参加できません'
    end
  end

def destroy
  @group_user = GroupUser.find_by(group_id: params[:id], user_id: current_user.id)
  if @group_user.destroy
    redirect_to groups_url, notice: 'グループを離脱しました'
  else
    redirect_to groups_url, notice: 'グループを離脱できません'
  end
end

  private

  def group_users_params
    params.permit(:group_id, :user_id)
  end
end
