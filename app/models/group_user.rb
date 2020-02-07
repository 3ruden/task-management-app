class GroupUser < ApplicationRecord
  belongs_to :group
  belongs_to :user

  validates :group_id, uniqueness: { scope: :user_id }
  validates :group_id, uniqueness: { scope: :owner }, if: :owner?

end
