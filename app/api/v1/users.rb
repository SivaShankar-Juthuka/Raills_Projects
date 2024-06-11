# app/api/v1/users.rb
class Api::V1::Users < Grape::API
  resource :users do

    desc 'User signup'
    params do
      requires :email, type: String, desc: 'User email'
      requires :password, type: String, desc: 'User password'
    end
    desc 'User signup'
    params do
      requires :email, type: String, desc: 'User email'
      requires :password, type: String, desc: 'User password'
    end
    post :signup do
      # Check if the user is already logged in
      token = request.headers['authorization']&.split(' ')&.last
      if token
        begin
          payload = JWT.decode(token, 'authorization').first
          expires_at = payload['expires_at']
          if expires_at > Time.now
            error!('You are already logged in. Please log out to sign up for a new account.', 403)
          end
        rescue JWT::DecodeError
          # If the token is invalid, we'll proceed with the signup
          create_user(params)
        end
      else
        # If the token is not found, we'll proceed with the signup
        create_user(params)
      end
    end

post :login do
  user = User.find_by(email: params[:email])
  if user && user.authenticate(params[:password])
    # Check for existing active token
    token = request.headers['authorization']&.split(' ')&.last
    if token
      begin
        payload = JWT.decode(token, 'authorization').first
        token_user_id = payload['user_id']
        if !BlacklistedToken.exists?(token: token)
          if token_user_id == user.id
            # Existing token matches the user trying to log in
            expires_at = payload['expires_at']
            if expires_at > Time.now
              present token: token, email: user.email
            end
          else
            # User is trying to log in with another user's credentials
            error!('You are already logged in with a different user. Please log out to log in with a different account.', 403)
          end
        else
          # If Token is blacklisted
          generate_token(user)
        end
      rescue JWT::DecodeError
        # Token decode error, generate a new token
        generate_token(user)
      end
    else
      # Generate a new token
      generate_token(user)
    end
  else
    error!('Email or password wrong', 401)
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
      if token
        BlacklistedToken.create!(token: token)
        { message: 'Logged out successfully' }
      else
        error!('Unauthorized - No token provided', 401)
      end
    end 
  end
end