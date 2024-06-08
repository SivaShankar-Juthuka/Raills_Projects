# app/helpers/auth_helpers.rb
module AuthHelper
  def authenticate!
    token = request.headers['authorization']&.split(' ')&.last
    puts "Extracted Token: #{token}"
    if token
      if BlacklistedToken.exists?(token: token)
        error!('Token Expired', 401)
      else
        begin
          # Decoding token
          payload = JWT.decode(token, 'authorization').first
          user_id = payload['user_id']
          Current.user = User.find(user_id)
          if Current.user.nil?
            error!('Unauthorized - Invalid token', 401)
          end
        rescue JWT::DecodeError
          error!('Unauthorized - Invalid token', 401)
        end
      end
    else
      error!('Unauthorized - No token provided', 401)
    end
  end
end
