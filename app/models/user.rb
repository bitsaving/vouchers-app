class User < ActiveRecord::Base
  has_many :vouchers
  #devise :omniauthable, :omniauth_providers => [:google_apps]
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  self.inheritance_column = :user_type
  #devise :ominauthable,:omniauth_providers => [:google_oauth2]
   devise :database_authenticatable, :registerable, :omniauthable,
          :recoverable, :rememberable, :trackable, :validatable, :omniauth_providers => [:google_oauth2]


# def self.from_omniauth(auth)
#     if user = User.find_by_email(auth.info.email)
#       user.provider = auth.provider
#       user.uid = auth.uid
#       user
#     else
#       where(auth.slice(:provider, :uid)).first_or_create do |user|
#         # user.provider = auth.provider
#         # user.uid = auth.uid
#         user.username = auth.info.name
#         user.email = auth.info.email
#       end
#     end
#   end

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


# def self.find_for_googleapps_oauth(access_token, signed_in_resource=nil)
#   data = access_token['info']
  
#   if user = User.where(:email => data['email']).first 
#     return user
#   else #create a user with stub pwd
#     User.create!(:email => data['email'], :password => Devise.friendly_token[0,20])
#   end
# end

# def self.new_with_session(params, session)
#   super.tap do |user|
#     if data = session['devise.googleapps_data'] && session['devise.googleapps_data']['user_info']
#       user.email = data['email']
#     end
#   end
# end
end
