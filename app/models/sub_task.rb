class SubTask < ApplicationRecord
  belongs_to :task
  has_many :user_tasks

  validates :sub_task_name, presence: true
  validates :status, presence: true
  validates :task_id, presence: true
  validate :due_date_in_future

  STATUS_IN_PROGRESS = 'in_progress'
  STATUS_COMPLETED = 'completed'

  after_save :update_parent_task_status

  def can_be_started_by?(user_id)
    # Checking weather this user is assigned to this subtask
    return false unless task.user_tasks.exists?(assigned_to: user_id)
    # Getting previous subtasks by order id
    previous_sub_task = task.sub_tasks.order(:id).where('id < ?', id).last
    puts previous_sub_task, "********************************"
    # If there is no previous sub-task or it is completed, this sub-task can be started
    previous_sub_task.nil? || previous_sub_task.status == STATUS_COMPLETED
  end

  private
  def update_parent_task_status
    task.update_status_if_all_completed
  end

  def due_date_in_future
    errors.add(:due_date, 'must be in the future') if due_date && due_date < Date.today
  end
end
