class UserTask < ApplicationRecord
  belongs_to :task
  belongs_to :assigned_by_user, class_name: 'User', foreign_key: 'assigned_by'
  belongs_to :assigned_to_user, class_name: 'User', foreign_key: 'assigned_to'

  after_save :update_task_status, if: :user_task_updated? # call back

  validates :task_id, presence: true
  validates :assigned_to, presence: true
  validates :assigned_by, presence: true
  validates :status, presence: true

  private  

  def user_task_updated?
    saved_change_to_status? 
  end  

  def update_task_status
    task.update_status_if_all_completed
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[id status assigned_by assigned_to]
  end
end
