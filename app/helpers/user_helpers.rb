# app/helpers/user_helpers.rb
module UserHelpers
    extend Grape::API::Helpers
  
    def create_user(params)
      user = User.new(
        email: params[:email],
        password: params[:password],
        password_confirmation: params[:password],
        role: "user"
      )
      if user.save
        payload = { 
          user_id: user.id,
          expires_at: 24.hours.from_now
        }
        token = JWT.encode(payload, "authorization")
        present access_token: token, email: user.email, message: "User signed up successfully"
      else
        error!(user.errors.full_messages, 422)
      end
    end

    def generate_token(user)
      payload = {
        user_id: user.id,
        expires_at: 24.hours.from_now
      }
      token = JWT.encode(payload, "authorization")
      present access_token: token, email: user.email
    end
  end
  