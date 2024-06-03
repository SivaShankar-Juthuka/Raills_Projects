class Assignment < ApplicationRecord
    belongs_to :task
    belongs_to :assigned_to, class_name: 'User'
    belongs_to :assigned_by, class_name: 'User'
  
    validates :task_id, presence: true
    validates :assigned_to_id, presence: true
    validates :assigned_by_id, presence: true
    validate :assigned_to_cannot_be_assigned_by
  
    private
  
    def assigned_to_cannot_be_assigned_by
      if assigned_to_id == assigned_by_id
        errors.add(:assigned_to_id, "can't be the same as the assigning user")
      end
    end
    
end