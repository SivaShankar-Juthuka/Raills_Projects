# app/helpers/auth_helpers.rb
module AuthHelper
  def authenticate!
    token = request.headers['authorization']&.split(' ')&.last
    puts "Extracted Token: #{token}"
    if token
      begin
        # Decode the token
        payload = JWT.decode(token, 'authorization').first
        expires_at = payload['expires_at']
        # Check if the token has expired
        if expires_at < Time.now
          BlacklistedToken.create!(token: token)
          error!('Token Expired', 401)
        elsif BlacklistedToken.exists?(token: token)
          error!('Token is blacklisted ----------', 401)
        else
          user_id = payload['user_id']
          Current.user = User.find_by(id: user_id)
          error!('Unauthorized - Invalid token', 401) if Current.user.nil?
        end
      rescue JWT::DecodeError
        error!('Unauthorized - Invalid token', 401)
      end
    else
      error!('Unauthorized - No token provided', 401)
    end
  end
end
