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

  before_destroy do
    throw :abort if User.where(admin: true).count == 1 && self.admin
  end

  def admin_last_one?(params_admin)
    User.where(admin: true).count == 1 && self.admin && ActiveRecord::Type::Boolean.new.cast(params_admin).blank?
  end

  def is_admin_user?
    self.present? && self.admin?
  end
end
