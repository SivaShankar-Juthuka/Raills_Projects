class User < ApplicationRecord
  has_many :created_tasks, class_name: 'Task', foreign_key: 'user_id', dependent: :destroy
  has_many :assigned_tasks, class_name: 'Assignment', foreign_key: 'assigned_to_id', dependent: :destroy
  has_many :tasks_assigned_to, through: :assigned_tasks, source: :task

  has_many :assignments_made, class_name: 'Assignment', foreign_key: 'assigned_by_id', dependent: :destroy
  has_many :tasks_assigned_by_me, through: :assignments_made, source: :task

  has_many :tasks
  has_secure_password

  before_validation :set_default_role, on: :create

  VALID_EMAIL_REGEX = /\A[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\z/

  validates :email, presence: true, uniqueness: true, format: {with: VALID_EMAIL_REGEX, message: "Please enter a valid email address."}
  validates :password, presence: true, length: { minimum: 6 }
  validates :role, presence: true, inclusion: { in: %w[admin user], message: "%{value} is not a valid role" }

  def admin?
      role == 'admin'
  end   

  private

  def set_default_role
    self.role ||= 'user'
  end

end