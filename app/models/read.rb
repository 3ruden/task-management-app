class Read < ApplicationRecord
  belongs_to :task
  belongs_to :user

  def self.missing_record?(task_id, user_id)
    where(task_id: task_id).find_by(user_id: user_id).blank?
  end

end
