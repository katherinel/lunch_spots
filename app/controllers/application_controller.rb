class ApplicationController < ActionController::Base
  protect_from_forgery unless: -> { request.format.json? }
  # before_action :authorized

  def authorized
    render json: { error: 'JWT is invalid' }, status: :unauthorized unless logged_in?
  end

  def encode_token(payload)
    token_life = 2.hours
    cache_key = "jwt.#{payload[:user_id]}"

    token_expiry = token_life.from_now.to_i

    Rails.cache.fetch(cache_key, expires_in: token_life) do
      payload[:exp] = token_expiry
      {
        token: JWT.encode(payload, Rails.application.credentials.dig(:jwt_secret)),
        expires_at: Time.at(token_expiry)
      }
    end
  end

  # Devise redirects
  def after_sign_in_path_for(resource)
    profile_path(current_user)
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  private

  def auth_header
    # { Authorization: 'Bearer <token>' }
    request.headers['Authorization']
  end

  def decoded_token
    return unless auth_header

    token = auth_header.split(' ')[1]
    # header: { 'Authorization': 'Bearer <token>' }
    begin
      JWT.decode(token, Rails.application.credentials.dig(:jwt_secret), true, algorithm: 'HS256')
    rescue JWT::DecodeError
      nil
    end
  end

  def api_key_match

  end

  def logged_in_user
    return unless decoded_token

    user_id = decoded_token[0]['user_id']
    @user = User.find_by(id: user_id)
  end

  def logged_in?
    !!logged_in_user
  end
end
