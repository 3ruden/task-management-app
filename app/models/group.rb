class Group < ApplicationRecord
  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users, source: :user

  validates :name, presence: true, length: { maximum: 30 }
  validates :content, length: { maximum: 200 }

end
