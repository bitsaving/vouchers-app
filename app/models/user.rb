class User < ActiveRecord::Base
  has_many :vouchers
  has_many :comments
  #FIXME_AB: Since we are using vinsol.com email authentication. Please take care of what we need from devise and what not
  devise :database_authenticatable, :registerable, :omniauthable,
          :recoverable, :rememberable, :trackable, :validatable, :omniauth_providers => [:google_oauth2]

  #FIXME_AB: Code formatting
  def self.from_omniauth(access_token, signed_in_resource=nil)
     data = access_token.info
     #FIXME_AB: what if data[email] is nill
    user = User.where(:email => data["email"]).first

    unless user
        user = User.create(name: data["name"],
             email: data["email"],
             #FIXME_AB: Why we need to generate password. Since we would not be using it
             password: Devise.friendly_token[0,20]
            )
    end
    user
  end
end
