class Task < ApplicationRecord
    belongs_to :user
    belongs_to :assigned_to, class_name: 'User', foreign_key: 'assigned_to_id', optional: true
    belongs_to :assigned_by, class_name: 'User', foreign_key: 'assigned_by_id', optional: true
  

    validates :priority_level, presence: true
    validates :task_name, presence: true
    validates :status, presence: true
    validates :due_date, presence: true
end
