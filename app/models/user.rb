class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_create :generate_api_key

  def generate_api_key
    api_key = SecureRandom.urlsafe_base64(16)
    update_attribute(:api_key, api_key)
  end
end
