class Task < ApplicationRecord
  belongs_to :user
  has_many :user_tasks, dependent: :destroy
  has_many :sub_tasks, dependent: :destroy

  STATUS_IN_PROGRESS = 'in_progress'
  STATUS_COMPLETED = 'completed'

  validates :task_name, presence: true
  validates :status, presence: true
  validates :user_id, presence: true
  validate :due_date_in_future

  after_create :assign_sub_tasks_to_user,  if: :sub_tasks_present?

  def assign_sub_tasks_to_user(assigned_to, assigned_by)
    # return if sub_tasks.empty?
    sub_tasks.each do |sub_task|
      UserTask.create!(
        task_id: sub_task.task_id,
        assigned_to: assigned_to,
        assigned_by: assigned_by,
        status: sub_task.status
      )
    end
  end

  def update_status_if_all_completed
    if sub_tasks.exists? && sub_tasks.where.not(status: STATUS_COMPLETED).exists?
      update!(status: STATUS_IN_PROGRESS)
    elsif user_tasks.exists? && user_tasks.where.not(status: STATUS_COMPLETED).exists?
      update!(status: STATUS_IN_PROGRESS)
    else
      update!(status: STATUS_COMPLETED)
    end
  end

  private

  def sub_tasks_present?
    sub_tasks.any?
  end

  def due_date_in_future
    errors.add(:due_date, 'must be in the future') if due_date && due_date < Date.today
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[created_at due_date id status task_name updated_at user_id]
  end
end