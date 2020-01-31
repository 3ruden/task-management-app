class User < ApplicationRecord
  validates_presence_of :name, :email, :password
  validates :name, length: { maximum: 30 }
  validates :email,
    length: { maximum: 255 },
    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
    uniqueness: true
  before_validation { email.downcase! }
  has_secure_password
  validates :password, length: { minimum: 6 }

  has_many :tasks, dependent: :destroy
end
