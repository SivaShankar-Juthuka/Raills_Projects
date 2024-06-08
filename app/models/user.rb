class User < ApplicationRecord
    has_secure_password
    has_many :tasks
    has_many :created_tasks, class_name: 'Task', foreign_key: 'user_id'
    has_many :assigned_tasks, class_name: 'UserTask', foreign_key: 'assigned_to_id'
    has_many :assigned_by_tasks, class_name: 'UserTask', foreign_key: 'assigned_by_id'
  
    before_validation :set_default_user, on: :create
    
    VALID_EMAIL_REGEX = /\A[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\z/

    validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX, message: "Please enter a valid email address." }
    validates :password, presence: true, length: { minimum: 6 }
    validates :role, presence: true, inclusion: { in: %w[admin user], message: "%{value} is not a valid role" }

    def admin?
        role == 'admin'
    end

    private
    def set_default_user
        if self.role != 'admin'
            self.role = 'user'
        end
    end
end
