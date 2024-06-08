class Task < ApplicationRecord
    belongs_to :user
    has_many :user_tasks, dependent: :destroy
  
    validates :task_name, presence: true
    validates :status, presence: true
    validates :user_id, presence: true
    validate :due_date_in_future

    private

    def due_date_in_future
        errors.add(:due_date, 'must be in the future') if due_date && due_date < Date.today
    end
end
