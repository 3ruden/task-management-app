class Task < ApplicationRecord
  validates_presence_of :title, :content, :deadline, :status, :priority

  enum status: {not_started_yet: 0, get_started: 1, finished: 2}
  enum priority: {low: 0, medium: 1, high: 2}

  scope :get_search_title, -> (title_search) {
    return if title_search.blank?
    where(['title LIKE ?', "%#{title_search}%"])
  }

  scope :get_search_status, -> (status_search) {
    return if status_search.blank?
    where(status: status_search)
  }

  scope :get_search_label, -> (label_id) {
    return if label_id.blank?
    joins(:labels).where(labels: {id: label_id})
  }

  scope :search_result, -> (title_search, status_search, label_id, page_params) {
    get_search_title(title_search).
    get_search_status(status_search).
    get_search_label(label_id).
    page10(page_params)
  }

  scope :page10, -> (page_params) {
    page(page_params).per(10)
  }

  scope :seen_by_admin, -> (user_id_params, page_params) {
    where(user_id: user_id_params).page10(page_params).includes(:user)
  }

  belongs_to :user
  has_many :task_labels, dependent: :destroy
  has_many :labels, through: :task_labels, source: :label
end
