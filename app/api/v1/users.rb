# app/api/v1/users.rb
class Api::V1::Users < Grape::API
  resource :users do
    desc 'User signup'
    params do
      requires :email, type: String, desc: 'User email'
      requires :password, type: String, desc: 'User password'
      requires :password_confirmation, type: String, desc: 'Password confirmation'
      optional :role, type: String, desc: 'Role'
    end
    post :signup do
      role = params[:role] || "user"
      user = User.new(
        email: params[:email],
        password: params[:password],
        password_confirmation: params[:password_confirmation],
        role: role
      )
      if user.save
        payload = {
          user_id: user.id,
        }
        token = JWT.encode(payload, "authorization")
        present access_token: token, email: user.email
      else
        error!(user.errors.full_messages, 422)
      end
    end

    desc 'User login'
    params do
      requires :email, type: String, desc: 'User email'
      requires :password, type: String, desc: 'User password'
    end
    post :login do
      user = User.find_by(email: params[:email])
      if user && user.authenticate(params[:password])
        payload = {
          user_id: user.id,
          expires_at: Time.now
        }
        token = JWT.encode(payload, "authorization")
        present access_token: token, email: user.email
      else
        error!('email or password wrong', 401)
      end
    end

    before do
       authenticate! 
    end

    desc 'All users'
    params do
      optional :page, type: Integer, desc: 'Page number', default: 1
      optional :per_page, type: Integer, desc: 'Number of items per page', default: 10
    end 
    get do
      if Current.user.admin?
        user = paginate(User.all)
        present user
      else
        error!('Unauthorized access role must be admin', 401)
      end
    end

    desc 'User logout'
    params do
      requires :token, type: String, desc: 'User token'
    end
    delete :logout do
      token = request.headers['authorization']&.split(' ')&.last
      # puts token, "%%%%%%%%%%%%%%5"
      if token
        BlacklistedToken.create!(token: token)
        { message: 'Logged out successfully' }
      else
        error!('Unauthorized - No token provided', 401)
      end
    end 
  end
end
