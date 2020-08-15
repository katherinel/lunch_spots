class ApplicationController < ActionController::Base
  protect_from_forgery unless: -> { request.format.json? }
  before_action :authorized

  def authorized
    render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
  end

  def encode_token(payload)
    payload[:exp] = 2.hours.from_now.to_i
    JWT.encode(payload, Rails.application.credentials.dig(:jwt_secret))
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

  def logged_in_user
    return unless decoded_token

    user_id = decoded_token[0]['user_id']
    @user = User.find_by(id: user_id)
  end

  def logged_in?
    !!logged_in_user
  end
end
