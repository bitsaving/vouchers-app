class User < ActiveRecord::Base
  has_many :vouchers
  has_many :comments
  devise :database_authenticatable, :registerable, :omniauthable,
          :recoverable, :rememberable, :trackable, :validatable, :omniauth_providers => [:google_oauth2]

  def self.from_omniauth(access_token, signed_in_resource=nil)
     data = access_token.info
    user = User.where(:email => data["email"]).first

    unless user
        user = User.create(name: data["name"],
             email: data["email"],
             password: Devise.friendly_token[0,20]
            )
    end
    user
  end
end
