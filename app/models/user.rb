class User < ApplicationRecord
    has_many :tasks
    has_secure_password

    VALID_EMAIL_REGEX = /\A[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\z/

    validates :email, presence: true, uniqueness: true, format: {with: VALID_EMAIL_REGEX, message: "Please enter a valid email address."}
    validates :password, presence: true, length: { minimum: 6 }
end
