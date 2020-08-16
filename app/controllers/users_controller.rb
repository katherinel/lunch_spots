class UsersController < ApplicationController
  before_action :authorized, except: %i[create request_token show]

  def create
    @user = User.create(user_params)
    if @user.valid?
      token = encode_token({ user_id: @user.id })
      render json: { user: @user, token: token }
    else
      render json: { error: 'Invalid email or password' }
    end
  end

  def request_token
    @user = User.find_by(email: params[:email])

    if @user&.api_key = params[:api_key]
      token = encode_token({ user_id: @user.id })
      expires_at = Time.at(@token_expiry)
      render json: { token: token, expires_at: expires_at }
    else
      render json: { error: 'Invalid email or API key' }
    end
  end

  def show
    redirect_to :new_user_session unless user_signed_in?
  end

  private

  def user_params
    params.permit(:email, :api_key)
  end
end
