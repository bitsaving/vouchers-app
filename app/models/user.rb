class User < ActiveRecord::Base
  acts_as_paranoid
  has_many :vouchers,:foreign_key=>"creator_id"
  has_many :comments
<<<<<<< HEAD
  devise :database_authenticatable, :omniauthable,
          :recoverable, :rememberable, :trackable,  :omniauth_providers => [:google_oauth2]
  validates :first_name,:last_name,:email ,presence: true
  validates :email, uniqueness: true

   def self.from_omniauth(access_token, signed_in_resource=nil)
      data = access_token.info
      user = User.where(:email => data["email"]).first
=======
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
>>>>>>> 3cd885915b7726b2726707acbcdba4561818f7e6
    user
  end

end
