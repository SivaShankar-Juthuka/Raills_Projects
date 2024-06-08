class UserTask < ApplicationRecord
    belongs_to :task
    belongs_to :assigned_by_user, class_name: 'User', foreign_key: 'assigned_by'
    belongs_to :assigned_to_user, class_name: 'User', foreign_key: 'assigned_to'
  
  
    validates :task_id, presence: true
    validates :assigned_to_id, presence: true
    validates :assigned_by_id, presence: true
    validates :status, presence: true    
    validate :due_date_in_future

    private

    def due_date_in_future
        errors.add(:due_date, 'must be in the future') if due_date && due_date < Date.today
    end
end
