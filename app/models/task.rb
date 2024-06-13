class Task < ApplicationRecord
  belongs_to :user
  has_many :user_tasks, dependent: :destroy

  validates :task_name, presence: true
  validates :status, presence: true
  validates :user_id, presence: true
  validate :due_date_in_future

  def update_status_if_all_completed
    if user_tasks.where.not(status: 'completed').exists?
      update!(status: 'in progress')
    else
      update!(status: 'completed')
    end
  end

  private
  def due_date_in_future
    errors.add(:due_date, 'must be in the future') if due_date && due_date < Date.today
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[created_at due_date id status task_name updated_at user_id]
  end
end
