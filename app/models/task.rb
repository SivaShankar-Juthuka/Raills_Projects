class Task < ApplicationRecord
    belongs_to :user 
    has_many :user_tasks
    has_many :assignments, dependent: :destroy
    has_many :assigned_users, through: :assignments, source: :assigned_to

  
    validates :task_name, presence: true, uniqueness: { scope: :user_id, message: "You already have a task with this name." }
    validates :status, presence: true, inclusion: { in: %w[pending in_progress completed], message: "%{value} is not a valid status" }
    validates :due_date, presence: true
    validates :priority_level, presence: true, inclusion: { in: %w[low medium high], message: "%{value} is not a valid priority level" }

    private

    def due_date_cannot_be_in_the_past
        if due_date.present? && due_date < Date.today
        errors.add(:due_date, "can't be in the past")
        end
    end
end
