class User < ActiveRecord::Base
  acts_as_paranoid
  include PublicActivity::Common
  has_many :notifications
  has_many :vouchers,:foreign_key=>"creator_id",:dependent=>:destroy
  has_many :comments ,:dependent=>:destroy
  devise :database_authenticatable, :omniauthable,
          :recoverable, :rememberable, :trackable,  :omniauth_providers => [:google_oauth2]
  validates :first_name,:last_name,:email ,presence: true
  validates :email, uniqueness: true
  before_destroy :ensure_an_admin_remains

   def self.from_omniauth(access_token, signed_in_resource=nil)
      data = access_token.info
      user = User.where(:email => data["email"]).first
    user
  end
 
  private
    def ensure_an_admin_remains
      if User.count == 1
        Rails.logger.debug "DFDFDF"
        raise "Can't delete last user"
      end
    end     
end
