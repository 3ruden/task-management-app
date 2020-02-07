class GroupUser < ApplicationRecord
  belongs_to :group
  belongs_to :user

  validates :group_id, uniqueness: { scope: :user_id }
  validates :group_id, uniqueness: { scope: :owner }, if: :owner?

  after_destroy do
    if GroupUser.where(owner: true).count < 1
      raise ActiveRecord::Rollback
    end
  end
end
