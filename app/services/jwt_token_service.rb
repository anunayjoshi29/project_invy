# app/services/jwt_token_service.rb
class JwtTokenService
    SECRET_KEY = Rails.application.secrets.secret_key_base
    TOKEN_EXPIRATION_TIME = 1.day.to_i # Set the token expiration time
  
    def self.encode(payload)
      payload[:exp] = Time.now.to_i + TOKEN_EXPIRATION_TIME
      JWT.encode(payload, SECRET_KEY, 'HS256')
    end
  
    def self.decode(token)
      decoded_token = JWT.decode(token, SECRET_KEY, true, algorithm: 'HS256').first
      decoded_token if decoded_token['exp'] >= Time.now.to_i
    rescue JWT::DecodeError
      nil
    end
  end
  