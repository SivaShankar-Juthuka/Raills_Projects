class Task < ApplicationRecord
  # after_save :delete_if_completed

  belongs_to :user
  belongs_to :priority

  validates :priority, presence: true
  validates :task_name, presence: true
  validates :status, presence: true
  validates :due_date, presence: true

  # private
  # def delete_if_completed
  #   self.destroy if self.status == 'completed'
  # end
  
end

