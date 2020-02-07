class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }
  validates :email,
    presence: true,
    length: { maximum: 255 },
    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
    uniqueness: true
  before_validation { email.downcase! }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, on: :create

  has_many :tasks, dependent: :destroy
  has_many :group_users, dependent: :destroy
  has_many :groups, through: :group_users, source: :group

  before_destroy do
    throw :abort if User.where(admin: true).count < 2 && self.admin
  end

  after_update do
    if User.where(admin: true).count < 1
      self.errors.add(:admin, 'を削除できません')
      raise ActiveRecord::Rollback
    end
  end
end
