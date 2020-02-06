class Label < ApplicationRecord
  has_many :task_labels, dependent: :destroy
  has_many :tasks, through: :task_labels, source: :task

  validates :name,
    presence: true,
    length: { maximum: 20 },
    uniqueness: true
end
