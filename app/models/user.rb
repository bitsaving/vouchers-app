class User < ActiveRecord::Base
  acts_as_paranoid
  include PublicActivity::Common
  has_many :notifications
  has_many :vouchers,:foreign_key=>"creator_id"
  has_many :comments
  devise :database_authenticatable, :omniauthable,
          :recoverable, :rememberable, :trackable,  :omniauth_providers => [:google_oauth2]
  validates :first_name,:last_name,:email ,presence: true
  validates :email, uniqueness: true

   def self.from_omniauth(access_token, signed_in_resource=nil)
      data = access_token.info
      user = User.where(:email => data["email"]).first
    user
  end

end
