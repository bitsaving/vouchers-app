class User < ActiveRecord::Base
  acts_as_paranoid
  include PublicActivity::Common
  has_many :notifications , :class_name => "PublicActivity::Activity", :foreign_key => "owner_id"
  has_many :vouchers , :foreign_key => "creator_id" , :dependent => :destroy
  has_many :comments , :dependent => :destroy
  devise :database_authenticatable , :omniauthable ,
    :recoverable , :rememberable , :trackable , :omniauth_providers => [:google_oauth2]
  #FIXME_AB: You may need other associations like assigned_vouchers, owned_vouchers etc..
  #FIXME_AB: Please ensure proper code formatting. space after comma. Space after comma not before comma.
  validates :first_name , :last_name , :email , presence: true
  validates :email, uniqueness: true , :case_sensitive => false
  before_destroy :ensure_atleast_one_user_remains

  def self.from_omniauth(access_token , signed_in_resource = nil)
    data = access_token.info
    user = User.where(:email => data["email"]).first
  end

  def admin?
    user_type == "admin"
  end

  # def notifications
  #   PublicActivity::Activity.where()
  private


  def ensure_atleast_one_user_remains
    #FIXME_AB: where are you checking that this user is an admin?
    if User.count == 1
      raise "Can't delete last user"
    end
  end
end