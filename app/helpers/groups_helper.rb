module GroupsHelper
  def group_user_current_id(group_id)
    current_user.group_users.find_by(group_id: group_id)
  end
end
